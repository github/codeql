import sqlalchemy

def test_taint():
    ts = TAINTED_STRING

    ensure_tainted(
        ts, # $ tainted
        sqlalchemy.text(ts), # $ tainted
        sqlalchemy.sql.text(ts),# $ tainted
        sqlalchemy.sql.expression.text(ts),# $ tainted
        sqlalchemy.sql.expression.TextClause(ts),# $ tainted
    )
