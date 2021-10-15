// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('docsIsolationExample', [])
.controller('Controller', ['$scope', function($scope) { // Scope
  $scope.naomi = { name: 'Naomi', address: '1600 Amphitheatre' }; // Scope, ScopeProperty
  $scope.vojta = { name: 'Vojta', address: '3456 Somewhere Else' };  // Scope, ScopeProperty
}])
.directive('myCustomer', function() {
  return {
    restrict: 'E',
    scope: { // ScopeOption
      customerInfo: '=info' // ScopeProperty, ExplicitScopeOptionPropertyKey
    },
    templateUrl: 'dev-guide-6-template.html'
  };
});
