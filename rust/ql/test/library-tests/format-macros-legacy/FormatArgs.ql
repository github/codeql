// Reconstructed `FormatArgsExpr` nodes for the format-family macros. On the
// pinned pre-1.94 toolchain these come entirely from the extractor's
// reconstruction path, so the presence of one node per macro invocation
// (including `write!`/`writeln!`) confirms it fires across the family.
import rust

from FormatArgsExpr f
select f, f.getNumberOfArgs()
