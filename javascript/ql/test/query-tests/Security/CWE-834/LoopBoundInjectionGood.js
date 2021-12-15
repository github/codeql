'use strict';

var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

rootRoute.post(function(req, res) {
    sanitized(req.body);

    sanitized2(req.body);

    sanitized3(req.body);

    sanitized4(req.body);
});

function sanitized(val) {
    var ret = [];

    if (!Array.isArray(val)) {
        return [];
    }
    // At this point we know that val must be an Array, and an attacker is
    // therefore not able to send a cheap request that spends a lot of time
    // inside the loop.
    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i] + 42);
    }
}

function sanitized2(val) {
    var ret = [];

    if (typeof val === "object") {
        return [];
    }
    // Val can only be a primitive. Therefore no issue!
    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i] + 42);
    }
}

function isArray(foo) {
    return foo instanceof Array;
}

function sanitized3(val) {
    var ret = [];

    if (!isArray(val)) {
        return [];
    }
    // At this point we know that val must be an Array, and an attacker is
    // therefore not able to send a cheap request that spends a lot of time
    // inside the loop.
    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i] + 42);
    }
}

function sanitized4(val) {
    var ret = [];

    if (!(val instanceof Array)) {
        return [];
    }
    // At this point we know that val must be an Array, and an attacker is
    // therefore not able to send a cheap request that spends a lot of time
    // inside the loop.
    for (var i = 0; i < val.length; i++) { // OK
        ret.push(val[i] + 42);
    }
}
