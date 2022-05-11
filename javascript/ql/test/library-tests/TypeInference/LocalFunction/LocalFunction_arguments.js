(function(){
    function f() {
        arguments.callee()
    }
    f();
    function g() {
        var args = arguments;
        var callee = args.callee;
        callee();
    }
    g();
    function h() {
        var args = arguments;
        args.callee;
    }
    h();
    function i() {
        "use strict";
        arguments.callee(); // does not work in strict mode
    }
    i();
})();

(function(){
    var f1 = function f1() {
        arguments.callee()
    }
    f1();
    var g1 = function g1() {
        var args = arguments;
        var callee = args.callee;
        callee();
    }
    g1();
    var h1 = function h1() {
        var args = arguments;
        args.callee;
    }
    h1();
    var i1 = function i1() {
        "use strict";
        arguments.callee(); // does not work in strict mode
    }
    i1();
})();
