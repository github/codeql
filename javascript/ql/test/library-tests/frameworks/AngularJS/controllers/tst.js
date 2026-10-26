angular.module('myApp')
    .controller('myController1', function mc1($scope) {
    })
    .controller('myController2', function mc2($scope) {
    })
    .config(function($routeProvider) {
        $routeProvider
            .when('somePath', {
                controller: function mc3($scope) {
                },
                templateUrl: "template3.html"
            })
            .otherwise({
                controller: function mc4($scope) {
                },
                templateUrl: "template4.html"
            })
            .when('somePath', {
                controller: 'myController1',
                templateUrl: "template1.html"
            })
            .when('somePath', {
                controller: 'myController1',
                templateUrl: "template1.html",
                controllerAs: "mc1"
            })
    });
;
