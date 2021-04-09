from flask import Flask, request
from flask_pymongo import PyMongo
import json

app = Flask(__name__)
mongo = PyMongo(app)


@app.route("/")
def home_page():
    unsanitized_search = request.args['search']
    json_search = json.loads(unsanitized_search)

    result = mongo.db.user.find({'name': json_search})

# if __name__ == "__main__":
#     app.run(debug=True)
