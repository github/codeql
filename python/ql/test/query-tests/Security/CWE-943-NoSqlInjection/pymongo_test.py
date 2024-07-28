from flask import Flask, request
from pymongo import MongoClient
from mongosanitizer.sanitizer import sanitize
import json

app = Flask(__name__)
client = MongoClient()


@app.route("/bad")
def bad():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)

    return client.db.collection.find_one({'data': json_search})  #$ result=BAD


@app.route("/good")
def good():
    unsafe_search = request.args['search']
    json_search = json.loads(unsafe_search)
    safe_search = sanitize(json_search)

    return client.db.collection.find_one({'data': safe_search})  #$ result=OK


@app.route("/bad2")
def bad2():
    event_id = json.loads(request.args['event_id'])
    client = MongoClient("localhost", 27017, maxPoolSize=50)
    db = client.localhost
    collection = db['collection']
    cursor = collection.find_one({"$where": f"this._id == '${event_id}'"})  #$ result=BAD


@app.route("/bad3")
def bad3():
    # using `get_` methods instead of subscript/attribute lookups
    event_id = json.loads(request.args['event_id'])
    client = MongoClient("localhost", 27017, maxPoolSize=50)
    db = client.get_database(name="localhost")
    collection = db.get_collection("collection")
    cursor = collection.find_one({"$where": f"this._id == '${event_id}'"})  #$ result=BAD


@app.route("/bad4")
def bad4():
    client = MongoClient("localhost", 27017, maxPoolSize=50)
    db = client.get_database(name="localhost")
    collection = db.get_collection("collection")

    decoded = json.loads(request.args['event_id'])

    search = {
        "body": decoded,
        "args": [ "$event_id" ],
        "lang": "js"
    }
    collection.find_one({'$expr': {'$function': search}}) # $ result=BAD

    collection.find_one({'$expr': {'$function': decoded}}) # $ result=BAD
    collection.find_one({'$expr': decoded}) # $ result=BAD
    collection.find_one(decoded) # $ result=BAD

if __name__ == "__main__":
    app.run(debug=True)
