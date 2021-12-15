angular.module('scopeExample', [])
    .controller('MyScopeController', function(){})
    .controller('MyNamedcopeController', function(){})
    .directive('myDirective',  function() {
        return {
            restrict: 'E',
        };
    })
    .directive('myDirective1',  function() {
        return {
            restrict: 'E',
            scope: {}
        };
    })
    .directive('myDirective2',  function() {
        return {
            restrict: 'E',
            scope: {}
        };
    })
    .directive('myTemplateDirective',  function() {
        return {
            restrict: 'E',
            scope: {},
            template: "{{templateScopeProp}}"
        };
    })
;
