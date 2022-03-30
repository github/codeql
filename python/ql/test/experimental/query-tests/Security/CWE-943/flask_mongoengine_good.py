from flask import Flask, request
from flask_mongoengine import MongoEngine
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)
app.config.from_pyfile('the-config.cfg')
db = MongoEngine(app)


class Movie(db.Document):
    title = db.StringField(required=True)


Movie(title='test').save()


@app.route("/subclass_objects")
def subclass_objects():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)
    safe_search = sanitize(json_search)

    return Movie.objects(__raw__=safe_search)

# if __name__ == "__main__":
#     app.run(debug=True)
