from flask import Flask, request
from pymongo import MongoClient
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)
client = MongoClient()


@app.route("/")
def home_page():
    unsanitized_search = json.loads(request.args['search'])
    sanitize(unsanitized_search)

    db_results = client.db.collection.find_one({'data': unsanitized_search})
    return db_results[0].keys()

# if __name__ == "__main__":
#     app.run(debug=True)
