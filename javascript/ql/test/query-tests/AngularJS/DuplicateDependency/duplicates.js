(function(){
    function f(){} // $ Alert
    f.$inject = ['dup5', 'dup5'];
    angular.module('myModule', [])
        .run(['dup1a', 'dup1a', function(dup1a, dup1a){}]) // OK - flagged by js/duplicate-parameter-name
        .run(['dup2a', 'dup2a', function(dup2a, dup2b){}]) // $ Alert
        .run(['dup3b', 'dup3b', function(dup3a, dup3b){}]) // $ Alert
        .run(['dup4', 'notDup4A', 'dup4', function(notDup4B, dup4, notDup4C){}]) // $ Alert
        .run(f)
        .run(function(dup6, dup6){})// OK - flagged by js/duplicate-parameter-name
        .run(function(notDup7a, notDup7b){})
        .run(['notDup8a', 'notDup8b', function(notDup8a, notDup8b){}])
        .run(['notDup9a', 'notDup9b', function(notDup9c, notDup9d){}])
        .run(['dup10a', 'dup10a', 'dup10a', function(dup10a, dup10a, dup10a){}]) // OK - flagged by js/duplicate-parameter-name
        .run(['dup11a', 'dup11a', function(dup11a, dup11b){ // $ Alert - alert formatting for multi-line function
        }])
    ;
})();
