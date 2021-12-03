// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('eventExample', [])
.controller('EventController', ['$scope', function($scope) { // Scope
  $scope.count = 0; // Scope, ScopeProperty
  $scope.$on('MyEvent', function() { // Scope, RootScopeProperty
    $scope.count++; // Scope, ScopeProperty
  });
}]);
