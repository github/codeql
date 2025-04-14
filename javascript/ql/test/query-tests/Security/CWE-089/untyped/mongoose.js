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
	query.title = req.body.title; // $ Source

	Document.aggregate([query]); // $ Alert - query is tainted by user-provided object value

	Document.count(query); // $ Alert - query is tainted by user-provided object value

	Document.deleteMany(query); // $ Alert - query is tainted by user-provided object value

	Document.deleteOne(query); // $ Alert - query is tainted by user-provided object value

	Document.distinct('type', query); // $ Alert - query is tainted by user-provided object value

	Document.find(query); // $ Alert - query is tainted by user-provided object value

	Document.findOne(query); // $ Alert - query is tainted by user-provided object value

	Document.findOneAndDelete(query); // $ Alert - query is tainted by user-provided object value

	Document.findOneAndRemove(query); // $ Alert - query is tainted by user-provided object value

	Document.findOneAndUpdate(query); // $ Alert - query is tainted by user-provided object value

	Document.replaceOne(query); // $ Alert - query is tainted by user-provided object value

	Document.update(query); // $ Alert - query is tainted by user-provided object value

	Document.updateMany(query); // $ Alert - query is tainted by user-provided object value

	Document.updateOne(query).then(X); // $ Alert - query is tainted by user-provided object value

	Document.findByIdAndUpdate(X, query, function(){}); // $ Alert

	new Mongoose.Query(X, Y, query)	// $ Alert
		.and(query, function(){}) // $ Alert
	;

	Document.where(query)	// $ Alert - `.where()` on a Model.
		.where(query)	// $ Alert - `.where()` on a Query.
		.and(query) // $ Alert
		.or(query) // $ Alert
		.distinct(X, query) // $ Alert
		.comment(query)
		.count(query) // $ Alert
		.exec()
	;

	Mongoose.createConnection(X).count(query); // OK - invalid program
	Mongoose.createConnection(X).model(Y).count(query); // $ Alert
	Mongoose.createConnection(X).models[Y].count(query); // $ Alert

	Document.findOne(X, (err, res) => res.count(query)); // $ Alert
	Document.findOne(X, (err, res) => err.count(query));
	Document.findOne(X).exec((err, res) => res.count(query)); // $ Alert
	Document.findOne(X).exec((err, res) => err.count(query));
	Document.findOne(X).then((res) => res.count(query)); // $ Alert
	Document.findOne(X).then(Y, (err) => err.count(query));

	Document.find(X, (err, res) => res[i].count(query)); // $ Alert
	Document.find(X, (err, res) => err.count(query));
	Document.find(X).exec((err, res) => res[i].count(query)); // $ Alert
	Document.find(X).exec((err, res) => err.count(query));
	Document.find(X).then((res) => res[i].count(query)); // $ Alert
	Document.find(X).then(Y, (err) => err.count(query));

	Document.count(X, (err, res) => res.count(query)); // OK - res is a number
	
	function innocent(X, Y, query) { // To detect if API-graphs were used incorrectly.
		return new Mongoose.Query("constant", "constant", "constant");
	}
	new innocent(X, Y, query);

	function getQueryConstructor() {
	return Mongoose.Query;
	}

	var C = getQueryConstructor();
	new C(X, Y, query); // $ Alert

	Document.findOneAndUpdate(X, query, function () { }); // $ Alert

	let id = req.query.id, cond = req.query.cond; // $ Source
	Document.deleteMany(cond); // $ Alert
	Document.deleteOne(cond); // $ Alert
	Document.geoSearch(cond); // $ Alert
	Document.remove(cond); // $ Alert
	Document.replaceOne(cond, Y); // $ Alert
	Document.find(cond); // $ Alert
	Document.findOne(cond); // $ Alert
	Document.findById(id); // $ Alert
	Document.findOneAndDelete(cond); // $ Alert
	Document.findOneAndRemove(cond); // $ Alert
	Document.findOneAndUpdate(cond, Y); // $ Alert
	Document.update(cond, Y); // $ Alert
	Document.updateMany(cond, Y); // $ Alert
	Document.updateOne(cond, Y); // $ Alert
	Document.find({ _id: id }); // $ Alert
	Document.find({ _id: { $eq: id } });

	if (Mongoose.Types.ObjectId.isValid(query)) {
		Document.findByIdAndUpdate(query, X, function(){}); // OK - is sanitized
	} else {
		Document.findByIdAndUpdate(query, X, function(){}); // $ Alert
	}
});
