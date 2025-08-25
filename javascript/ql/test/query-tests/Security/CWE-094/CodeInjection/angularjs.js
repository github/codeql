angular.module('myModule', [])
    .controller('MyController', function($scope) {
        $scope.$on(location.search);
    })
    .controller('MyController', function($scope) {
        $scope.$apply('hello');
    })
    .controller('MyController', function($scope) {
        var scope = $scope;
        scope.$apply(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$apply(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$applyAsync(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$eval(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$evalAsync(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$watch(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$watchCollection(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($scope) {
        $scope.$watchGroup(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($compile) {
        $compile(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($compile) {
        $compile('hello');
    })
    .controller('MyController', function($compile) {
        $compile(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($compile) {
        var compile = $compile;
        compile(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($parse) {
        $parse(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($interpolate) {
        $interpolate(location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], location.search); // $ Alert[js/code-injection]
    })
    .controller('MyController', function($filter) {
        $filter('orderBy')([], 'hello');
    })
    .controller('MyController', function($filter) {
        $filter('random')([], location.search);
    })
    .controller('MyController', function($someService) {
        $someService('orderBy')([], location.search);
    })
    .controller('MyController', function($someService) {
        $someService(location.search);
    });
