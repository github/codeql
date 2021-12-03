# pip install Flask-SQLAlchemy
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import sqlalchemy

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite+pysqlite:///:memory:"
db = SQLAlchemy(app)

# re-exports all things from `sqlalchemy` and `sqlalchemy.orm` under instances of `SQLAlchemy`
# see
# - https://github.com/pallets/flask-sqlalchemy/blob/931ec00d1e27f51508e05706eef41cc4419a0b32/src/flask_sqlalchemy/__init__.py#L765
# - https://github.com/pallets/flask-sqlalchemy/blob/931ec00d1e27f51508e05706eef41cc4419a0b32/src/flask_sqlalchemy/__init__.py#L99-L109

assert str(type(db.text("Foo"))) == "<class 'sqlalchemy.sql.elements.TextClause'>"  # $ constructedSql="Foo"

# also has engine/session instantiated

raw_sql = "SELECT 'Foo'"

conn = db.engine.connect()
result = conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("Foo",)]

conn = db.get_engine().connect()
result = conn.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("Foo",)]

result = db.session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("Foo",)]

Session = db.create_session(options={})
session = Session()
result = session.execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("Foo",)]

Session = db.create_session(options={})
with Session.begin() as session:
    result = session.execute(raw_sql) # $ getSql=raw_sql
    assert result.fetchall() == [("Foo",)]

result = db.create_scoped_session().execute(raw_sql) # $ getSql=raw_sql
assert result.fetchall() == [("Foo",)]


# text
t = db.text("foo")  # $ constructedSql="foo"
assert isinstance(t, sqlalchemy.sql.expression.TextClause)

t = db.text(text="foo")  # $ constructedSql="foo"
assert isinstance(t, sqlalchemy.sql.expression.TextClause)
