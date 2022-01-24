from flask import Flask, request
from pymongo import MongoClient
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)
client = MongoClient()


@app.route("/")
def home_page():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)
    safe_search = sanitize(json_search)

    return client.db.collection.find_one({'data': safe_search})

# if __name__ == "__main__":
#     app.run(debug=True)
