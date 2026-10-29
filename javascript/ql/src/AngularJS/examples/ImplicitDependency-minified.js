angular.module('myModule', [])
    .controller('MyController', function(a) { // BAD: dependency 'a' does not exist
        // ...
});
