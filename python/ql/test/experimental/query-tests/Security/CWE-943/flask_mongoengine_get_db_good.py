from flask import Flask, request
from flask_mongoengine import MongoEngine
from mongosanitizer.sanitizer import sanitize
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
    safe_search = sanitize(json_search)

    retrieved_db = db.get_db()
    result = retrieved_db["Movie"].find_one_or_404({'name': safe_search})

# if __name__ == "__main__":
#     app.run(debug=True)
