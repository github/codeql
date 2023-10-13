---
category: minorAnalysis
---
* The query "Incorrect conversion between integer types" (`go/incorrect-integer-conversion`) has been improved. It can now detect parsing an unsigned integer type (like `uint32`) and converting it to the signed integer type of the same size (like `int32`), which may lead to more results. It also treats `int` and `uint` more carefully, which may lead to more results or fewer incorrect results.
