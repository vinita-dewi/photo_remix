// Repository interface for image generation
abstract class ImageGenerationRepository {
  Future<void> generateImage({
    required String categoryId,
    required String categoryName,
    required String imagePath,
  });
}

