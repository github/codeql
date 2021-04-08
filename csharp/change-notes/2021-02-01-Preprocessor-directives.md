lgtm,codescanning
* The `PreprocessorDirective` class and its base classes have been added to support
preprocessor directives, such as `#if`, `#define`, `#undef`, `#line`, `#region`,
`#warning`, `#error`, `#pragma warning`, `#pragma checksum` and `#nullable`. Furthermore,
`#line` directives are now taken into account when querying the location of any
code construct. Files referenced in preprocessor directives are also included in the
extraction sources. This change is expected to lead to better error reporting locations
in generated code, such as generated code from `.cshtml` files in ASP.NET Core.
