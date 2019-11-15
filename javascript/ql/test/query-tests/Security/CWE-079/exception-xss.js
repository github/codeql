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
		$('myId').html(e); // NOT OK!
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
});
