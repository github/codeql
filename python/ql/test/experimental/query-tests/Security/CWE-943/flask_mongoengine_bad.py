from flask import Flask, request
from flask_mongoengine import MongoEngine
import json

app = Flask(__name__)
db = MongoEngine(app)
db.init_app(app)


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
    unsanitized_search = request.args['search']
    json_search = json.loads(unsanitized_search)

    result = Movie.objects(__raw__=json_search)

# if __name__ == "__main__":
#     app.run(debug=True)
