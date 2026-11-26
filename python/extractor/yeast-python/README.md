# `yeast-python`

Parse Python source with tree-sitter and translate its syntax tree with YEAST.

The parser currently contains no translation rules and reports
`{"status":"not_parsed"}` for every file. This allows the Python extractor to
exercise the parser infrastructure before falling back to its existing parsers.
The source path is supplied as the argument and decoded UTF-8 source is read from
standard input.
