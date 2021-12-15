(function() {
	var o1 = {
		m1: function(){ return {}; },
		m2: function(){ return {}; },
		m3: function(){ return {}; },
		m4: function(){ return {}; }
	};
	o1.m1(); // analyzed precisely
	o1.m2(); // analyzed precisely
	unknown(o1.m2);
	var o = unknown? o1: {};
	o.m3(); // not analyzed precisely: `o1` is not the only receiver.
	var m4 = o.m4;
	m4(); // (not a method call)

	var o2 = {};
	o2.m = function() { return {}; };
	// not analyzed precisely: `m` may be in the prototype since `m`
	// is not in the initializer, and we do not attempt to reason flow
	// sensitively beyond that at the moment
	o2.m();
});
(function(){
	function f1(){return {};}
	var v1 = {m: f1}.m(); // analyzed precisely
	v1 === true;

	function f2(){return {};}
	var o2 = {m: f2};
	var v2 = o2.m(); // analyzed precisely
	v2 === true;

	function f3(){return {};}
	var v3 = ({m: f3}).m(); // analyzed precisely
	v3 === true;

	function f4(){return {};}
	var { o4 } = {m: f4};
	// not analyzed precisely: o4 is from a destructuring assignment
	// (and it is even `undefined` in this case)
	var v4 = o4.m();
	v4 === true;
});

(function(){
	(function(o = {m: () => 42}){
		var v1 = o.m(); // not analyzed precisely: `o` may be `unknown`
	})(unknown);

	function f(o = {m: () => 42}){
		var v2 = o.m(); // not analyzed precisely: `o` may be `unknown`
	};
	f(unknown);
	(function(o = {m: () => 42}){
		var v3 = o.m(); // not analyzed precisely: `o.m` may be `unknown`
	})({m: unknown});
	(function(o = {m: () => 42}){
		// not analyzed precisely: we only support unique receivers at
		// the moment
		var v4 = o.m();
	})({m: () => true});

});
