angular.module('myModule', [])
    .controller('MyController', ['$scope', 'depA', 'depB', function($scope, depA) {
        // ...
}]);
