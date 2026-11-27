---
category: minorAnalysis
---
* Module declarations inside literal-path `include!` expansions are now resolved relative to the included file, including nested includes. Token tree text is available through `TokenTree.getText()`.