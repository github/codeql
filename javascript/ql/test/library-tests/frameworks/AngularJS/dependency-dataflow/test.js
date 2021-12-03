angular.module('myApp', [])
    .controller('myController', function($scope) {
        $scope.call1();
        $scope.read1;
        $scope.write1 = 42;

        function f(){
            $scope.call2();
            $scope.read2;
            $scope.write2 = 42;
        }

        function g($scope){
            $scope.notAScopeCall3();
            $scope.notAScopeRead3;
            $scope.notAScopeWrite3 = 42;
        }

        var scope = $scope;
        scope.call4();
        $scope.read14
        $scope.write4 = 42;
        function h(){
            scope.call5();
            scope.read5;
            scope.write5 = 42;

        }
    })
angular.module('myApp', [])
    .directive('myDirective',  function() {
        return {
            link: function linkFunction(scope, element, attrs) { // A scope is injected here
                scope.call6()
                scope.read6;
                scope.write6 = 42;
            }
        };
    });
