angular.module('app1', [])
       .run(['dep1', 'dep2', 'dep3', function(dep1, dep3, dep2) {}]);  // $ Alert

angular.module('app2')
       .directive('mydirective', [ '$compile', function($compile, $http) { // $ Alert
           // ...
       }]);

angular.module('app1', [])
       .run(['dep1', 'dep2', 'dep3', function(dep1, dep2, dep3) {}]);

angular.module('app2')
       .directive('mydirective', [ '$compile', '$http', function($compile, $http) {
           // ...
       }]);

angular.module('app3', [])
       .run(function(dep1, dep3) {});

angular.module('app4')
       .directive('mydirective', function($compile, $http) {
           // ...
       });

angular.module('app5')
       .directive('mydirective', [ 'fully.qualified.name', function(name) {
           // ...
       }])

angular.module('app6')
    .directive('mydirective', function() {
        return {
            link: function (scope, element, attrs) {
            }
        };
    });
