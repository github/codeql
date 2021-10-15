;

function f() {
	return 23;
	var a = 42;
}

function g(x) {
	switch(x) {
	case 0:
		return 23;
		break;
	default:
		return 42;
	}
}

function h(i) {
	while(true) {
		if (!f(i++)) {
			break;;
		}
	}
}

function k() {
	try {
		h();
	} catch(e) {
		;
	}
	
	for (var p in {});
	for (var i=0; i<10; ++i);
}

throw new Error();
f();

function l(x) {
	switch(x) {
	default:
		return 42;
	case 0:
		return 23;
	}
}

function m(x) {
	switch(x) {
	case 0:
		return 23;
	default:
		return 42;
	case 1:
		return 56;
	}
}

if (true)
	x;
else
	y;

function f(){
	if (x) {
		return;; // trailing ';' is unreachable, but alert is squelched
	}

	if (x) {
		return y;
	} else {
		return z;
	}; // ';' is unreachable, but alert is squelched
}

// test for unreachable throws
function z() {
	return 10;
	throw new Error(); // this throws is unreachable, but alert should not be produced
}
