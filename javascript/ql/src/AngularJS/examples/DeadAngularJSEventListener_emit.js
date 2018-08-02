angular.module('myModule', [])
    .controller('MyController', function($scope) {
        function cleanup() {
            // close database connection
            // ...
        }
        $scope.$on('destroy', cleanup); // GOOD
    })
    .controller('MyOtherController', function($scope) {
        $scope.$emit('destroy');
    });
