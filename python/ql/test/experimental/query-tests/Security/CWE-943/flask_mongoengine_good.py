from flask import Flask, request
from flask_mongoengine import MongoEngine
import mongoengine as me
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)
db = MongoEngine(app)


class Movie(me.Document):
    title = me.StringField(required=True)
    year = me.IntField()
    rated = me.StringField()
    director = me.StringField()
    actors = me.ListField()


Movie(title='aa').save()
Movie(title='bb').save()


@app.route("/")
def home_page():
    unsanitized_search = json.loads(request.args['search'])
    sanitize(unsanitized_search)

    data = Movie.objects(unsanitized_search)
    return data.to_json()

# if __name__ == "__main__":
#     app.run(debug=True)
