angular.module('app1', [])
       .run(['dep1', 'dep2', 'dep3', function(dep1, dep3, dep2) {}]);  // NOT OK

angular.module('app2')
       .directive('mydirective', [ '$compile', function($compile, $http) { // NOT OK
           // ...
       }]);

angular.module('app1', [])
       .run(['dep1', 'dep2', 'dep3', function(dep1, dep2, dep3) {}]);  // OK

angular.module('app2')
       .directive('mydirective', [ '$compile', '$http', function($compile, $http) { // OK
           // ...
       }]);

angular.module('app3', [])
       .run(function(dep1, dep3) {});  // OK

angular.module('app4')
       .directive('mydirective', function($compile, $http) {  // OK
           // ...
       });

angular.module('app5')
       .directive('mydirective', [ 'fully.qualified.name', function(name) { // OK
           // ...
       }])

angular.module('app6')
    .directive('mydirective', function() {
        return {
            link: function (scope, element, attrs) { // OK
            }
        };
    });
