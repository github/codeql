angular.module('myModule', [])
    .controller('MyController', function($scope) { // BAD: implicit dependency name
        // ...
});
