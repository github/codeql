from flask import Flask, request
from flask_pymongo import PyMongo
import json

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/testdb"
mongo = PyMongo(app)


@app.route("/")
def home_page():
    unsanitized_search = json.loads(request.args['search'])
    
    db_results = mongo.db.user.find({'name': unsanitized_search})
    return db_results[0].keys()
