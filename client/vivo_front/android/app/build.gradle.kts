import java.util.Properties

// --- Load MAPS_API_KEY from .env (project root) or fallback to local.properties / env var ---
val mapsApiKey: String by lazy {
    val envFile = rootProject.file(".env")
    if (envFile.exists()) {
        val props = Properties().apply { envFile.inputStream().use { load(it) } }
        props.getProperty("MAPS_API_KEY")?.trim().orEmpty()
    } else {
        val localPropsFile = rootProject.file("local.properties")
        val localProps = Properties().apply {
            if (localPropsFile.exists()) localPropsFile.inputStream().use { load(it) }
        }
        localProps.getProperty("MAPS_API_KEY")?.trim()
            ?: System.getenv("MAPS_API_KEY")?.trim()
            ?: ""
    }
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // prefer this in Kotlin DSL
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.vivo_front"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.vivo_front"

        // ✅ Inject placeholder for AndroidManifest.xml
        manifestPlaceholders["mapsApiKey"] = mapsApiKey

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
