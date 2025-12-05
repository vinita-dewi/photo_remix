import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:photo_remix/core/logging/app_logger.dart';
import 'image_gen_event.dart';
import 'image_gen_state.dart';

/// Bloc responsible for picking/storing the selected image (gallery/camera).
class ImageGenBloc extends Bloc<ImageGenEvent, ImageGenState> {
  final ImagePicker _picker;
  final _log = AppLogger.instance;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  ImageGenBloc({ImagePicker? picker})
    : _picker = picker ?? ImagePicker(),
      _auth = FirebaseAuth.instance,
      _storage = FirebaseStorage.instance,
      _firestore = FirebaseFirestore.instance,
      _functions = FirebaseFunctions.instance,
      super(ImageGenState.initial()) {
    on<PickFromGallery>(_onPickFromGallery);
    on<PickFromCamera>(_onPickFromCamera);
    on<ImagePicked>(_onImagePicked);
    on<ClearImage>(_onClearImage);
    on<GenerateImageRequested>(_onGenerateRequested);
    on<CategorySelected>(_onCategorySelected);
  }

  Future<void> _onPickFromGallery(
    PickFromGallery event,
    Emitter<ImageGenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, isGenerating: false));
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }
      add(ImagePicked(file));
    } catch (e, s) {
      _log.e('pick from gallery failed', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onPickFromCamera(
    PickFromCamera event,
    Emitter<ImageGenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, isGenerating: false));
    try {
      final file = await _picker.pickImage(source: ImageSource.camera);
      if (file == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }
      add(ImagePicked(file));
    } catch (e, s) {
      _log.e('pick from camera failed', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onImagePicked(ImagePicked event, Emitter<ImageGenState> emit) {
    _log.i('image picked: ${event.file.path}');
    emit(
      state.copyWith(
        imagePath: event.file.path,
        isLoading: false,
        error: null,
        showResult: false,
      ),
    );
  }

  void _onClearImage(ClearImage event, Emitter<ImageGenState> emit) {
    emit(ImageGenState.initial());
  }

  Future<void> _onGenerateRequested(
    GenerateImageRequested event,
    Emitter<ImageGenState> emit,
  ) async {
    if (state.imagePath == null || state.categoryId == null) return;
    if ((state.categoryName ?? '').isEmpty) {
      emit(state.copyWith(error: 'Category not selected'));
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      emit(state.copyWith(error: 'Not signed in'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isGenerating: true,
        error: null,
        showResult: false,
        progress: 0.1,
        generatedImageUrls: [],
        originalImageId: null,
      ),
    );

    try {
      final file = File(state.imagePath!);
      final originalBytes = await file.readAsBytes();
      final mimeType = _inferMimeType(state.imagePath!);

      // 1) Upload original image to storage
      final originalUrl = await _uploadImage(
        state.imagePath!,
        user.uid,
        bytes: originalBytes,
        directory: 'original_images',
      );
      emit(state.copyWith(progress: 0.35));
      if (originalUrl.isEmpty) {
        throw Exception('Upload returned an empty download URL');
      }

      // 2) Save original image record
      final originalDocId = await _saveOriginalImageRecord(
        userId: user.uid,
        downloadUrl: originalUrl,
        categoryId: state.categoryId!,
        categoryName: state.categoryName ?? '',
      );
      emit(state.copyWith(progress: 0.45, originalImageId: originalDocId));

      // 3) Call Cloud Function to generate new images
      final generatedImageBytes = await _generateImagesFromFunction(
        category: state.categoryName ?? state.categoryId ?? '',
        baseImageBytes: originalBytes,
        mimeType: mimeType,
      );
      emit(state.copyWith(progress: 0.65));

      // 4) Upload generated images to storage
      final generatedUrls = await _uploadGeneratedImages(
        generatedImageBytes,
        user.uid,
        originalDocId,
        mimeType,
      );
      emit(state.copyWith(progress: 0.8));

      // 5) Save generated image records
      await _saveGeneratedImagesRecords(
        userId: user.uid,
        originalImageId: originalDocId,
        categoryId: state.categoryId!,
        categoryName: state.categoryName ?? '',
        urls: generatedUrls,
      );
      emit(state.copyWith(progress: 0.9));

      // 6) Fetch generated images for display
      final fetched = await _fetchGeneratedImages(
        userId: user.uid,
        originalImageId: originalDocId,
      );

      emit(
        state.copyWith(
          isLoading: false,
          showResult: true,
          isGenerating: false,
          progress: 1.0,
          generatedImageUrls: fetched,
          originalImageId: originalDocId,
        ),
      );
    } catch (e, s) {
      _log.e('generate image failed', error: e, stackTrace: s);
      emit(
        state.copyWith(
          isLoading: false,
          isGenerating: false,
          error: e.toString(),
          progress: 0.0,
        ),
      );
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<ImageGenState> emit,
  ) {
    emit(
      state.copyWith(
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        showResult: false,
      ),
    );
  }

  Future<String> _uploadImage(
    String path,
    String userId, {
    Uint8List? bytes,
    String? fileNameOverride,
    String? directory,
  }) async {
    final file = File(path);
    if (!file.existsSync() && bytes == null) {
      throw Exception('Image file not found at $path');
    }

    final ext = p.extension(path).isNotEmpty ? p.extension(path) : '.jpg';
    final fileName =
        fileNameOverride ?? '${DateTime.now().millisecondsSinceEpoch}$ext';
    final targetDir = directory ?? 'generated_images';
    final ref = _storage.ref().child('$targetDir/$userId/$fileName');
    try {
      final data = bytes ?? await file.readAsBytes();
      if (data.isEmpty) {
        throw Exception('Selected image is empty');
      }
      final contentType = _inferMimeType(path);
      final metadata = SettableMetadata(contentType: contentType);
      _log.i('Uploading image to ${ref.fullPath}');

      final task = ref.putData(data, metadata);
      final snapshot = await task.timeout(
        const Duration(seconds: 20),
        onTimeout:
            () =>
                throw Exception(
                  'Upload timed out. Is the storage emulator running?',
                ),
      );

      final downloadUrl = await snapshot.ref.getDownloadURL().timeout(
        const Duration(seconds: 10),
        onTimeout:
            () =>
                throw Exception(
                  'Download URL timed out. Is the storage emulator reachable?',
                ),
      );

      _log.i('Upload complete. downloadUrl: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      _log.e('upload failed for $path', error: e);
      throw Exception(e.message ?? 'Upload failed');
    }
  }

  Future<String> _saveOriginalImageRecord({
    required String userId,
    required String downloadUrl,
    required String categoryId,
    required String categoryName,
  }) {
    return _firestore
        .collection('Original Image')
        .add({
          'userId': userId,
          'imageUrl': downloadUrl,
          'categoryId': categoryId,
          'categoryName': categoryName,
          'createdAt': FieldValue.serverTimestamp(),
        })
        .then((ref) => ref.id);
  }

  Future<void> _saveGeneratedImagesRecords({
    required String userId,
    required String originalImageId,
    required String categoryId,
    required String categoryName,
    required List<String> urls,
  }) async {
    final batch = _firestore.batch();
    for (final url in urls) {
      final docRef = _firestore.collection('Generated Image').doc();
      batch.set(docRef, {
        'userId': userId,
        'originalImageId': originalImageId,
        'imageUrl': url,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<List<String>> _fetchGeneratedImages({
    required String userId,
    required String originalImageId,
  }) async {
    final snap =
        await _firestore
            .collection('Generated Image')
            .where('userId', isEqualTo: userId)
            .where('originalImageId', isEqualTo: originalImageId)
            .orderBy('createdAt', descending: false)
            .get();
    return snap.docs
        .map((d) => (d.data()['imageUrl'] ?? '') as String)
        .where((url) => url.isNotEmpty)
        .toList();
  }

  Future<List<_GeneratedImage>> _generateImagesFromFunction({
    required String category,
    required Uint8List baseImageBytes,
    required String mimeType,
  }) async {
    final callable = _functions.httpsCallable('generateImage');
    final result = await callable.call(<String, dynamic>{
      'category': category,
      'imageBase64': base64Encode(baseImageBytes),
      'mimeType': mimeType,
    });

    final data = result.data as Map?;
    final images = (data?['images'] as List?) ?? [];
    if (images.isEmpty) {
      throw Exception('No images returned from generator');
    }

    return images.map<_GeneratedImage>((dynamic item) {
      final map = item as Map?;
      final b64 = map?['base64'] as String? ?? '';
      if (b64.isEmpty) {
        throw Exception('Generated image payload missing data');
      }
      final mt = map?['mimeType'] as String? ?? mimeType;
      return _GeneratedImage(bytes: base64Decode(b64), mimeType: mt);
    }).toList();
  }

  Future<List<String>> _uploadGeneratedImages(
    List<_GeneratedImage> images,
    String userId,
    String originalImageId,
    String mimeType,
  ) async {
    final urls = <String>[];
    for (var i = 0; i < images.length; i++) {
      final img = images[i];
      final ext = _extensionFromMime(
        img.mimeType.isNotEmpty ? img.mimeType : mimeType,
      );
      final fileName = '${originalImageId}_$i$ext';
      final url = await _uploadImage(
        'generated',
        userId,
        bytes: img.bytes,
        fileNameOverride: fileName,
        directory: 'generated_images',
      );
      urls.add(url);
    }
    return urls;
  }

  String _inferMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _extensionFromMime(String mime) {
    switch (mime) {
      case 'image/png':
        return '.png';
      case 'image/webp':
        return '.webp';
      default:
        return '.jpg';
    }
  }
}

class _GeneratedImage {
  final Uint8List bytes;
  final String mimeType;

  _GeneratedImage({required this.bytes, required this.mimeType});
}
