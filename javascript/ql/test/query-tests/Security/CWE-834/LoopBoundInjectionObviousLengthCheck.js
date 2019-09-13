'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    problem(req.body);
});

function problem(val) {
    var ret = [];

    // Prevents DoS
    if (val.length > 100) {
        return [];
    }

    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i]);
    }
}
