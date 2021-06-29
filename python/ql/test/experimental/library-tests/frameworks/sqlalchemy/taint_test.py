import sqlalchemy

def test_taint():
    ts = TAINTED_STRING

    ensure_tainted(
        ts, # $ tainted
        sqlalchemy.text(ts), # $ MISSING: tainted
        sqlalchemy.sql.text(ts),# $ MISSING: tainted
        sqlalchemy.sql.expression.text(ts),# $ MISSING: tainted
        sqlalchemy.sql.expression.TextClause(ts),# $ MISSING: tainted
    )
