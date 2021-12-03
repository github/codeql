// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE in parent directory.
angular
  .module('docsBindExample', [])
  .controller('ExampleController', ['$scope', function($scope) {
    $scope.name = 'Max Karl Ernst Ludwig Planck (April 23, 1858 – October 4, 1947)';
   }]);

window.angular.module('someOtherModule', ['docBindExample']);

angular.module('heroApp').component('heroDetail', {
  templateUrl: 'heroDetail.html',
  bindings: {
    hero: '='
  }
});

function f() {
  let m = angular.module('m', []);
  m.directive('d1', function() {
    return {
      link: function postLink() {}
    };
  });
  m.directive('d2', function() {
    return {
      link: {
        pre: function preLink() {},
        post: function postLink() {}
      }
    };
  });
  m.directive('d3', function() {
    return {
      compile: function() {
        return function postLink() {};
      }
    };
  });
  m.directive('d4', function() {
    return {
      compile: function() {
        return {
          pre: function preLink() {},
          post: function postLink() {}
        };
      }
    };
  });
}
