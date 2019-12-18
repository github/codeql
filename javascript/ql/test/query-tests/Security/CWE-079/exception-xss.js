(function() {
    var foo = document.location;
    
    function inner(x) {
    	unknown(x);
	}

	try {
		unknown(foo);
	} catch(e) {
		$('myId').html(e); // NOT OK!
	}
	
	try {
		inner(foo);
	} catch(e) {
		$('myId').html(e); // NOT OK!
	}
	
	try {
		unknown(foo + "bar");
	} catch(e) {
		$('myId').html(e); // NOT OK!
	}
	
	try {
		unknown({prop: foo});
	} catch(e) {
		$('myId').html(e); // We don't flag this for now.
	}
	
	try {
		unknown(["bar", foo]);
	} catch(e) {
		$('myId').html(e); // NOT OK!
	}
	
	function deep(x) {
		deep2(x);
	}
	function deep2(x) {
		inner(x);
	}
	
	try {
		deep("bar" + foo);
	} catch(e) {
		$('myId').html(e); // NOT OK!
	}
	
	try {
		var tmp = "bar" + foo;
	} catch(e) {
		$('myId').html(e); // OK 
	}
	
	function safe(x) {
		var foo = x + "bar";
	}
	
	try {
		safe(foo);
	} catch(e) {
		$('myId').html(e); // OK 
	}
	
	try {
		safe.call(null, foo);
	} catch(e) {
		$('myId').html(e); // OK 
	}
	var myWeirdInner;
	try {
		myWeirdInner = function (x) {
			inner(x);
		}		
	} catch(e) {
		$('myId').html(e); // OK 
	}
	try {
		myWeirdInner(foo);
	} catch(e) {
		$('myId').html(e); // NOT OK! 
	}
	
	$('myId').html(foo); // Direct leak, reported by other query.
	
	try {
		unknown(foo.match(/foo/));
	} catch(e) {
		$('myId').html(e); // NOT OK! 
	}
	
	try {
		unknown([foo, "bar"]);
	} catch(e) {
		$('myId').html(e); // NOT OK! 
	}

	try {
		try {
			unknown(foo);
		} finally {
			// nothing
		}
	} catch(e) {
		$('myId').html(e); // NOT OK! 
	}
});

var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  try {
    unknown(req.params.id);
  } catch(e) {
    res.send("Exception: " + e); // NOT OK!
  }
});


(function () {
    sessionStorage.setItem('exceptionSession', document.location.search);

	try {
		unknown(sessionStorage.getItem('exceptionSession'));
	} catch(e) {
		$('myId').html(e); // NOT OK
	}
})();
