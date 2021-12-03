(function() {
    function f(x) {
        let firstArg = x;
        let alsoFirstArg = arguments[0];
        let secondArg = arguments[1];
        let args = arguments;
        let thirdArg = args[2];
        arguments = {};
        let notFirstArg = arguments[0];
    }
    f(1, 2, 3);
})();
