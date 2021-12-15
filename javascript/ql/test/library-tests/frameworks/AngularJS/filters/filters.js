angular.module('myApp', [])
    .filter('myFilter', function factoryFunction(dependency) {
        return function actualFilter(arg1) {
            return result;
        };
    })
