// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('docsIsolateScopeDirective', [])
.controller('Controller', ['$scope', function($scope) { // Scope
  $scope.naomi = { name: 'Naomi', address: '1600 Amphitheatre' }; // Scope, ScopeProperty
  $scope.igor = { name: 'Igor', address: '123 Somewhere' }; // Scope, ScopeProperty
}])
.directive('myCustomer', function() {
  return {
    restrict: 'E',
    scope: { // ScopeOption
      customerInfo: '=info' // ScopeProperty, ExplicitScopeOptionPropertyKey
    },
    templateUrl: 'dev-guide-5-template.html'
  };
});
