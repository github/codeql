from flask import Flask, request
from flask_pymongo import PyMongo
import json

mongo = PyMongo(app)


@app.route("/")
def home_page():
    unsanitized_search = request.args['search']
    json_search = json.loads(unsanitized_search)

    result = mongo.db.user.find({'name': json_search})
