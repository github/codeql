from flask import Flask, request
from pymongo import MongoClient
import json

app = Flask(__name__)
client = MongoClient()


@app.route("/")
def home_page():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    return client.db.collection.find_one({'data': json_search})

# if __name__ == "__main__":
#     app.run(debug=True)
