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
	
	for (var i = 0; i < val.length; i++) {
	  for (var k = 0; k < 2; k++) {
		  if (k == 3) {
		      // Does not prevent DOS, because this is inside an inner loop.
			  break; 
		  }
	  }
      ret.push(val[i]);
    }
}

function throws(val) {
	var ret = [];
	
	for (var i = 0; i < val.length; i++) {
	  if (val[i] == null) {
		  try {
			  throw 2; // Is catched, and therefore the DOS is not prevented.
		  } catch(e) {
			  // ignored
		  }
	  }
      ret.push(val[i]);
    }
}

// the obvious null-pointer detection should not hit this one.
function returns(val) {
	var ret = [];
	
	for (var i = 0; i < val.length; i++) {
	  if (val[i] == null) {
		  (function (i) {
			  return i+2; // Does not prevent DOS.
		  })(i);
	  }
      ret.push(val[i]);
    }
}

function lodashThrow(val) {
	_.map(val, function (e) {
		if (!e) {
			try {
				throw new Error(); // Does not prevent DOS
			} catch(e) {
				// ignored.
			}
		}
	})
}