---
category: minorAnalysis
---
* Fixed an issue where `Foo::class.java` arguments were dropped during extraction under the Kotlin K2 compiler, which could cause false positives in queries such as `java/android/implicit-pendingintents`.
