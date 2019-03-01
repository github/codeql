(function(){
    var local1 = {
        used1: 42,
        unused1: 42
    };
    local1.used1;

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
        var local11 = {
            used11: 42,
            unused11: 42
        };
        local11.used11;

        var local12 = {
            used12_butNotReally: 42,
            unused12: 42
        };

        throw x;

        local12.used12_butNotReally;

        var local13 = {
            used13: 42,
            unused13: 42
        };
        local13.used13;
    });
    (function(options){
        if(unknown)
            options = {};
        options.output = 42;
    });

	var local14 = {
		unused14: 42
	};
	local14.unused14 = 42;
	local14.unused14 = 42;


	var local15 = {
		semiUnused15: 42
	};
	local15.semiUnused15 = 42;
	local15.semiUnused15;
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
