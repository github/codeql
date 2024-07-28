from flask import Flask, request
from flask_pymongo import PyMongo
from mongosanitizer.sanitizer import sanitize
import json

mongo = PyMongo(app)


@app.route("/")
def home_page():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)
    safe_search = sanitize(unsanitized_search)

    result = client.db.collection.find_one({'data': safe_search})
