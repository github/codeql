angular.module('myApp', [])
    .directive('myDirective',  function() {
        return {
            template: 'not_code'
        };
    })
    .directive('myDirective',  function() {
        return {
            template: '{{code}}'
        };
    })
    .directive('myDirective',  function() {
        return {
            template: 'Name: {{obj1.field1}} Address: {{obj2.field2}}, {{#not-ast#}}'
        };
    })
;
