angular.module('myModule', [])
    .controller('MyController', function($scope) {
        $scope.$on(document.cookie); // OK
    })
    .controller('MyController', function($scope) {
        $scope.$apply('hello'); // OK
    })
    .controller('MyController', function($scope) {
        var scope = $scope;
        scope.$apply(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$apply(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$applyAsync(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$eval(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$evalAsync(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watch(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watchCollection(document.cookie); // BAD
    })
    .controller('MyController', function($scope) {
        $scope.$watchGroup(document.cookie); // BAD
    })
    .controller('MyController', function($compile) {
        $compile(document.cookie); // BAD
    })
    .controller('MyController', function($compile) {
        $compile('hello'); // OK
    })
    .controller('MyController', function($compile) {
        $compile(document.cookie); // BAD
    })
    .controller('MyController', function($compile) {
        var compile = $compile;
        compile(document.cookie); // BAD
    })
    .controller('MyController', function($parse) {
        $parse(document.cookie); // BAD
    })
    .controller('MyController', function($interpolate) {
        $interpolate(document.cookie); // BAD
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], document.cookie); // BAD
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], 'hello'); // OK
    })
    .controller('MyController', function($filter) {
        $filter('random')([], document.cookie); // OK
    })
    .controller('MyController', function($someService) {
        $someService('orderBy')([], document.cookie); // OK
    })
    .controller('MyController', function($someService) {
        $someService(document.cookie); // OK
    })
