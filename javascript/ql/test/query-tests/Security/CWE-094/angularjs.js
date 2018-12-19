angular.module('myModule', [])
    .controller('MyController', function($scope) {
        $scope.$on(location.search); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$apply('hello'); // OK
    })
    .controller('MyController', function($scope) {
        var scope = $scope;
        scope.$apply(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$apply(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$applyAsync(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$eval(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$evalAsync(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watch(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watchCollection(location.search); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watchGroup(location.search); // BAD
    })
    .controller('MyController', function($compile) {
        $compile(location.search); // BAD
    })
    .controller('MyController', function($compile) {
        $compile('hello'); // OK
    })
    .controller('MyController', function($compile) {
        $compile(location.search); // BAD
    })
    .controller('MyController', function($compile) {
        var compile = $compile;
        compile(location.search); // BAD
    })
    .controller('MyController', function($parse) {
        $parse(location.search); // BAD
    })
    .controller('MyController', function($interpolate) {
        $interpolate(location.search); // BAD
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], location.search); // BAD
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], 'hello'); // OK
    })
    .controller('MyController', function($filter) {
        $filter('random')([], location.search); // OK
    })
    .controller('MyController', function($someService) {
        $someService('orderBy')([], location.search); // OK
    })
    .controller('MyController', function($someService) {
        $someService(location.search); // OK
    });
