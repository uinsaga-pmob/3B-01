allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

<<<<<<< HEAD
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
=======
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
>>>>>>> 3295455aa4e97f0a900b2301153e33dfc9d4032f
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
