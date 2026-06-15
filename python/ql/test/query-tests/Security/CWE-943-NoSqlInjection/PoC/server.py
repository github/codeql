from flask import Flask, request
from pymongo import MongoClient
import json

client = MongoClient()
db = client.test_database
posts = db.posts

app = Flask(__name__)


def show_post(post, query):
    if post:
        return "You found " + post['author'] + "!"
    else:
        return "You did not find " + query

@app.route('/plain', methods=['GET'])
def plain():
    author = request.args['author']
    post = posts.find_one({'author': author}) # $ result=OK
    return show_post(post, author)

@app.route('/dict', methods=['GET'])
def as_dict():
    author_string = request.args['author']
    author = json.loads(author_string)
    # Use {"$ne": 1} as author
    # Found by http://127.0.0.1:5000/dict?author={%22$ne%22:1}
    post = posts.find_one({'author': author}) # $ result=BAD
    post = posts.find_one(filter={'author': author}) # $ result=BAD
    return show_post(post, author)

@app.route('/dictHardened', methods=['GET'])
def as_dict_hardened():
    author_string = request.args['author']
    author = json.loads(author_string)
    post = posts.find_one({'author': {"$eq": author}}) # $ result=OK
    return show_post(post, author)

@app.route('/byWhere', methods=['GET'])
def by_where():
    author = request.args['author']
    # Use `" | "a" === "a` as author
    # making the query `this.author === "" | "a" === "a"`
    # Found by http://127.0.0.1:5000/byWhere?author=%22%20|%20%22a%22%20===%20%22a
    post = posts.find_one({'$where': 'this.author === "'+author+'"'}) # $ result=BAD
    return show_post(post, author)

@app.route('/byFunction', methods=['GET'])
def by_function():
    author = request.args['author']
    search = {
        "body": 'function(author) { return(author === "'+author+'") }',
        "args": [ "$author" ],
        "lang": "js"
    }
    # Use `" | "a" === "a` as author
    # making the query `this.author === "" | "a" === "a"`
    # Found by http://127.0.0.1:5000/byFunction?author=%22%20|%20%22a%22%20===%20%22a
    post = posts.find_one({'$expr': {'$function': search}}) # $ result=BAD
    return show_post(post, author)

@app.route('/byFunctionArg', methods=['GET'])
def by_function_arg():
    author = request.args['author']
    search = {
        "body": 'function(author, target) { return(author === target) }',
        "args": [ "$author", author ],
        "lang": "js"
    }
    post = posts.find_one({'$expr': {'$function': search}}) # $ result=OK
    return show_post(post, author)

@app.route('/byGroup', methods=['GET'])
def by_group():
    author = request.args['author']
    accumulator = {
        "init": 'function() { return "Not found" }',
        "accumulate": 'function(state, author) { return (author === "'+author+'") ? author : state }',
        "accumulateArgs": ["$author"],
        "merge": 'function(state1, state2) { return (state1 === "Not found") ? state2 : state1 }'
    }
    group = {
        "_id": "null",
        "author": { "$accumulator": accumulator }
    }
    # Use `" | "a" === "a` as author
    # making the query `this.author === "" | "a" === "a"`
    # Found by http://127.0.0.1:5000/byGroup?author=%22%20|%20%22a%22%20===%20%22a
    post = posts.aggregate([{ "$group": group }]).next() # $ result=BAD
    post = posts.aggregate(pipeline=[{ "$group": group }]).next() # $ result=BAD
    return show_post(post, author)

# works with pymongo 3.9, `map_reduce` is removed in pymongo 4.0
@app.route('/byMapReduce', methods=['GET'])
def by_map_reduce():
    author = request.args['author']
    mapper = 'function() { emit(this.author, this.author === "'+author+'") }'
    reducer = "function(key, values) { return values.some( x => x ) }"
    results = posts.map_reduce(
        mapper, # $ result=BAD
        reducer, # $ result=OK
        "results")
    # Use `" | "a" === "a` as author
    # making the query `this.author === "" | "a" === "a"`
    # Found by http://127.0.0.1:5000/byMapReduce?author=%22%20|%20%22a%22%20===%20%22a
    post = results.find_one({'value': True})
    if(post):
        post["author"] = post["_id"]
    return show_post(post, author)

@app.route('/', methods=['GET'])
def show_routes():
    links = []
    for rule in app.url_map.iter_rules():
        if "GET" in rule.methods:
            links.append((rule.rule, rule.endpoint))
    return links
