angular.module('myModule', [])
    .controller('MyController', ['$scope', function($scope) { // GOOD: explicit dependency name
        // ...
}]);
