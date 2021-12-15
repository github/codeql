(function(){
    function f(){}
    f.$inject = ['dup5', 'dup5']; // NOT OK
    angular.module('myModule', [])
        .run(['dup1a', 'dup1a', function(dup1a, dup1a){}]) // OK (flagged by js/duplicate-parameter-name)
        .run(['dup2a', 'dup2a', function(dup2a, dup2b){}]) // NOT OK
        .run(['dup3b', 'dup3b', function(dup3a, dup3b){}]) // NOT OK
        .run(['dup4', 'notDup4A', 'dup4', function(notDup4B, dup4, notDup4C){}]) // NOT OK
        .run(f)
        .run(function(dup6, dup6){})// OK (flagged by js/duplicate-parameter-name)
        .run(function(notDup7a, notDup7b){}) // OK
        .run(['notDup8a', 'notDup8b', function(notDup8a, notDup8b){}]) // OK
        .run(['notDup9a', 'notDup9b', function(notDup9c, notDup9d){}]) // OK
        .run(['dup10a', 'dup10a', 'dup10a', function(dup10a, dup10a, dup10a){}]) // OK (flagged by js/duplicate-parameter-name)
        .run(['dup11a', 'dup11a', function(dup11a, dup11b){ // NOT OK (alert formatting for multi-line function)
        }])
    ;
})();
