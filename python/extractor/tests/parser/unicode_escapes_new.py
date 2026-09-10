# Characters that Rust's `Debug` formatting escapes as `\u{...}` when `tsg-python` serialises the
# source text. See https://github.com/github/codeql/issues/22435.

# PEP 695 syntax is what makes the old parser bail out and hand the file to `tsg-python` in the
# first place, so keep the reported reproducer intact.
type X = int

# U+FE0F variation selector, next to a `%` directive.
warn = "\u26a0\ufe0f  problem %s: %s"
warn_raw = "⚠️  problem %s: %s"

# U+200D zero width joiner.
zwj = "👨‍💻"

# Combining acute accent (NFD), and a soft hyphen.
nfd = "café"
soft_hyphen = "soft­hyphen"

# Combining marks are valid in identifiers too.
café = nfd

# In f-strings, raw strings and implicit concatenations too.
raw = r"⚠️\u{fe0f}"
joined = f"{zwj}⚠️"
concatenated = "⚠️" "👨‍💻"

# ... and outside of string literals.
d = {"⚠️": 1}  # comment with ⚠️ and 👨‍💻
