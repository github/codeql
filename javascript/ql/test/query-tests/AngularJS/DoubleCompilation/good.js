// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE.

angular.module('app').directive('addMouseover', function($compile) {
  return {
    link: function(scope, element, attrs) {
      var newEl = angular.element('<span ng-show="showHint"> My Hint</span>');
      element.on('mouseenter mouseleave', function() {
        scope.$apply('showHint = !showHint');
      });

      element.append(newEl);
      $compile(newEl)(scope); // Only compile the new element
    }
  }
})

// less problematic variant

angular.module('app').directive('addMouseover', function($compile) {
  return {
    link: function(scope, element, attrs) {
      var newEl = angular.element('<span ng-show="showHint"> My Hint</span>');
      element.on('mouseenter mouseleave', function() {
        scope.$apply('showHint = !showHint');
      });

      attrs.$set('addMouseover', null); // To stop infinite compile loop
      element.append(newEl);
      $compile(element, transclude, -9999)(scope); // Avoid double compilation via maxPriority
    }
  }
})
