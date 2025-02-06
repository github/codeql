(function(){
    function injected1(name){} // $ Alert
    angular.module('app1').controller('controller1', injected1);

    function injected2(name){}
    injected2.$inject = ['name'];
    angular.module('app2').controller('controller2', injected2);

    function injected3(name){}
    angular.module('app3').controller('controller3', ['name', injected3]);

    angular.module('app4').controller('controller4', function(){});

    angular.module('app5').controller('controller5', function(name){}); // $ Alert

    function injected6(){}
    angular.module('app6').controller('controller6', injected6);

    function notInjected7(name){}
    var obj7 = {
        controller: notInjected7
    };

    function injected8(name){} // OK - false negative: we do not track through properties
    var obj8 = {
        controller: injected8
    };
    angular.module('app8').controller('controller8', obj8.controller);

    var $injector = angular.injector();

    function injected9(name){} // $ Alert
    $injector.invoke(injected9)

    function injected10(name){}
    injected10.$inject = ['name'];
    $injector.invoke(injected10)

    function injected11(name){}
    $injector.invoke(['name', injected11])

})();
