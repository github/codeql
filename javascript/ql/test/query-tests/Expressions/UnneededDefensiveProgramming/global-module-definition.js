var Mod1;
(function (Mod1) {
    Mod1.p = 42;
})(Mod1 || (Mod1 = {}));

(function(){
    var Mod2;
    (function (Mod2) {
        Mod2.p = 42;
    })(Mod2 || (Mod2 = {})); // NOT OK
});
