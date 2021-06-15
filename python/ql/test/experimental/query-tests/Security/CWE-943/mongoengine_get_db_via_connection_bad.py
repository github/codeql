from flask import Flask, request
import mongoengine as me
from mongoengine.connection import get_db, connect
import json

app = Flask(__name__)


class Movie(me.Document):
    title = me.StringField(required=True)


Movie(title='test').save()


@app.route("/")
def home_page():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    db = get_db()
    data = db.movie.find({'name': json_search})

# if __name__ == "__main__":
#     app.run(debug=True)
