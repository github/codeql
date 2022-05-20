'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

var _ = require("lodash");

rootRoute.post(function(req, res) {
    nullPointer(req.body);
    
    nullPointer2(req.body);
    
    nullPointer3(req.body);
    
    lodashPointer(req.body);
    
    lodashArrowFunc(req.body);
});

function nullPointer(val) {
    var ret = [];

    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i].foo + 42);
    }
}


function nullPointer2(val) {
    var ret = [];

    for (var i = 0; i < val.length; i++) { // OK
    	var element = val[i];
        ret.push(element.foo + 42);
    }
}

function nullPointer3(val) {
	let arr = val.messaging
	for (let i = 0; i < arr.length; i++) { // OK
		let event = val.messaging[i]
		let sender = event.sender.id
	}
}


function lodashPointer(val) {
    return _.map(val, function(e) { // OK
        return e.foo;
    })
}

function lodashArrowFunc(val) {
	return _.map(val, (e) => { // OK
        return e.foo;
    });
}