angular.module('myModule', [])
    .config(['year', function(year) {
        // ...
    }]);

angular.module('myModule')
    .constant('year', 2000); // GOOD: year is of kind 'constant'
