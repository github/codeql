(function capturedSource(){

	let captured1 = {};
	let captured2 = { f: function(){} };
	let captured3 = { [unknown]: 42 };

	unknown({});

	function known(){}
	known({});

	function known_escaping(e){unknown(e)}
	known_escaping({});

	(function(){return {}});

	(function(){throw {}});

	global = {};

	this.p = {};

	let local_in_with;
	with (unknown) {
		local_in_with = {};
	}

	with({}){}

	({ m: function(){ this; } });
	({ m: unknown });
	let indirectlyUnknown = unknown? unknown: function(){};
	({ m: indirectlyUnknown });
});

(function capturedProperty(){

	let captured1 = { p: 42 };
	captured1.p;
	captured1.p;

	let captured2 = { p: 42, q: 42 };
	captured2.p;
	captured2.p;
	captured2.q = 42;
	captured2 = 42;

	let nonObject = function(){}
	nonObject.p = 42;
	nonObject.p;

	let nonInitializer = {};
	nonInitializer.p = 42;
	nonInitializer.p;

	let overridden1 = { p: 42, p: 42 };
	overridden1.p;

	let overridden2 = { p: 42 };
	overridden2.p = 42;
	overridden2.p;

	let overridden3 = { p: 42 };
	overridden3[x] = 42;
	overridden3.p;

	function f(o) {
		let captured3 = { p: 42 };
		o = o || captured3;
		o.p;
	}

	let captured4 = { };
	captured4.p;

	let captured5 = { p: 42 },
	    captured6 = { p: true };
	(unknown? captured5: captured6).p; // could support this with a bit of extra work

	(function(semiCaptured7){
		if(unknown)
			semiCaptured7 = {};
		semiCaptured7.p = 42;
	});

});

(function (){
	let bound = {};
	bound::unknown();
});

(async function* f() {
  yield* {
    get p() { }
  };
});
