function myController($scope, $filter) {
    // ...
}
myController.$inject = ["$scope", "$cookies"]; // BAD: always overridden
// ...
myController.$inject = ["$scope", "$filter"];
angular.module('myModule', []).controller('MyController', myController);
