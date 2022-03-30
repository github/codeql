import sqlalchemy
import sqlalchemy.orm

# SQLAlchemy is slowly migrating to a 2.0 version, and as part of 1.4 release have a 2.0
# style (forwards compatible) API that _can_ be adopted. So these tests are marked with
# either v1.4 or v2.0, such that we cover both.

raw_sql = "select 'FOO'"
text_sql = sqlalchemy.text(raw_sql)  # $ constructedSql=raw_sql

Base = sqlalchemy.orm.declarative_base()

# ==============================================================================
# v1.4
# ==============================================================================

print("v1.4")

# Engine see https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Engine

engine = sqlalchemy.create_engine("sqlite+pysqlite:///:memory:", echo=True)

result = engine.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]
result = engine.execute(statement=raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]
result = engine.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

scalar_result = engine.scalar(raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"
scalar_result = engine.scalar(statement=raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"

# engine with custom execution options
# see https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Engine.execution_options
engine_with_custom_exe_opts = engine.execution_options(foo=42)
result = engine_with_custom_exe_opts.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

even_more_opts = engine_with_custom_exe_opts.execution_options(bar=43)
result = even_more_opts.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

# Connection see https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Connection
conn = engine.connect()
conn: sqlalchemy.engine.base.Connection

result = conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]
result = conn.execute(statement=raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

result = conn.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]
result = conn.execute(statement=text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# scalar
scalar_result = conn.scalar(raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"
scalar_result = conn.scalar(object_=raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"

scalar_result = conn.scalar(text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"
scalar_result = conn.scalar(object_=text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"


# exec_driver_sql
result = conn.exec_driver_sql(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

# construction by object
conn = sqlalchemy.engine.base.Connection(engine)
result = conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

# branched connection
branched_conn = conn.connect()
result = branched_conn.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# raw connection
raw_conn = conn.connection
result = raw_conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

cursor = raw_conn.cursor()
cursor.execute(raw_sql) # $ getSql=raw_sql
assert cursor.fetchall() == [("FOO",)]
cursor.close()

raw_conn = engine.raw_connection()
result = raw_conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

# connection with custom execution options
conn_with_custom_exe_opts = conn.execution_options(bar=1337)
result = conn_with_custom_exe_opts.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# Session -- is what you use to work with the ORM layer
# see https://docs.sqlalchemy.org/en/14/orm/session_basics.html
# and https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session

session = sqlalchemy.orm.Session(engine)

result = session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]
result = session.execute(statement=raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

result = session.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]
result = session.execute(statement=text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# scalar
scalar_result = session.scalar(raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"
scalar_result = session.scalar(statement=raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"

scalar_result = session.scalar(text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"
scalar_result = session.scalar(statement=text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"

# other ways to construct a session
with sqlalchemy.orm.Session(engine) as session:
    result = session.execute(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("FOO",)]

Session = sqlalchemy.orm.sessionmaker(engine)
session = Session()

result = session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

with Session() as session:
    result = session.execute(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("FOO",)]

with Session.begin() as session:
    result = session.execute(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("FOO",)]

# scoped_session
Session = sqlalchemy.orm.scoped_session(sqlalchemy.orm.sessionmaker(engine))
session = Session()

result = session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

# Querying (1.4)
# see https://docs.sqlalchemy.org/en/14/orm/session_basics.html#querying-1-x-style

# to do so we first need a model

class For14(Base):
    __tablename__ = "for14"

    id = sqlalchemy.Column(sqlalchemy.Integer, primary_key=True)
    description = sqlalchemy.Column(sqlalchemy.String)

Base.metadata.create_all(engine)

# add a test-entry
test_entry = For14(id=14, description="test")
session = sqlalchemy.orm.Session(engine)
session.add(test_entry)
session.commit()
assert session.query(For14).all()[0].id == 14

# and now we can do the actual querying

text_foo = sqlalchemy.text("'FOO'")  # $ constructedSql="'FOO'"

# filter_by is only vulnerable to injection if sqlalchemy.text is used, which is evident
# from the logs produced if this file is run
# that is, first filter_by results in the SQL
#
# SELECT for14.id AS for14_id, for14.description AS for14_description
# FROM for14
# WHERE for14.description = ?
#
# which is then called with the argument `'FOO'`
#
# and the second filter_by results in the SQL
#
# SELECT for14.id AS for14_id, for14.description AS for14_description
# FROM for14
# WHERE for14.description = 'FOO'
#
# which is then called without any arguments
assert session.query(For14).filter_by(description="'FOO'").all() == []
query = session.query(For14).filter_by(description=text_foo)
assert query.all() == []

# Initially I wanted to add lots of additional taint steps such that the normal SQL
# injection query would find these cases where an ORM query includes a TextClause that
# includes user-input directly... But that presented 2 problems:
#
# - which part of the query construction above should be marked as SQL to fit our
#   `SqlExecution` concept. Nothing really fits this well, since all the SQL execution
#   happens under the hood.
# - This would require a LOT of modeling for these additional taint steps, since there
#   are many many constructs we would need to have models for. (see the 2 examples below)
#
# So instead we extended the SQL injection query to include TextClause construction as a
# sink directly.

# `filter` provides more general filtering
# see https://docs.sqlalchemy.org/en/14/orm/tutorial.html#common-filter-operators
# and https://docs.sqlalchemy.org/en/14/orm/query.html#sqlalchemy.orm.Query.filter
assert session.query(For14).filter(For14.description == "'FOO'").all() == []
query = session.query(For14).filter(For14.description == text_foo)
assert query.all() == []

assert session.query(For14).filter(For14.description.like("'FOO'")).all() == []
query = session.query(For14).filter(For14.description.like(text_foo))
assert query.all() == []

# There are many other possibilities for ending up with SQL injection, including the
# following (not an exhaustive list):
# - `where` (alias for `filter`)
# - `group_by`
# - `having`
# - `order_by`
# - `join`
# - `outerjoin`

# ==============================================================================
# v2.0
# ==============================================================================
import sqlalchemy.future

print("-"*80)
print("v2.0 style")

# For Engine, see https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Engine
engine = sqlalchemy.create_engine("sqlite+pysqlite:///:memory:", echo=True, future=True)
future_engine = sqlalchemy.future.create_engine("sqlite+pysqlite:///:memory:", echo=True)

# in 2.0 you are not allowed to execute things directly on the engine
try:
    engine.execute(raw_sql) # $ SPURIOUS: getSql=raw_sql
    raise Exception("above not allowed in 2.0")
except NotImplementedError:
    pass
try:
    engine.execute(text_sql) # $ SPURIOUS: getSql=text_sql
    raise Exception("above not allowed in 2.0")
except NotImplementedError:
    pass


# `connect` returns a new Connection object.
# see https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Connection
print("v2.0 engine.connect")
with engine.connect() as conn:
    conn: sqlalchemy.future.Connection

    # in 2.0 you are not allowed to use raw strings like this:
    try:
        conn.execute(raw_sql) # $ SPURIOUS: getSql=raw_sql
        raise Exception("above not allowed in 2.0")
    except sqlalchemy.exc.ObjectNotExecutableError:
        pass

    result = conn.execute(text_sql) # $ getSql=text_sql
    assert result.fetchall() == [("FOO",)]
    result = conn.execute(statement=text_sql) # $ getSql=text_sql
    assert result.fetchall() == [("FOO",)]

    result = conn.exec_driver_sql(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("FOO",)]

    raw_conn = conn.connection
    result = raw_conn.execute(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("FOO",)]

    # branching not allowed in 2.0
    try:
        branched_conn = conn.connect()
        raise Exception("above not allowed in 2.0")
    except NotImplementedError:
        pass

    # connection with custom execution options
    conn_with_custom_exe_opts = conn.execution_options(bar=1337)
    result = conn_with_custom_exe_opts.execute(text_sql) # $ getSql=text_sql
    assert result.fetchall() == [("FOO",)]

    # `scalar` is shorthand helper
    try:
        conn.scalar(raw_sql) # $ SPURIOUS: getSql=raw_sql
    except sqlalchemy.exc.ObjectNotExecutableError:
        pass
    scalar_result = conn.scalar(text_sql) # $ getSql=text_sql
    assert scalar_result == "FOO"
    scalar_result = conn.scalar(statement=text_sql) # $ getSql=text_sql
    assert scalar_result == "FOO"

    # This is a contrived example
    select = sqlalchemy.select(sqlalchemy.text("'BAR'"))  # $ constructedSql="'BAR'"
    result = conn.execute(select) # $ getSql=select
    assert result.fetchall() == [("BAR",)]

    # This is a contrived example
    select = sqlalchemy.select(sqlalchemy.literal_column("'BAZ'"))
    result = conn.execute(select) # $ getSql=select
    assert result.fetchall() == [("BAZ",)]

with future_engine.connect() as conn:
    result = conn.execute(text_sql) # $ getSql=text_sql
    assert result.fetchall() == [("FOO",)]

# `begin` returns a new Connection object with a transaction begun.
print("v2.0 engine.begin")
with engine.begin() as conn:
    result = conn.execute(text_sql) # $ getSql=text_sql
    assert result.fetchall() == [("FOO",)]

# construction by object
conn = sqlalchemy.future.Connection(engine)
result = conn.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# raw_connection

raw_conn = engine.raw_connection()
result = raw_conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

cursor = raw_conn.cursor()
cursor.execute(raw_sql) # $ getSql=raw_sql
assert cursor.fetchall() == [("FOO",)]
cursor.close()

# Session (2.0)
session = sqlalchemy.orm.Session(engine, future=True)

result = session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]
result = session.execute(statement=raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("FOO",)]

result = session.execute(text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]
result = session.execute(statement=text_sql) # $ getSql=text_sql
assert result.fetchall() == [("FOO",)]

# scalar
scalar_result = session.scalar(raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"
scalar_result = session.scalar(statement=raw_sql) # $ getSql=raw_sql
assert scalar_result == "FOO"

scalar_result = session.scalar(text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"
scalar_result = session.scalar(statement=text_sql) # $ getSql=text_sql
assert scalar_result == "FOO"

# Querying (2.0)
# uses a slightly different style than 1.4 -- see note about not modeling
# ORM query construction as SQL execution at the 1.4 query tests.

class For20(Base):
    __tablename__ = "for20"

    id = sqlalchemy.Column(sqlalchemy.Integer, primary_key=True)
    description = sqlalchemy.Column(sqlalchemy.String)

For20.metadata.create_all(engine)

# add a test-entry
test_entry = For20(id=20, description="test")
session = sqlalchemy.orm.Session(engine, future=True)
session.add(test_entry)
session.commit()
assert session.query(For20).all()[0].id == 20

# and now we can do the actual querying
# see https://docs.sqlalchemy.org/en/14/orm/session_basics.html#querying-2-0-style

statement = sqlalchemy.select(For20)
result = session.execute(statement) # $ getSql=statement
assert result.scalars().all()[0].id == 20

statement = sqlalchemy.select(For20).where(For20.description == text_foo)
result = session.execute(statement) # $ getSql=statement
assert result.scalars().all() == []
