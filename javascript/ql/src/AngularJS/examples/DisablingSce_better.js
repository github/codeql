angular.module('app', [])
    .controller('controller', function($scope, $sce) {
        // ...
        // GOOD (but should use the templating system instead)
        $scope.html = $sce.trustAsHtml('<ul><li>' + item.toString() + '</li></ul>'); 
    });
