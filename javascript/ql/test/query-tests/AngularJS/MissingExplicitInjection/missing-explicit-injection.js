(function(){
    function injected1(name){} // NOT OK
    angular.module('app1').controller('controller1', injected1);

    function injected2(name){} // OK
    injected2.$inject = ['name'];
    angular.module('app2').controller('controller2', injected2);

    function injected3(name){} // OK
    angular.module('app3').controller('controller3', ['name', injected3]);

    angular.module('app4').controller('controller4', function(){}); // OK

    angular.module('app5').controller('controller5', function(name){}); // NOT OK

    function injected6(){} // OK
    angular.module('app6').controller('controller6', injected6);

    function notInjected7(name){} // OK
    var obj7 = {
        controller: notInjected7
    };

    function injected8(name){} // OK (false negative: we do not track through properties)
    var obj8 = {
        controller: injected8
    };
    angular.module('app8').controller('controller8', obj8.controller);

    var $injector = angular.injector();

    function injected9(name){} // NOT OK
    $injector.invoke(injected9)

    function injected10(name){} // OK
    injected10.$inject = ['name'];
    $injector.invoke(injected10)

    function injected11(name){} // OK
    $injector.invoke(['name', injected11])

})();
