import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/domain/usecases/ensure_signed_in_usecase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/image_generation/presentation/bloc/image_gen_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _configureEmulators();
  runApp(const MyApp());
}

Future<void> _configureEmulators() async {
  // Always point Storage at the local emulator to avoid writing to production during dev.
  const storageEmulatorPort = 9197;
  const overrideHost = String.fromEnvironment('STORAGE_EMULATOR_HOST');
  final storageHost = overrideHost.isNotEmpty
      ? overrideHost
      : kIsWeb
          ? '127.0.0.1'
          : (Platform.isAndroid ? '10.0.2.2' : '127.0.0.1');
  // Log the host/port we target; useful when debugging emulator connectivity.
  debugPrint('Using storage emulator at $storageHost:$storageEmulatorPort');
  FirebaseStorage.instance.useStorageEmulator(storageHost, storageEmulatorPort);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(FirebaseAuth.instance),
    );
    final ensureSignedIn = EnsureSignedIn(authRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(ensureSignedIn)..add(AuthStarted()),
        ),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => ImageGenBloc()),
      ],
      child: MaterialApp(
        title: 'Photo Remix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomePage(),
      ),
    );
  }
}
