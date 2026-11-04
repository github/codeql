let empty = ""
let simple = "abc"
let escaped = "a\nb\rc\td\0e\\f\"g\'h"
let escapedBackslash = "\\n"
let unicode = "\u{61}\u{1F600}"
let raw = #"\n\"abc"# 
let rawEscapes = ##"\n\##n\##u{61}\##"\##\"##
let hashesInside = #"abc#def"#
let multiline = """
    aa|
    bb
    """
let multilineIndent = """
      aa
    bb
    """
let multilineEmptyLine = """
    aa

    bb
    """
let multilineContinuation = """
    aa\
    bb
    """
let rawMultiline = #"""
    aa\n
    bb
    """#
let interpolation = "a\(simple)b"
