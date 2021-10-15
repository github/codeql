// Adapted from the AngularJS Developer Guide (https://docs.angularjs.org/guide),
// which is licensed under the MIT license; see file LICENSE.

angular.module('app').directive('addMouseover', function($compile) {
  return {
    link: function(scope, element, attrs) {
      var newEl = angular.element('<span ng-show="showHint"> My Hint</span>');
      element.on('mouseenter mouseleave', function() {
        scope.$apply('showHint = !showHint');
      });

      attrs.$set('addMouseover', null); // To stop infinite compile loop
      element.append(newEl);
      $compile(element)(scope); // Double compilation
    }
  }
})
