angular.module('myModule', [])
    .controller('MyController', function($scope) {
        $scope.$on('destroy', cleanup); // $ Alert
    })
    .controller('MyController', ["$scope", function(s) {
        s.$on('destroy', cleanup); // $ Alert
    }])
    .controller('MyController', function($scope) {
        var destroy = 'destroy';
        $scope.$on(destroy, cleanup); // $ Alert
    })
    .controller('MyController', function($scope) {
        $scope.$on('$destroy', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$emit('foo');
        $scope.$on('foo', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$on('bar', cleanup); // $ Alert
    })
    .controller('MyController', function($scope) {
        $scope.$on('$locationChangeStart', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$on('lib1.foo', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$on('lib2:foo', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$on('onClick', cleanup);
    })
    .controller('MyController', function($scope) {
        function f($scope){
            $scope.$emit('probablyFromUserCode1')
        }
        $scope.$on('probablyFromUserCode1', cleanup);
    })
    .controller('MyController', function($scope) {
        function f($scope){
            var scope = $scope;
            scope.$emit('probablyFromUserCode2')
        }
        $scope.$on('probablyFromUserCode2', cleanup);
    })
    .controller('MyController', function($scope) {
        $scope.$on('event-from-AngularJS-expression', cleanup);
    })
;
