angular.module('app', [])
    .config(function($sceProvider) {
        $sceProvider.enabled(false); // BAD
    }).controller('controller', function($scope) {
        // ...
        $scope.html = '<ul><li>' + item.toString() + '</li></ul>';
    });
