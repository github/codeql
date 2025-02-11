(function(){
    var o = {};
    o.pure1 = 42; // $ Alert
    o.pure1 = 42;

    o.pure2 = 42; // $ Alert
    o.pure2 = 43;

    o.impure3 = 42;
    f();
    o.impure3 = 42;

    o.pure4 = 42; // $ Alert
    43;
    o.pure4 = 42;

    o.impure5 = 42;
    o.impure5 = f();

    o.pure6 = f(); // $ Alert
    o.pure6 = 42;

    o.pure7 = 42; // $ Alert
    if(x){}
    o.pure7 = 42;

    o.pure8_cond = 42;
    if(x){
        o.pure8_cond = 42;
    }

    o.impure9 = 42;
    f();
    if(x){
    }
    o.impure9 = 42;

    o.impure10 = 42;
    if(x){
        f();
    }
    o.impure10 = 42;

    o.impure11 = 42;
    if(x){

    }
    f();
    o.impure11 = 42;

    o.pure12_read = 42;
    o.pure12_read;
    o.pure12_read = 42;

    var o2;
    o.pure13_otherRead = 42;
    o2.pure13_otherRead;
    o.pure13_otherRead = 42;

    function id14(e) {
        return e;
    }
    var o14 = id14(o);
    o.pure14_aliasRead = 42;
    o14.pure14_aliasRead;
    o.pure14_aliasRead = 42;

    function id15(e) {
        return e;
    }
    var o15 = id15(o);
    o.pure15_aliasWrite = 42;
    o15.pure15_aliasWrite = 42;

    var o16 = x? o: null;
    o.pure16_simpleAliasWrite = 42; // $ Alert
    o16.pure16_simpleAliasWrite = 42;

    var o17 = {
        duplicate17: 42,
        duplicate17: 42
    }

    // DOM
    o.clientTop = 42;
    o.clientTop = 42;

    o.defaulted1 = null;
    o.defaulted1 = 42;

    o.defaulted2 = -1;
    o.defaulted2 = 42;

    var o = {};
    o.pure18 = 42; // $ Alert
    o.pure18 = 42; // $ Alert
    o.pure18 = 42;

	var o = {};
	Object.defineProperty(o, "setter", {
		set: function (value) { }
	});
	o.setter = "";

	var o = { set setter(value) { } };
	o.setter = "";

	var o = {
		set accessor(value) { },
		get accessor() { }
	};

	var o = { set setter(value) { } };
	o.setter = 42; // $ Alert - probably OK, but still flagged - it seems fishy
	o.setter = 87;

	var o = {};
	Object.defineProperty(o, "prop", {writable:!0,configurable:!0,enumerable:!1, value: getInitialValue()}) // $ Alert
	o.prop = 42;

	var o = {};
	Object.defineProperty(o, "prop", {writable:!0,configurable:!0,enumerable:!1, value: undefined}) // OK - default value
	o.prop = 42;

	var o = {};
	Object.defineProperty(o, "prop", {writable:!0,configurable:!0,enumerable:!1})
    o.prop = 42;
    
    var o = {};
    o.pure19 = 42;
    o.some_other_property = 42;
    o.pure19 = 42;

    var o = {};
    o.pure20 = 42;
    some_other_obj.some_other_property = 42;
    o.pure20 = 42;
});
