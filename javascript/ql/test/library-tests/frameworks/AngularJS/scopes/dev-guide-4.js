// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('docsScopeProblemExample', [])
.controller('NaomiController', ['$scope', function($scope) { // Scope
  $scope.customer = { // Scope, ScopeProperty
    name: 'Naomi',
    address: '1600 Amphitheatre'
  };
}])
.controller('IgorController', ['$scope', function($scope) { // Scope
  $scope.customer = { // Scope, ScopeProperty
    name: 'Igor',
    address: '123 Somewhere'
  };
}])
.directive('myCustomer', function() {
  return {
    restrict: 'E',
    templateUrl: 'dev-guide-4-template.html'
  };
});
