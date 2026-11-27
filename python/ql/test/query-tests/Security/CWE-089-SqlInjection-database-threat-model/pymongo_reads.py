import sqlite3
from pymongo import MongoClient
from flask_pymongo import PyMongo


def find_one():
    record = MongoClient().db.users.find_one({})
    cursor = sqlite3.connect(':memory:').cursor()
    cursor.execute("SELECT * FROM users WHERE name = '" + record['user'] + "'")  # $ Alert
    cursor.execute('SELECT * FROM users WHERE name = ?', (record['user'],))


def find_iteration():
    collection = MongoClient().db.users
    cursor = sqlite3.connect(':memory:').cursor()
    for record in collection.find({}):
        cursor.execute("SELECT * FROM users WHERE name = '" + record['user'] + "'")  # $ Alert
        cursor.execute('SELECT * FROM users WHERE name = ?', (record['user'],))


def sync_users():
    # Regression for the list accumulation and join in issue #21775.
    users = []
    client = MongoClient('mongodb://localhost:27017/')
    for record in client.auth.users.find({'role': 'dev'}, {'user': 1, '_id': 0}):
        users.append(record['user'])
    in_clause = "', '".join(users)
    sql = "SELECT * FROM user_info WHERE username IN ('" + in_clause + "')"
    cursor = sqlite3.connect(':memory:').cursor()
    cursor.execute(sql)  # $ Alert
    cursor.execute('SELECT * FROM user_info WHERE username = ?', (in_clause,))


def find_and_delete():
    record = MongoClient().db.users.find_one_and_delete({})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])  # $ Alert


def find_and_replace():
    record = MongoClient().db.users.find_one_and_replace({}, {'user': 'alice'})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])  # $ Alert


def find_and_update():
    record = MongoClient().db.users.find_one_and_update({}, {'$set': {'user': 'alice'}})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])  # $ Alert


def collection_accessors():
    collection = MongoClient().get_database('db').get_collection('users')
    record = collection.find_one({})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])  # $ Alert


def flask_pymongo():
    record = PyMongo().db.users.find_one_or_404({})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])  # $ Alert


class UnrelatedCollection:
    def find_one(self, query):
        return {'user': 'alice'}


def unrelated_method():
    record = UnrelatedCollection().find_one({})
    sqlite3.connect(':memory:').execute('SELECT ' + record['user'])
