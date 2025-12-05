// Remote data source for image generation
abstract class ImageGenerationRemoteDataSource {
  Future<void> generateImage({
    required String categoryId,
    required String categoryName,
    required String imagePath,
  });
}

