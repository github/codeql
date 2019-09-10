'use strict';

var _ = require('lodash');
var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    problem(req.body);

    useLengthIndirectly(req.body);
});

function problem(val) {
    // can take an arbitrary amount of time with a tainted .length property
    _.chunk(val, 2);
}
