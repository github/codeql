function f() {
    angular.module('myApp', [])
        .directive('d1', function() {
            return {
                restrict: 'E'
            };
        })
        .directive('d2', function() {
            return {
                restrict: 'A'
            };
        })
    ;

    $('<d1>');
    var d2 = $('<div>');
    d2.attr('d2', 'd2');

    angular.module('myApp', [])
        .directive('d3', function() {
            return {
            };
        })
        .directive('d4', function() {
            return {
                restrict: 'E'
            };
        })
        .directive('d5', function() {
            return {
                restrict: 'A'
            };
        })
    ;
    $('<d3>');
    var d4 = $('<div>'); // not matched by directive with restrict='E'
    d4.attr('d4', 'd4');
    $('<d5>'); // not matched by directive with restrict='A'
}
