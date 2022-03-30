from flask import Flask, request
import sqlalchemy
import sqlalchemy.orm
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
engine = sqlalchemy.create_engine(...)
Base = sqlalchemy.orm.declarative_base()

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite+pysqlite:///:memory:"
db = SQLAlchemy(app)



class User(Base):
    __tablename__ = "users"

    id = sqlalchemy.Column(sqlalchemy.Integer, primary_key=True)
    username = sqlalchemy.Column(sqlalchemy.String)


@app.route("/users/<username>")
def show_user(username):
    session = sqlalchemy.orm.Session(engine)

    # BAD, normal SQL injection
    stmt = sqlalchemy.text("SELECT * FROM users WHERE username = '{}'".format(username))
    results = session.execute(stmt).fetchall()

    # BAD, allows SQL injection
    username_formatted_for_sql = sqlalchemy.text("'{}'".format(username))
    stmt = sqlalchemy.select(User).where(User.username == username_formatted_for_sql)
    results = session.execute(stmt).scalars().all()

    # GOOD, does not allow for SQL injection
    stmt = sqlalchemy.select(User).where(User.username == username)
    results = session.execute(stmt).scalars().all()


    # All of these should be flagged by query
    t1 = sqlalchemy.text(username)
    t2 = sqlalchemy.text(text=username)
    t3 = sqlalchemy.sql.text(username)
    t4 = sqlalchemy.sql.text(text=username)
    t5 = sqlalchemy.sql.expression.text(username)
    t6 = sqlalchemy.sql.expression.text(text=username)
    t7 = sqlalchemy.sql.expression.TextClause(username)
    t8 = sqlalchemy.sql.expression.TextClause(text=username)

    t9 = db.text(username)
    t10 = db.text(text=username)
