angular.module('myApp')
    .controller('myController1', function mc1($scope) {
    })
    .config(function($routeProvider) {
        $routeProvider
            .when('somePath', {
                controller: function mc3($scope) {
                }
            })
            .otherwise({
                controller: function mc4($scope) {
                }
            })
            .when('somePath', {
                controller: 'myController1'
            })
    });
;
