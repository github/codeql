from flask import Flask, request
from flask_mongoengine import MongoEngine
import json

app = Flask(__name__)
db = MongoEngine(app)
db.init_app(app)


class Movie(db.Document):
    title = db.StringField(required=True)


Movie(title='test').save()


@app.route("/")
def home_page():
    unsanitized_search = request.args['search']
    json_search = json.loads(unsanitized_search)

    retrieved_db = db.get_db()
    result = retrieved_db["Movie"].find({'name': json_search})

# if __name__ == "__main__":
#     app.run(debug=True)
