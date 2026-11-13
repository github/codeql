from pymongo import MongoClient
from pymongo.mongo_client import MongoClient as AliasedMongoClient
from flask_pymongo import PyMongo

client = MongoClient()
collection = client.db.users

collection.find({})  # $ threatModelSource[database]=collection.find(..)
collection.find_raw_batches({})  # $ threatModelSource[database]=collection.find_raw_batches(..)
collection.find_one({})  # $ threatModelSource[database]=collection.find_one(..)
collection.find_one_and_delete({})  # $ threatModelSource[database]=collection.find_one_and_delete(..)
collection.find_one_and_replace({}, {})  # $ threatModelSource[database]=collection.find_one_and_replace(..)
collection.find_one_and_update({}, {})  # $ threatModelSource[database]=collection.find_one_and_update(..)
collection.find_and_modify({})  # $ threatModelSource[database]=collection.find_and_modify(..)

# Collection access through subscripts and accessor methods.
client['db']['users'].find_one({})  # $ threatModelSource[database]=client['db']['users'].find_one(..)
client.get_database('db').get_collection('users').find_one({})  # $ threatModelSource[database]=client.get_database(..).get_collection(..).find_one(..)
client.get_default_database().users.find_one({})  # $ threatModelSource[database]=client.get_default_database().users.find_one(..)
AliasedMongoClient().db.users.find_one({})  # $ threatModelSource[database]=AliasedMongoClient().db.users.find_one(..)

# Flask-PyMongo exposes the same collection APIs and find_one_or_404.
mongo = PyMongo()
mongo.db.users.find_one({})  # $ threatModelSource[database]=mongo.db.users.find_one(..)
mongo.db.users.find_one_or_404({})  # $ threatModelSource[database]=mongo.db.users.find_one_or_404(..)

# Write results and counts are not document reads.
collection.insert_one({'user': 'alice'})
collection.delete_one({})
collection.count_documents({})


class UnrelatedCollection:
    def find_one(self, query):
        return {'user': 'alice'}


# A method name alone does not make a database source.
UnrelatedCollection().find_one({})
