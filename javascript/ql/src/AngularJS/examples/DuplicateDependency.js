angular.module('myModule', [])
    .controller('MyController', ['$scope',
                                 '$cookies',
                                 '$cookies', // REDUNDANT
                                 function($scope, , $cookies1, $cookies2) {
        // ...
    });
