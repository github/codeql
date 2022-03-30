var _ = (function() {
    if (typeof exports !== 'undefined') {
        if (typeof module !== 'undefined' && module.exports) {
            exports = module.exports = _;
        }
        exports._ = _;
    }
    return {
        define: function(name, factory) {
        }
    };
})(this);

if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
        exports = module.exports = emmet;
    }
    exports.emmet = emmet;
}

(function(){
    var module;
    if(typeof module === 'undefined'); // NOT OK
});
