var someModule = require('someModule'),
    myModule = require('./myModule');

(function(){})();
(function(){ return; })();
(function(){ return true; })();
(function(){ if (unknown) return true; return false; })();
(function(){ return unknown; })();
(function(){
    function f1(){}
    f1();

    function f2(){}
    f2();
    f2();

    var o1 = { f3: function f3(){} };
    o1.f3();

    function f4(){
        return function f5(){}
    }
    f4()();

    function f6(){
        return function f7(){
            return function f8(){}
        }
    }
    f6()()();

    var f9 = unknown();
    f9();

    var f10 = unknown? function (){}: function (){};
    f10();

    var f11 = unknown? function (){ return 42; }: function (){ return "foo"; };
    f11();

    var f12 = unknown? function (){}: unknown();
    f12();

    var f13 = unknown? function (){}: 42;
    f13(); // the call may crash, but the eventual return value is known!

    var f14 = unknown? (unknown? function (){ return 42}: function (){ return "foo"; }): 42;
    f14(); // the call may crash, but the eventual return value is known!

    someFunction();
    someObject.someMethod();

    someModule();
    someModule.someMethod();

    myModule();
    myModule.myMethod1();
    myModule.myMethod2().myMethod3();

    var f15 = unknown? function (){}: undefined;
    f15(); // the call may crash, but the eventual return value is known!

    var f16 = unknown? function (){}: {};
    f16(); // the call may crash, but the eventual return value is known!

    for (var f of { f: function(){} }) {
        var f17 = unknown? f: function(){}
        f17();
    }

    for (var f of unknown) {
        var f18 = unknown? f: function(){};
        f18();
    }

    var f19 = undefined;
    f19();

    var f20 = unknown? {}: undefined;
    f20();

    (function () {
        var getF = function(){}
        var f = getF();
        (function () {
            f();
        });
        function getG(){}
        var g = getG();
        (function () {
            g();
        });
    });

});
