angular.module('myModule', [])
    .factory('factoryId', function() {})
    .service('serviceId', function() {})
    .value('valueId', 'value')
    .constant('constantId', 'constant')
    .provider('providerId', function(){})
    .config(function($provide){
        $provide.value('valueId2', 'value');
        $provide.provider('providerId2', function(){});
    })
;

angular.module('myModule2', [])
    .controller('c0', function(factoryId){}) // OK
    .controller('c1', function(serviceId){}) // OK
    .controller('c2', function(valueId){}) // OK
    .controller('c3', function(constantId){}) // OK
    .controller('c4', function(providerId){}) // OK
    .controller('c5', function($http){}) // OK
    .controller('c6', function($provider){}) // NOT OK
    .controller('c7', function($scope){}) // OK
    .controller('c8', function($compile){}) // OK
    .controller('c9', function(UNKNOWN){}) // OK
    .controller('c10', function(providerIdProvider){}) // NOT OK
    .controller('c11', function(providerIdProvider, UNKNOWN){}) // NOT OK, but only one error
    .controller('c12', function($provide){}) // OK (special case)
    .controller('c13', function(providerId2Provider){}) // NOT OK

    .factory('s0', function(factoryId){}) // OK
    .factory('s1', function(serviceId){}) // OK
    .factory('s2', function(valueId){}) // OK
    .factory('s3', function(constantId){}) // OK
    .factory('s4', function(providerId){}) // OK
    .factory('s5', function($http){}) // OK
    .factory('s6', function($provider){}) // NOT OK
    .factory('s7', function($scope){}) // NOT OK
    .factory('s8', function($compile){}) // OK
    .factory('s9', function(UNKNOWN){}) // OK
    .factory('s10', function(providerIdProvider){}) // NOT OK
    .factory('s11', function(providerIdProvider, UNKNOWN){}) // NOT OK, but only one error
    .factory('s12', function($provide){}) // OK (special case)
    .factory('s13', function(providerId2Provider){}) // NOT OK

    .run(function(factoryId){}) // OK
    .run(function(serviceId){}) // OK
    .run(function(valueId){}) // OK
    .run(function(constantId){}) // OK
    .run(function(providerId){}) // OK
    .run(function($http){}) // OK
    .run(function($provider){}) // NOT OK
    .run(function($scope){}) // NOT OK
    .run(function($compile){}) // OK
    .run(function(UNKNOWN){}) // OK
    .run(function(providerIdProvider){}) // NOT OK
    .run(function(providerIdProvider, UNKNOWN){}) // NOT OK, but only one error
    .run(function($provide){}) // OK (special case)
    .run(function(providerId2Provider){}) // NOT OK

    .config(function(factoryId){}) // NOT OK
    .config(function(serviceId){}) // NOT OK
    .config(function(valueId){}) // NOT OK
    .config(function(constantId){}) // OK
    .config(function(providerId){}) // NOT OK
    .config(function($http){}) // NOT OK
    .config(function($provider){}) // OK
    .config(function($scope){}) // NOT OK
    .config(function($compile){}) // OK
    .config(function(UNKNOWN){}) // OK
    .config(function(providerIdProvider){}) // OK
    .config(function(providerId, UNKNOWN){}) // NOT OK, but only one error
    .config(function($provide){}) // OK (special case)
    .config(function(valueId2){}) // NOT OK

    // service: same restrcitions as .factory
    .service('s14', function(factoryId){}) // OK
    .service('s15', function($provider){}) // NOT OK

;
