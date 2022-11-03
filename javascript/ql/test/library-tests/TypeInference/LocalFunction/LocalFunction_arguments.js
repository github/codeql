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
