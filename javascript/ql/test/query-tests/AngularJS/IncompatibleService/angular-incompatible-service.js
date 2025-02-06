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
    .controller('c0', function(factoryId){})
    .controller('c1', function(serviceId){})
    .controller('c2', function(valueId){})
    .controller('c3', function(constantId){})
    .controller('c4', function(providerId){})
    .controller('c5', function($http){})
    .controller('c6', function($provider){}) // $ Alert
    .controller('c7', function($scope){})
    .controller('c8', function($compile){})
    .controller('c9', function(UNKNOWN){})
    .controller('c10', function(providerIdProvider){}) // $ Alert
    .controller('c11', function(providerIdProvider, UNKNOWN){}) // $ Alert - but only one error
    .controller('c12', function($provide){}) // OK - special case
    .controller('c13', function(providerId2Provider){}) // $ Alert

    .factory('s0', function(factoryId){})
    .factory('s1', function(serviceId){})
    .factory('s2', function(valueId){})
    .factory('s3', function(constantId){})
    .factory('s4', function(providerId){})
    .factory('s5', function($http){})
    .factory('s6', function($provider){}) // $ Alert
    .factory('s7', function($scope){}) // $ Alert
    .factory('s8', function($compile){})
    .factory('s9', function(UNKNOWN){})
    .factory('s10', function(providerIdProvider){}) // $ Alert
    .factory('s11', function(providerIdProvider, UNKNOWN){}) // $ Alert - but only one error
    .factory('s12', function($provide){}) // OK - special case
    .factory('s13', function(providerId2Provider){}) // $ Alert

    .run(function(factoryId){})
    .run(function(serviceId){})
    .run(function(valueId){})
    .run(function(constantId){})
    .run(function(providerId){})
    .run(function($http){})
    .run(function($provider){}) // $ Alert
    .run(function($scope){}) // $ Alert
    .run(function($compile){})
    .run(function(UNKNOWN){})
    .run(function(providerIdProvider){}) // $ Alert
    .run(function(providerIdProvider, UNKNOWN){}) // $ Alert - but only one error
    .run(function($provide){}) // OK - special case
    .run(function(providerId2Provider){}) // $ Alert

    .config(function(factoryId){}) // $ Alert
    .config(function(serviceId){}) // $ Alert
    .config(function(valueId){}) // $ Alert
    .config(function(constantId){})
    .config(function(providerId){}) // $ Alert
    .config(function($http){}) // $ Alert
    .config(function($provider){})
    .config(function($scope){}) // $ Alert
    .config(function($compile){})
    .config(function(UNKNOWN){})
    .config(function(providerIdProvider){})
    .config(function(providerId, UNKNOWN){}) // $ Alert - but only one error
    .config(function($provide){}) // OK - special case
    .config(function(valueId2){}) // $ Alert

    // service: same restrcitions as .factory
    .service('s14', function(factoryId){})
    .service('s15', function($provider){}) // $ Alert

;
