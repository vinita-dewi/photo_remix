import '../../domain/repositories/gallery_repository.dart';
import '../datasources/gallery_remote_datasource.dart';

// Repository implementation for gallery
class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryRemoteDataSource remoteDataSource;

  GalleryRepositoryImpl({required this.remoteDataSource});

  // Implement repository methods here
}
