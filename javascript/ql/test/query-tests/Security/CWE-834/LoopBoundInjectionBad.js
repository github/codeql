'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    problem(req.body);

    whileLoop(req.body);

    useLengthIndirectly(req.body);

    noNullPointer(req.body);
});

function problem(val) {
    var ret = [];

    for (var i = 0; i < val.length; i++) { // NOT OK!
        ret.push(val[i]);
    }
}

function whileLoop(val) {
    var ret = [];
    var i = 0;
    
    while (i < val.length) { // NOT OK!
        ret.push(val[i]);
        i++;
    }
}

function useLengthIndirectly(val) {
    var ret = [];

    var len = val.length; // NOT OK!

    for (var i = 0; i < len; i++) {
        ret.push(val[i]);
    }
}

// The obvious null-pointer detection should not hit this one.
function noNullPointer(val) {
    var ret = [];

    const c = 0;

    for (var i = 0; i < val.length; i++) { // NOT OK!
        
        // Constantly accessing element 0, therefore not guaranteed null-pointer.
        ret.push(val[c].foo); 
    }
}
