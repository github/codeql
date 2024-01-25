from flask import Flask, request
from flask_mongoengine import MongoEngine
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

    return Movie.objects(__raw__=json_search)  #$ result=BAD

@app.route("/get_db_find")
def get_db_find():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    retrieved_db = db.get_db()
    return retrieved_db["Movie"].find({'name': json_search})  #$ result=BAD

# if __name__ == "__main__":
#     app.run(debug=True)
