from flask import Flask, request
import mongoengine as me
from mongoengine.connection import get_db, connect
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)


class Movie(me.Document):
    title = me.StringField(required=True)


Movie(title='test').save()


@app.route("/connect_find")
def connect_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)
    safe_search = sanitize(json_search)

    db = me.connect('mydb')  
    return db.movie.find({'name': safe_search})

# if __name__ == "__main__":
#     app.run(debug=True)
