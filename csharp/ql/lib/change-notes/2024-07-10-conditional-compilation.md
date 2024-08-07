---
category: minorAnalysis
---
* The extractor has been changed to not skip source files that have already been seen. This has an impact on source files that are compiled multiple times in the build process. Source files with conditional compilation preprocessor directives (such as `#if`) are now extracted for each set of preprocessor symbols that are used during the build process.
