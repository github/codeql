(function() {
    const password = '1234';
    sink(password); // NOT OK
    
    const s = JSON.stringify();
    sink(s); // NOT OK
})();

(async function() {
    const knex = require('knex');
    
    const users = knex().select('*').from('users');
    users.then(function (users) {
        sink(users); // NOT OK
    });

    users.asCallback(function (err, users) {
        sink(users); // NOT OK
    });

    sink(await users); // NOT OK
})();

(function() {
    const pg = require('pg');
    
    const pool = new pg.Pool({});
    pool.connect(async function (err, client, done) {
        client.query('SELECT * FROM users', function (err, users) {
            sink(users);
        });
        
        const thenable = client.query('SELECT * FROM users')
        thenable.then(function(users) {
            sink(users); // NOT OK
        });

        const pgpromise = client.query('SELECT * FROM users');
        sink(await pgpromise); // NOT OK
    });
})();

(async function () {
    const pgpromise = require('pg-promise')();
    const db = pgpromise('postgres://username:password@localhost:1234/database');
    const pgppromise = db.any('SELECT * FROM users');

    pgppromise.then(function (users) {
        sink(users);
    });

    sink(await pgppromise);
})();

(function () {
    const mysql = require('mysql2');
    const conn = mysql.createConnection({});

    conn.query(
        'SELECT * FROM `users`',
        function(err, users, fields) {
          sink(users); // NOT OK
        }
    );

    conn.execute(
        'SELECT * FROM `users` WHERE name = ?',
        ['Alice'],
        function(err, users) {
            sink(users);
        }
    );
})();

(async function () {
    const sqlite = require('sqlite3');
    const db = new sqlite.Database(':memory:');

    db.all('SELECT * FROM users', function (err, users) {
        sink(users); // NOT OK
    });
    
    const sqlitepromise = db.all('SELECT * FROM users');

    sink(await sqlitepromise); // NOT OK
})();

(async function () {
    const { Sequelize } = require('sequelize');
    const sequelize = new Sequelize('sqlite::memory:');

    class User extends sequelize.Model {}
    User.init({ name: sequelize.DataTypes.String }, { sequelize, modelName: 'user' });

    sequelize.query('SELECT * FROM users').then(function (users) {
        sink(users); // NOT OK
    });
})();

(async function () {
    const sql = require('mssql');
    await sql.connect('...');
    
    sql.query('SELECT * FROM users', function (err, users) {
        sink(users); // NOT OK
    });

    const mssqlthenable = sql.query('SELECT * FROM users');
    
    mssqlthenable.then(function (users) {
        sink(users); // NOT OK
    });

    const mssqlpromise = sql.query('SELECT * FROM users');
    sink(await mssqlpromise); // NOT OK

    const uname = 'Alice';
    const mssqltaggedquery = sql.query`SELECT * FROM users where name=${uname}`
    sink(await mssqltaggedquery); // NOT OK
})();

(async function () {
    const {Spanner} = require('@google-cloud/spanner');
    const db = new Spanner({projectId: 'test'})
        .instance('instanceid')
        .database('databaseid');

    db.executeSql('SELECT * FROM users', {}, function (err, users) {
        sink(users); // NOT OK
    });

    const [users] = (await db.executeSql('SELECT * FROM users', {}));
    sink(users); // NOT OK
    
    const spannerpromise = db.run({
        sql: 'SELECT * FROM users'
    });

    sink(await spannerpromise); // NOT OK

    db.run({
        sql: 'SELECT * FROM users'
    }, function (err, rows, stats, meta) {
        sink(rows); // NOT OK
    });

    const client = new Spanner.v1.SpannerClient({});
    client.executeSql('SELECT * FROM users', {}, function (err, users) {
        sink(users); // NOT OK
    });

    db.runTransaction(function(err, txn) {
        txn.run('SELECT * FROM users', function (err, users) {
            sink(users); // NOT OK
        });
        txn.commit(function () {});
    });

    db.getSnapshot(function (err, txn) {
        txn.run('SELECT * FROM users', function (err, users) {
            sink(users); // NOT OK
        });
        txn.end();
    });
})();

(function () {
    const { MongoClient } = require('mongodb');
    
    MongoClient.connect('mongodb://localhost:1234', async function (err, db) {
        const collection = db.collection('users');
        const users = await collection.find({});
        sink(users); // NOT OK
    });
})();

(async function () {
    const mongoose = require('mongoose');
    await mongoose.connect('mongodb://localhost:1234');

    const User = mongoose.model('User', {
        name: {
            type: String,
            unique: true
        }
    });

    User.find({ name: 'Alice' }, function (err, alice) {
        sink(alice); // NOT OK
    });

    User.find({ name: 'Bob' }).exec(function (err, bob) {
        sink(bob); // NOT OK
    });

    const promise = User.find({ name: 'Claire' });
    promise.then(c => sink(c)); // NOT OK
})();

(async function () {
    const minimongo = require('minimongo');
    const LocalDb = minimongo.MemoryDb;
    const db = new LocalDb();
    const doc = db.users;

    const users = await doc.find({});
    sink(users); // NOT OK
})();

(async function () {
    const { Collection } = require('marsdb');
    
    const doc = new Collection('users');

    const users = await doc.find({});
    
    sink(users); // NOT OK
})();

(async function () {
    const redis = require("redis");
    const client = redis.createClient();

    const alice = await client.get('alice');

    sink(alice); // NOT OK
})();

(async function () {
    const Redis = require('ioredis');
    const redis = new Redis();

    const bob = await redis.get('bob');

    sink(bob); // NOT OK
})();
