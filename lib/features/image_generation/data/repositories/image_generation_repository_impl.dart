import '../../domain/repositories/image_generation_repository.dart';
import '../datasources/image_generation_remote_datasource.dart';

// Repository implementation for image generation
class ImageGenerationRepositoryImpl implements ImageGenerationRepository {
  final ImageGenerationRemoteDataSource remoteDataSource;

  ImageGenerationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> generateImage({
    required String categoryId,
    required String categoryName,
    required String imagePath,
  }) {
    return remoteDataSource.generateImage(
      categoryId: categoryId,
      categoryName: categoryName,
      imagePath: imagePath,
    );
  }
}
