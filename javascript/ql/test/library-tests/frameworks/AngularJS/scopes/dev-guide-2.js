// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular.module('scopeExample', [])
.controller('GreetController', ['$scope', '$rootScope', function($scope, $rootScope) { // Scope, RootScope
  $scope.name = 'World'; // Scope, ScopeProperty
  $rootScope.department = 'AngularJS'; // RootScope, RootScopeProperty
}])
.controller('ListController', ['$scope', function($scope) { // Scope
  $scope.names = ['Igor', 'Misko', 'Vojta']; // Scope, ScopeProperty
}]);
