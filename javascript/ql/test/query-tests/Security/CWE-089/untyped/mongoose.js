'use strict';
const Express = require('express');
const BodyParser = require('body-parser');
const Mongoose = require('mongoose');
Mongoose.Promise = global.Promise;
Mongoose.connect('mongodb://localhost/injectable1');

const app = Express();
app.use(BodyParser.json());

const Document = Mongoose.model('Document', {
    title: {
        type: String,
        unique: true
    },
    type: String
});

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.body.title;

    // NOT OK: query is tainted by user-provided object value
    Document.aggregate([query]);

    // NOT OK: query is tainted by user-provided object value
    Document.count(query);

    // NOT OK: query is tainted by user-provided object value
    Document.deleteMany(query);

    // NOT OK: query is tainted by user-provided object value
    Document.deleteOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.distinct('type', query);

    // NOT OK: query is tainted by user-provided object value
    Document.find(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndDelete(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndRemove(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndUpdate(query);

    // NOT OK: query is tainted by user-provided object value
    Document.replaceOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.update(query);

    // NOT OK: query is tainted by user-provided object value
    Document.updateMany(query);

    // NOT OK: query is tainted by user-provided object value
	Document.updateOne(query).then(X);

	Document.findByIdAndUpdate(X, query, function(){}); // NOT OK

	new Mongoose.Query(X, Y, query)	// NOT OK
		.and(query, function(){}) // NOT OK
	;

    Document.where(query)	// NOT OK - `.where()` on a Model. 
        .where(query)	// NOT OK - `.where()` on a Query. 
		.and(query) // NOT OK
		.or(query) // NOT OK
		.distinct(X, query) // NOT OK
		.comment(query) // OK
		.count(query) // NOT OK
		.exec()
	;

	Mongoose.createConnection(X).count(query); // OK (invalid program)
	Mongoose.createConnection(X).model(Y).count(query); // NOT OK
	Mongoose.createConnection(X).models[Y].count(query); // NOT OK

	Document.findOne(X, (err, res) => res.count(query)); // NOT OK
	Document.findOne(X, (err, res) => err.count(query)); // OK
	Document.findOne(X).exec((err, res) => res.count(query)); // NOT OK
	Document.findOne(X).exec((err, res) => err.count(query)); // OK
	Document.findOne(X).then((res) => res.count(query)); // NOT OK
	Document.findOne(X).then(Y, (err) => err.count(query)); // OK

	Document.find(X, (err, res) => res[i].count(query)); // NOT OK
	Document.find(X, (err, res) => err.count(query)); // OK
	Document.find(X).exec((err, res) => res[i].count(query)); // NOT OK
	Document.find(X).exec((err, res) => err.count(query)); // OK
	Document.find(X).then((res) => res[i].count(query)); // NOT OK
	Document.find(X).then(Y, (err) => err.count(query)); // OK

	Document.count(X, (err, res) => res.count(query)); // OK (res is a number)
    
	function innocent(X, Y, query) { // To detect if API-graphs were used incorrectly.
		return new Mongoose.Query("constant", "constant", "constant");
	}
	new innocent(X, Y, query);

	function getQueryConstructor() {
		return Mongoose.Query;
	}

	var C = getQueryConstructor();
	new C(X, Y, query); // NOT OK
});
