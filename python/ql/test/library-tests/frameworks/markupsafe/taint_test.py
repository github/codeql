from markupsafe import escape, escape_silent, Markup

def ensure_tainted(*args):
    print("ensure_tainted")
    for x in args: print(" ", x)

def ensure_not_tainted(*args):
    print("ensure_not_tainted")
    for x in args: print(" ", x)

# these contain `{}` so we can use .format
TAINTED_STRING = '<"TAINTED_STRING" {}>'
SAFE = "SAFE {}"

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
    ensure_not_tainted(escape(ts))
    ensure_tainted(ts) # $ tainted

    ensure_tainted(
        ts, # $ tainted
        m_unsafe, # $ tainted
        m_unsafe + SAFE, # $ MISSING: tainted
        SAFE + m_unsafe, # $ MISSING: tainted
        m_unsafe.format(SAFE), # $ MISSING: tainted
        m_unsafe + ts, # $ MISSING: tainted

        m_safe.format(m_unsafe), # $ MISSING: tainted

        escape(ts).unescape(), # $ MISSING: tainted
        escape_silent(ts).unescape(), # $ MISSING: tainted
    )

    ensure_not_tainted(
        escape(ts),
        escape_silent(ts),

        Markup.escape(ts),

        m_safe,
        m_safe + ts,
        ts + m_safe,
        m_safe.format(ts),

        escape(ts) + ts,
        escape_silent(ts) + ts,
        Markup.escape(ts) + ts,
    )

    # flask re-exports these, as:
    # flask.escape = markupsafe.escape
    # flask.Markup = markupsafe.Markup
    import flask

    ensure_tainted(
        flask.Markup(ts), # $ tainted
    )

    ensure_not_tainted(
        flask.escape(ts),
        flask.Markup.escape(ts),
    )


test()
