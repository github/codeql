(function localSource(){

	let local1 = {};
	let local2 = { f: function(){} };
	let local3 = { [unknown]: 42 };

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

(function localProperty(){

	let local1 = { p: 42 };
	local1.p;
	local1.p;

	let local2 = { p: 42, q: 42 };
	local2.p;
	local2.p;
	local2.q = 42;
	local2 = 42;

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
		let local3 = { p: 42 };
		o = o || local3;
		o.p;
	}

	let local4 = { };
	local4.p;

	let local5 = { p: 42 },
	    local6 = { p: true };
	(unknown? local5: local6).p; // could support this with a bit of extra work

	(function(semiLocal7){
		if(unknown)
			semiLocal7 = {};
		semiLocal7.p = 42;
	});

});

(function (){
	let bound = {};
	bound::unknown();
});

// semmle-extractor-options: --experimental
