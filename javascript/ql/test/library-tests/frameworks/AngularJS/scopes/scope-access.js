angular.module('myApp', [])
    .directive('directive1',  function() {
        return {
            link: function linkFunction(scope, element, attrs) {
                scope;
            },
            scope: {}
        };
    })
    .directive('directive2',  function() {
        return {
            controller: function($scope){
                $scope;
            },
            scope: {}
        };
    })
    .directive('directive3',  function() {
        return {
            controller: function(foo, $scope){
                $scope;
            },
            scope: {}
        };
    })
    .directive('directive4',  function() {
        return {
            controller: ['$scope', function(a){
                a;
            }],
            scope: {}
        };
    })
    .directive('directive5',  function() {
        return {
            controller: function(){
                this;
            },
            scope: {},
            bindToController: true
        };
    })
    .directive('directive6',  function() {
        return {
            controller: function(){
                (x => this);
            },
            scope: {},
            bindToController: true
        };
    })
    .directive('directive7',  function() {
        return {
            controller: function($scope){
                $scope;
            }
        };
    })
    .controller('controller1', ['$scope', function($scope) {
        $scope
    }])
;
