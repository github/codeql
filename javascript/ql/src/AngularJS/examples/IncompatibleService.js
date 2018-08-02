angular.module('myModule', [])
    .config(['year', function(year) {
        // ...
    }]);

angular.module('myModule')
    .value('year', 2000); // BAD: year is of kind 'value'
