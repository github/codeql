---
category: minorAnalysis
---
* Module declarations and crate-root references in files included with `include!` now resolve correctly, including nested includes, build-script output and its child modules, and active exported macros. Included source files are archived and retain their source classification, semantic availability, and extraction diagnostics. Macro arguments in included files retain their original source locations.