from flask import Flask, request
from flask_mongoengine import MongoEngine
import json

app = Flask(__name__)
app.config.from_pyfile('the-config.cfg')
db = MongoEngine(app)

class Movie(db.Document):
    title = db.StringField(required=True)
    year = db.IntField()
    rated = db.StringField()
    director = db.StringField()
    actors = db.ListField()


Movie(title='aa').save()
Movie(title='bb').save()


@app.route("/")
def home_page():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    data = Movie.objects(__raw__=json_search)

# if __name__ == "__main__":
#     app.run(debug=True)
