from flask import Flask, request
from pymongo import MongoClient
import json

app = Flask(__name__)
client = MongoClient()


@app.route("/")
def home_page():
    unsanitized_search = json.loads(request.args['search'])

    db_results = client.db.collection.find_one({'data': unsanitized_search})
    return db_results[0].keys()

# if __name__ == "__main__":
#     app.run(debug=True)
