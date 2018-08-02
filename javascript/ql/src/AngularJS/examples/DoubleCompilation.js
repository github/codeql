angular.module('myapp')
       .directive('addToolTip', function($compile) {
  return {
    link: function(scope, element, attrs) {
      var tooltip = angular.element('<span ng-show="showToolTip">A tooltip</span>');
      tooltip.on('mouseenter mouseleave', function() {
        scope.$apply('showToolTip = !showToolTip');
      });
      element.append(tooltip);
      $compile(element)(scope); // NOT OK
    }
  };
});
