
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define('my-sub-library', factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else {
        root.mySubLibrary = factory();
    }
}(this, function () {
    function create() {
        return function (name) { // $ Source[js/polynomial-redos]
            /f*g/.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
        }
    }
    return create()
}));
