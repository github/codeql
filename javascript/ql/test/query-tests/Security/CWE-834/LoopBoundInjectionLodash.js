'use strict';

var _ = require('lodash');
var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    problem(req.body); // $ Source
});

function problem(val) {
    _.chunk(val, 2); // $ Alert
}
