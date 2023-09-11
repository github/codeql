from markupsafe import escape, escape_silent, Markup

def ensure_tainted(*args):
    print("ensure_tainted")
    for x in args: print(" ", x)

def ensure_not_tainted(*args):
    print("ensure_not_tainted")
    for x in args: print(" ", x)

# these contain `{}` so we can use .format, and `%s` so we can use %-style formatting
TAINTED_STRING = '<"TAINTED_STRING" {} %s>'
SAFE = "SAFE {} %s"

def test():
    ts = TAINTED_STRING

    # class `Markup` can be used for things that are already safe.
    # if used with any text in a string operation, that other text will be escaped.
    #
    # see https://markupsafe.palletsprojects.com/en/2.0.x/
    m_unsafe = Markup(TAINTED_STRING)
    m_safe = Markup(SAFE)


    # this 3 tests might look strange, but the purpose is to check we still treat `ts`
    # as tainted even after it has been escaped in some place. This _might_ not be the
    # case since data-flow library has taint-steps from adjacent uses...
    ensure_tainted(ts) # $ tainted
    ensure_not_tainted(escape(ts)) # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=escape(..)
    ensure_tainted(ts) # $ tainted

    ensure_tainted(
        ts, # $ tainted
        m_unsafe, # $ tainted
        m_unsafe + SAFE, # $ escapeInput=SAFE escapeKind=html escapeKind=xml escapeOutput=BinaryExpr MISSING: tainted
        SAFE + m_unsafe, # $ escapeInput=SAFE escapeKind=html escapeKind=xml escapeOutput=BinaryExpr MISSING: tainted
        m_unsafe.format(SAFE), # $ escapeInput=SAFE escapeKind=html escapeKind=xml escapeOutput=m_unsafe.format(..) MISSING: tainted
        m_unsafe % SAFE, # $ escapeInput=SAFE escapeKind=html escapeKind=xml escapeOutput=BinaryExpr MISSING: tainted
        m_unsafe + ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr MISSING: tainted

        m_safe.format(m_unsafe), # $ tainted
        m_safe % m_unsafe, # $ tainted

        escape(ts).unescape(), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=escape(..) MISSING: tainted
        escape_silent(ts).unescape(), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=escape_silent(..) MISSING: tainted
    )

    ensure_not_tainted(
        escape(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=escape(..)
        escape_silent(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=escape_silent(..)

        Markup.escape(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=Markup.escape(..)

        m_safe,
        m_safe + ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr
        ts + m_safe, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr
        m_safe.format(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=m_safe.format(..)
        m_safe % ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr

        escape(ts) + ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr escapeOutput=escape(..)
        escape_silent(ts) + ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr escapeOutput=escape_silent(..)
        Markup.escape(ts) + ts, # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=BinaryExpr escapeOutput=Markup.escape(..)
    )

    # flask re-exports these, as:
    # flask.escape = markupsafe.escape
    # flask.Markup = markupsafe.Markup
    import flask

    ensure_tainted(
        flask.Markup(ts), # $ tainted
    )

    ensure_not_tainted(
        flask.escape(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=flask.escape(..)
        flask.Markup.escape(ts), # $ escapeInput=ts escapeKind=html escapeKind=xml escapeOutput=flask.Markup.escape(..)
    )


test()
