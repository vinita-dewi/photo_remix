plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.photo_remix"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.photo_remix"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
  // Use a Firebase BoM version compatible with the Kotlin version
  // that the current Flutter/AGP toolchain uses. Newer BoMs (34.x)
  // pull in libraries compiled with Kotlin 2.1, which causes
  // "metadata 2.1.0, expected 1.8.0" errors.
  implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
  implementation("com.google.firebase:firebase-analytics")

  // Force measurement libraries to a version compiled with an older
  // Kotlin metadata (compatible with the Kotlin version used here).
  implementation("com.google.android.gms:play-services-measurement-api:22.4.0")
  implementation("com.google.android.gms:play-services-measurement-impl:22.4.0")
}

flutter {
    source = "../.."
}
