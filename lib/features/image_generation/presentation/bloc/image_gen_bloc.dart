import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:photo_remix/core/logging/app_logger.dart';
import 'package:photo_remix/features/image_generation/domain/models/category.dart';
import 'image_gen_event.dart';
import 'image_gen_state.dart';

/// Bloc responsible for picking/storing the selected image (gallery/camera).
class ImageGenBloc extends Bloc<ImageGenEvent, ImageGenState> {
  final ImagePicker _picker;
  final _log = AppLogger.instance;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;

  ImageGenBloc({ImagePicker? picker})
    : _picker = picker ?? ImagePicker(),
      _auth = FirebaseAuth.instance,
      _storage = FirebaseStorage.instance,
      _firestore = FirebaseFirestore.instance,
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
    emit(state.copyWith(isLoading: true, error: null));
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
    emit(state.copyWith(isLoading: true, error: null));
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

    final user = _auth.currentUser;
    if (user == null) {
      emit(state.copyWith(error: 'Not signed in'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, showResult: false));

    try {
      final downloadUrl = await _uploadImage(state.imagePath!, user.uid);
      await _saveImageRecord(
        userId: user.uid,
        downloadUrl: downloadUrl,
        categoryId: state.categoryId!,
        categoryName: state.categoryName ?? '',
      );
      _generateImage(
        category: Category(
          id: state.categoryId!,
          name: state.categoryName ?? '',
        ),
        emit: emit,
      );
      emit(state.copyWith(isLoading: false, showResult: true));
    } catch (e, s) {
      _log.e('generate image failed', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.toString()));
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

  void _generateImage({
    required Category category,
    required Emitter<ImageGenState> emit,
  }) {
    // TODO: implement image generation logic using the selected category.
    _log.i('generate image requested for category: ${category.id}');
  }

  Future<String> _uploadImage(String path, String userId) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('Image file not found at $path');
    }

    final ext = p.extension(path).isNotEmpty ? p.extension(path) : '.jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
    final ref = _storage.ref().child('generated_images/$userId/$fileName');
    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        throw Exception('Selected image is empty');
      }
      final contentType =
          ext.toLowerCase().contains('png') ? 'image/png' : 'image/jpeg';
      final metadata = SettableMetadata(contentType: contentType);
      _log.i('Uploading image', error: null, stackTrace: null);
      final task = await ref.putData(bytes, metadata);
      return await task.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      _log.e('upload failed for $path', error: e);
      throw Exception(e.message ?? 'Upload failed');
    }
  }

  Future<void> _saveImageRecord({
    required String userId,
    required String downloadUrl,
    required String categoryId,
    required String categoryName,
  }) {
    return _firestore.collection('generated_images').add({
      'userId': userId,
      'imageUrl': downloadUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
