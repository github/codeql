from pymongo import MongoClient
client = MongoClient()

db = client.test_database

import datetime
post = {
    "author": "Mike",
    "text": "My first blog post!",
    "tags": ["mongodb", "python", "pymongo"],
    "date": datetime.datetime.now(tz=datetime.timezone.utc),
}

posts = db.posts
post_id = posts.insert_one(post).inserted_id
post_id
