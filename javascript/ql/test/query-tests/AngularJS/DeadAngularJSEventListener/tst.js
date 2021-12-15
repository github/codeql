angular.module('myModule', [])
    .controller('MyController', function($scope) {
        $scope.$on('destroy', cleanup); // BAD
    })
    .controller('MyController', ["$scope", function(s) {
        s.$on('destroy', cleanup); // BAD
    }])
    .controller('MyController', function($scope) {
        var destroy = 'destroy';
        $scope.$on(destroy, cleanup); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$on('$destroy', cleanup); // GOOD
    })
    .controller('MyController', function($scope) {
        $scope.$emit('foo');
        $scope.$on('foo', cleanup); // GOOD
    })
    .controller('MyController', function($scope) {
        $scope.$on('bar', cleanup); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$on('$locationChangeStart', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$on('lib1.foo', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$on('lib2:foo', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$on('onClick', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        function f($scope){
            $scope.$emit('probablyFromUserCode1')
        }
        $scope.$on('probablyFromUserCode1', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        function f($scope){
            var scope = $scope;
            scope.$emit('probablyFromUserCode2')
        }
        $scope.$on('probablyFromUserCode2', cleanup); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$on('event-from-AngularJS-expression', cleanup); // GOOD
    })
;
