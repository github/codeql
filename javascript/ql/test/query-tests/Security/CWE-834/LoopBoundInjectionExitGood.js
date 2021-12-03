var express = require('express');
var router = new express.Router();
var rootRoute = router.route('foobar');

var _ = require("lodash");

rootRoute.post(function (req, res) {
	breaks(req.body);
	
	throws(req.body);
	
	returns(req.body);
	
	lodashThrow(req.body);
});

function breaks(val) {
	var ret = [];
	
	for (var i = 0; i < val.length; i++) { // OK
	  if (val[i] == null) {
		  break; // Prevents DoS.
	  }
      ret.push(val[i]);
    }
}

function throws(val) {
	var ret = [];
	
	for (var i = 0; i < val.length; i++) { // OK
	  if (val[i] == null) {
		  throw 2; // Prevents DoS.
	  }
      ret.push(val[i]);
    }
}

// The obvious null-pointer detection should not hit this one.
function returns(val) {
	var ret = [];
	
	for (var i = 0; i < val.length; i++) { // OK
	  if (val[i] == null) {
		  return 2; // Prevents DoS.
	  }
      ret.push(val[i]);
    }
}

function lodashThrow(val) {
	_.map(val, function (e) { // OK
		if (!e) {
			throw new Error(); // Prevents DoS.
		}
	})
}
