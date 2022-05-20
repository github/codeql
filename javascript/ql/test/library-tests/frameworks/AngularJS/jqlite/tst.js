function f(){
    var e1 = $("<div>");
}
angular.module('myApp', [])
    .service("myService", function($rootElement, $document) {
        var e2 = angular.element('<div>')
        var e3 = $rootElement;
        var e4 = $document;
    })
    .directive('myDirective', function() {
        return {
            link: function(scope, element){
                var e5 = element;
            },
            compile: function(element){
                var e6 = element;
                return function(scope, element){
                    var e7 = element
                }
            },
            template: function(element){
                var e8 = element;
            },
            templateUrl: function(element){
                var e9 = element;
            }
        };
    })
