import html

s = "tainted"

html.escape(s) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
html.escape(s, True) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
html.escape(s, False) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
html.escape(s, quote=False) # $ escapeInput=s escapeKind=html escapeOutput=html.escape(..)
