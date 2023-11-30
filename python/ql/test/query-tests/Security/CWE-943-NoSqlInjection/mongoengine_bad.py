from flask import Flask, request
import mongoengine as me
from mongoengine.connection import get_db, connect
import json

app = Flask(__name__)


class Movie(me.Document):
    title = me.StringField(required=True)


Movie(title='test').save()


@app.route("/connect_find")
def connect_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = me.connect('mydb')
    return db.movie.find({'name': json_search})  #$ result=BAD

@app.route("/connection_connect_find")
def connection_connect_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = connect('mydb')
    return db.movie.find({'name': json_search})  #$ result=BAD

@app.route("/get_db_find")
def get_db_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = me.get_db()
    return db.movie.find({'name': json_search})  #$ result=BAD

@app.route("/connection_get_db_find")
def connection_get_db_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = get_db()
    return db.movie.find({'name': json_search})  #$ result=BAD

@app.route("/subclass_objects")
def subclass_objects():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    return Movie.objects(__raw__=json_search)  #$ result=BAD

@app.route("/subscript_find")
def subscript_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = me.connect('mydb')
    return db['movie'].find({'name': json_search})  #$ result=BAD

# if __name__ == "__main__":
#     app.run(debug=True)
