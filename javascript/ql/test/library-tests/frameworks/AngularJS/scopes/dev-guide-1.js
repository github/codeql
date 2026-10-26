// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('scopeExample', [])
.controller('MyController', ['$scope', function($scope) { // Scope
  $scope.username = 'World';  // Scope, ScopeProperty

  $scope.sayHello = function() { // Scope, ScopeProperty
    $scope.greeting = 'Hello ' + $scope.username + '!';  // Scope, ScopeProperty
  };
}]);
