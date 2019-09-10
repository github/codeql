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

    // Potential DOS! .length property could have been set to an arbitrary
    // value!
    for (var i = 0; i < val.length; i++) {
        ret.push(val[i]);
    }
}

function whileLoop(val) {
    var ret = [];
    var i = 0;
    // Potential DOS! .length property could have been set to an arbitrary
    // value!
    while (i < val.length) {
        ret.push(val[i]);
        i++;
    }
}

function useLengthIndirectly(val) {
    var ret = [];

    var len = val.length;

    // Same as above, but the .length access happens outside the loop.
    for (var i = 0; i < len; i++) {
        ret.push(val[i]);
    }
}

// the obvious null-pointer detection should not hit this one.
function noNullPointer(val) {
    var ret = [];

    const c = 0;

    for (var i = 0; i < val.length; i++) {
        ret.push(val[c].foo); // constantly accessing element 0, therefore not
                                // guaranteed null-pointer.
    }
}