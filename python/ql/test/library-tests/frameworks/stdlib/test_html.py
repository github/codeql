import html

s = "tainted"

html.escape(s) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
html.escape(s, True) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
# not considered html escapes, since they don't escape all relevant characters
html.escape(s, False)
html.escape(s, quote=False)
