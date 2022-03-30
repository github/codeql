import sqlalchemy

ensure_tainted = ensure_not_tainted = print
TAINTED_STRING = "TAINTED_STRING"

def test_taint():
    ts = TAINTED_STRING

    ensure_tainted(ts) # $ tainted

    t1 = sqlalchemy.text(ts)  # $ constructedSql=ts
    t2 = sqlalchemy.text(text=ts)  # $ constructedSql=ts
    t3 = sqlalchemy.sql.text(ts)  # $ constructedSql=ts
    t4 = sqlalchemy.sql.text(text=ts)  # $ constructedSql=ts
    t5 = sqlalchemy.sql.expression.text(ts)  # $ constructedSql=ts
    t6 = sqlalchemy.sql.expression.text(text=ts)  # $ constructedSql=ts
    t7 = sqlalchemy.sql.expression.TextClause(ts)  # $ constructedSql=ts
    t8 = sqlalchemy.sql.expression.TextClause(text=ts)  # $ constructedSql=ts

    # Since we flag user-input to a TextClause with its' own query, we don't want to
    # have a taint-step for it as that would lead to us also giving an alert for normal
    # SQL-injection... and double alerting like this does not seem desireable.
    ensure_not_tainted(t1, t2, t3, t4, t5, t6, t7, t8)

    for text in [t1, t2, t3, t4, t5, t6, t7, t8]:
        assert isinstance(text, sqlalchemy.sql.expression.TextClause)

test_taint()
