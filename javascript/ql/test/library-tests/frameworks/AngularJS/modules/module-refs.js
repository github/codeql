(function(){
    // defining
    var dm1 = angular.module('myModule', []);

    // referencing
    var rm1 = angular.module('myModule');

    // chaining
    var cm1 = dm1.config();
    var cm2 = dm1.constant();
    var cm3 = dm1.controller();
    var cm4 = dm1.factory();
    var cm5 = dm1.provider();
    var cm6 = dm1.run();
    var cm7 = dm1.service();
    var cm8 = dm1.value();

    // not chaining
    var nm1 = dm1.info('foo');

    // multi-chaining
    var mcm1 = dm1.config().constant().controller();
})();
