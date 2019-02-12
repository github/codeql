(function() {
	var o1 = {
		m1: function(){ return {}; },
		m2: function(){ return {}; },
		m3: function(){ return {}; },
		m4: function(){ return {}; }
	};
	o1.m1();
	o1.m2();
	unknown(o1.m2);
	var o = unknown? o1: {};
	o.m3(); // NOT supported
	var m4 = o.m4;
	m4();

	var o2 = {};
	o2.m = function() { return {}; };
	o2[unknown] = function() { return true; }; // could be __proto__
	o2.m();
});
(function(){
	function f1(){return {};}
	var v1 = {m: f1}.m();
	v1 === true;

	function f2(){return {};}
	var o2 = {m: f2};
	var v2 = o2.m();
	v2 === true;

	function f3(){return {};}
	var v3 = ({m: f3}).m();
	v3 === true;

	function f4(){return {};}
	var { o4 } = {m: f2};
	var v4 = o4.m();
	v4 === true;
});

(function(){
	(function(o = {m: () => 42}){
		var v1 = o.m();
	})(unknown);

	function f(o = {m: () => 42}){
		var v2 = o.m();
	};
	f(unknown);
	(function(o = {m: () => 42}){
		var v3 = o.m();
	})({m: unknown});
	(function(o = {m: () => 42}){
		var v4 = o.m();
	})({m: () => true});

});
