function f() {
	// OK: initialization to default value
	var x = null, y = undefined, z;
	x = {};
	// NOT OK
	y = 23;
	y = 42;
	for (var p in x)
		y+p;
	// OK: assignment to global
	global = 42;
	// NOT OK
	var a = 23; a = 42;
	// OK: captured variable
	var b = 42;
	return function() {
		return b%2
	};
}

function g() {
	var x;
	// OK
	x = 23, x += 19;
	// OK
	var y = 42;
}

function h() {
	// OK
	var x = false;
	try {
		this.mayThrow();
		x = true;
	} catch(e) {}
	console.log(x);
}

function k(data) {
	// OK
	for(var i=0;i<data.length;i++);
}

function l() {
	var x = 23;
	x = 42;
	return x;
}

function m() {
	var x = 23, y;
	x = 42, y = x+14;
	return x+y;
}

function n() {
	var i = 0;
	for(i = 0; i < 10; ++i);
}

function p() {
	var i;
	for (i=0; i < 10; ++i) {
		if (Math.random() > .5)
			// OK
			i = 23;
	}
}

function q() {
	var self = this, node, next;
	for (node = self.firstChild; node; ) {
		next = node.next;
		self.insert(node, self, true);
		node = next;
	}
	self.remove();
}

function r() {
    var i;
    for (i = 0;;)
        console.log(i);
}

function s() {
    var container = document.createElement("div"),
        div = document.createElement("div");
    doStuffWith(container, div);
    // OK
    container = div = null;
}

// OK: the function expression could be made anonymous, but it's not
// worth flagging this as a violation
defineGetter(req, 'subdomains', function subdomains() {
    var hostname = this.hostname;
    if (!hostname) return [];
    var offset = this.app.get('subdomain offset');
    var subdomains = !isIP(hostname)
      ? hostname.split('.').reverse()
      : [hostname];
    return subdomains.slice(offset);
});

// OK: assigning default values
function t() {
  var x;
  x = false;
  x = ""; x = '';
  x = 0; x = 0.0; x = -1;
  x = 42; return x;
}

// OK: unnecessary initialisation as type hint
function u() {
  var x;
  x = [];
  x = {};
  x = 42; return x;
}

// OK: assigning `undefined`
function v() {
  var x;
  x = void 0;
  x = 42;
  return x;
}

!function(o) {
  var {x} = o;
  x = 42;
  return x;
}

// OK: assignments in dead code not flagged
!function() {
  return;
  var x;
  x = 23;
  x = 42;
  return x;
}

(function(){
	var x = (void 0);
	var y = ((void 0));
	var z1 = z2 = (void 0);
	x = 42;
	y = 42;
	z1 = 42;
	z2 = 42;
	return x + y + z1 + z2;
});

(function() {
	for (var a = (x, -1) in v = a, o);
});

(function() {
	let [x] = [0], // OK, but flagged due to destructuring limitations
	    y = 0;
	x = 42;
	y = 87;
	x;
	y;
});

(function() {
	if (something()) {
		var nSign = foo;
	} else {
		console.log(nSign);
	}
})()
