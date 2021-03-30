from flask import Flask, request
from flask_mongoengine import MongoEngine
import mongoengine as me
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

    data = Movie.objects(title=unsanitized_search)
    return data.to_json()

# if __name__ == "__main__":
#     app.run(debug=True)
