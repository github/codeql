(function(){
    angular.module('myModule', [])
        .factory('factory', function constructor() {
            return 'constructed'
        })
        .service('service', function service () {})
        .decorator('decorator', function decorator(){})
        .value('value', 'value')
        .constant('constant', 'constant')
        .provider('provider', function(){
            this.$get = 'provided'
        })
    ;
    angular.module('myOtherModule', [])
        .run(function(factory, service, decorator, value, constant){})
        .config(function(provider){})
})();
