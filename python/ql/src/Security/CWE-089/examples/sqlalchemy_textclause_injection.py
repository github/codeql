from flask import Flask, request
import sqlalchemy
import sqlalchemy.orm

app = Flask(__name__)
engine = sqlalchemy.create_engine(...)
Base = sqlalchemy.orm.declarative_base()


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

    ...
