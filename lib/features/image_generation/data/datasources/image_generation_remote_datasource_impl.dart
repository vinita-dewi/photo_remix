import 'package:cloud_functions/cloud_functions.dart';
import 'image_generation_remote_datasource.dart';

class ImageGenerationRemoteDataSourceImpl
    implements ImageGenerationRemoteDataSource {
  final FirebaseFunctions functions;

  ImageGenerationRemoteDataSourceImpl({FirebaseFunctions? functions})
      : functions = functions ?? FirebaseFunctions.instance;

  @override
  Future<void> generateImage({
    required String categoryId,
    required String categoryName,
    required String imagePath,
  }) async {
    final callable = functions.httpsCallable('generateImage');
    try {
      await callable.call(<String, dynamic>{
        'categoryId': categoryId,
        'categoryName': categoryName,
        'imagePath': imagePath,
      });
    } on FirebaseFunctionsException catch (e) {
      // Surface a readable error while keeping the stack for higher layers.
      throw Exception(e.message ?? 'Failed to generate image');
    } catch (e) {
      throw Exception('Failed to generate image: $e');
    }
  }
}
