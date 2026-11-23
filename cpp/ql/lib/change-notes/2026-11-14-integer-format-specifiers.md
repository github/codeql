---
category: feature
---
* Added `FormatLiteral.getSuggestedConversionSpecifier` to `semmle.code.cpp.commons.Printf`. It uses the existing conversion-type model to suggest a type-correct replacement that preserves the original conversion's purpose and other format fields.
