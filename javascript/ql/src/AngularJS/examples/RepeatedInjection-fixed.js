function myController($scope, $filter) {
    // ...
}
myController.$inject = ["$scope", "$filter"]; // GOOD: specified once
angular.module('myModule', []).controller('MyController', myController);
