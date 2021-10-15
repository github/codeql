(function(){
    var captured1 = {
        used1: 42,
        unused1: 42
    };
    captured1.used1;

    var unused2 = {
        unused2a: 42,
        unused2b: 42
    };

    for (x.p in { used3: 42 });
    for (x.p of { used4: 42 });
    42 in { used5: 42 };
    f(...{used6: 42});
    [...{used7: 42}];
	({...{used8: 42}});
	({ unused9: 42 }) + "";
    ({ used10: 42 }).hasOwnProperty;
    ({ used10: 42 }).propertyIsEnumerable;

    (function(){
        var captured11 = {
            used11: 42,
            unused11: 42
        };
        captured11.used11;

        var captured12 = {
            used12_butNotReally: 42,
            unused12: 42
        };

        throw x;

        captured12.used12_butNotReally;

        var captured13 = {
            used13: 42,
            unused13: 42
        };
        captured13.used13;
    });
    (function(options){
        if(unknown)
            options = {};
        options.output = 42;
    });

	var captured14 = {
		unused14: 42
	};
	captured14.unused14 = 42;
	captured14.unused14 = 42;


	var captured15 = {
		semiUnused15: 42
	};
	captured15.semiUnused15 = 42;
	captured15.semiUnused15;
});
(function(unusedParam = {unusedProp: 42}){

});
(function(){
	var unusedObj = {
		unusedProp: 42
	};
});
(function(){
	var unusedSpecials = {
		toString: function(){},
		valueOf: function(){},
		'@@iterator': function(){}
	};
	unusedSpecials.foo;
});

(function(){
	({ unusedProp: 42 }, 42);
});
