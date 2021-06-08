(function () {
	var foo = document.location;

	function inner(x) {
		unknown(x);
	}

	try {
		unknown(foo);
	} catch (e) {
		$('myId').html(e); // NOT OK!
	}

	try {
		inner(foo);
	} catch (e) {
		$('myId').html(e); // NOT OK!
	}

	try {
		unknown(foo + "bar");
	} catch (e) {
		$('myId').html(e); // NOT OK!
	}

	try {
		unknown({ prop: foo });
	} catch (e) {
		$('myId').html(e); // NOT OK! - but not detected due to not tainting object that have a tainted propety. [INCONSISTENCY]
	}

	try {
		unknown(["bar", foo]);
	} catch (e) {
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
	} catch (e) {
		$('myId').html(e); // NOT OK!
	}

	try {
		var tmp = "bar" + foo;
	} catch (e) {
		$('myId').html(e); // OK 
	}

	function safe(x) {
		var foo = x + "bar";
	}

	try {
		safe(foo);
	} catch (e) {
		$('myId').html(e); // OK 
	}

	try {
		safe.call(null, foo);
	} catch (e) {
		$('myId').html(e); // OK 
	}
	var myWeirdInner;
	try {
		myWeirdInner = function (x) {
			inner(x);
		}
	} catch (e) {
		$('myId').html(e); // OK 
	}
	try {
		myWeirdInner(foo);
	} catch (e) {
		$('myId').html(e); // NOT OK! 
	}

	$('myId').html(foo); // Direct leak, reported by other query.

	try {
		unknown(foo.match(/foo/));
	} catch (e) {
		$('myId').html(e); // NOT OK! 
	}

	try {
		unknown([foo, "bar"]);
	} catch (e) {
		$('myId').html(e); // NOT OK! 
	}

	try {
		try {
			unknown(foo);
		} finally {
			// nothing
		}
	} catch (e) {
		$('myId').html(e); // NOT OK! 
	}
});

var express = require('express');

var app = express();

app.get('/user/:id', function (req, res) {
	try {
		unknown(req.params.id);
	} catch (e) {
		res.send("Exception: " + e); // NOT OK!
	}
});


(function () {
	sessionStorage.setItem('exceptionSession', document.location.search);

	try {
		unknown(sessionStorage.getItem('exceptionSession'));
	} catch (e) {
		$('myId').html(e); // NOT OK
	}
})();


app.get('/user/:id', function (req, res) {
	unknown(req.params.id, (error, res) => {
		if (error) {
			$('myId').html(error); // NOT OK
			return;
		}
		$('myId').html(res); // OK (for now?)
	});
});

(function () {
	var foo = document.location.search;

	new Promise(resolve => unknown(foo, resolve)).catch((e) => {
		$('myId').html(e); // NOT OK
	});

	try {
		null[foo];
	} catch (e) {
		$('myId').html(e); // NOT OK
	}

	try {
		unknown()[foo];
	} catch (e) {
		$('myId').html(e); // OK. We are not sure that `unknown()` is null-ish. 
	}

	try {
		"foo"[foo]
	} catch (e) {
		$('myId').html(e); // OK
	}

	function inner(tainted, resolve) {
		unknown(tainted, resolve);
	}

	new Promise(resolve => inner(foo, resolve)).catch((e) => {
		$('myId').html(e); // NOT OK
	});
})();

app.get('/user/:id', function (req, res) {
	unknown(req.params.id, (error, res) => {
		if (error) {
			$('myId').html(error); // NOT OK
		}
		$('myId').html(res); // OK - does not contain an error, and `res` is otherwise unknown. 
	});
});

app.get('/user/:id', function (req, res) {
	try {
		res.send(req.params.id);
	} catch(err) {
		res.send(err); // OK (the above `res.send()` is already reported by js/xss)
	}
});

var fs = require("fs");

(function () {
	var foo = document.location.search;

	try {
		// A series of functions does not throw tainted exceptions.
		Object.assign(foo, foo)
		_.pick(foo, foo);
		[foo, foo].join(join);
		$.val(foo);
		JSON.parse(foo); 
		/bla/.test(foo);
		console.log(foo);
		log.info(foo);
		localStorage.setItem(foo);
	} catch (e) {
		$('myId').html(e); // OK
	}
	
})();