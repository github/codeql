angular.module("MyMod").controller("MyCtrl", function($scope, $timeout) {
    "ngInject";
    // ...
});

angular.module("MyMod").controller("MyCtrl", ["$scope", "$timeout", function($scope, $timeout) {
    "ngNoInject";
    // ...
}]);
