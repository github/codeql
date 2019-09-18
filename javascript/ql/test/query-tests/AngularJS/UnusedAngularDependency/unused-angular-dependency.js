(function(){
    function f1(used2, unused5) {used2;} // OK (suppressed by js/unused-parameter)

    // this function avoid suppression from js/unused-parameter by explicitly targeting one its weaknesses
    function f2(unused7, used3) {used3;} // NOT OK
    this.f2 = f2;

    angular.module('app1', [])
        .run(function() {})
        .run(function(unused1) {}) // OK (suppressed by js/unused-parameter)
        .run(function(unused2, unused3) {}) // OK (suppressed by js/unused-parameter)
        .run(function(used1, unused4) {used1;}) // OK (suppressed by js/unused-parameter)
        .run(f1)
        .run(["unused6", function() {}]) // NOT OK
        .run(f2)
        .run(["used2", "unused9", function(used2) {}]) // NOT OK
        .run(["unused10", "unused11", function() {}]) // NOT OK
        .run(["used2", "unused12", function(used2) { // NOT OK (alert formatting for multi-line function)
        }])
    ;
})();
angular.module('app2')
    .directive('mydirective', function() {
        return {
            link: function (scope, element, attrs) { // OK
            }
        };
    });
