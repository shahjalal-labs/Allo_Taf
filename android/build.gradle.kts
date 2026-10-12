allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        // Exclude the problematic transitive dependency of Stripe's push provisioning
        // which is not available in public repositories.
        exclude(group = "com.google.android.gms", module = "play-services-tapandpay")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Safely force all third-party plugins to use compileSdk 36
subprojects {
    // We skip the 'app' module to prevent the "project is already evaluated" crash
    if (project.name != "app") {
        afterEvaluate {
            if (project.hasProperty("android")) {
                project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                    compileSdkVersion(36)
                }
            }
        }
    }
}