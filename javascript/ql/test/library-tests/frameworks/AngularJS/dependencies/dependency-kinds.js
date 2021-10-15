(function(){
    function explicitlyInjectedController(explicitlyInjectedControllerServiceA, explicitlyInjectedControllerServiceB) {
        // ...
    }
    explicitlyInjectedController.$inject = ['explicitlyInjectedControllerServiceA', 'explicitlyInjectedControllerServiceB'];

    angular.module('myModule', [])
        .run(['moduleRunService', function(moduleRunService) {
            // ...
        }])
        .config(['moduleConfigProvider', function(moduleConfigProvider) {
            // ...
        }])
        .factory('serviceId0', [function() {
            // ...
        }])
        .factory('serviceId1', ['someServiceService1', function(someServiceService1) {
            // ...
        }])
        .factory('serviceId2', ['someServiceService2a', 'someServiceService2b', function(someServiceService2a, someServiceService2b) {
            // ...
        }])
        .factory('serviceId3', function() {
            // ...
        })
        .factory('serviceId4', function(someServiceService4) {
            // ...
        })
        .factory('serviceId5', function(someServiceService5a, someServiceService5b) {
            // ...
        })
        .controller('controllerName', ['someControllerService', function(someControllerService) {
            // ...
        }])
        .directive('directiveName', ['someDirectiveService', function(someDirectiveService) {
            // ...
        }])
        .filter('filterName', ['someFilterService', function(someFilterService) {
            // ...
        }])
        .controller('explicitlyInjectedControllerName', explicitlyInjectedController)
        .component('componentName', {
            controller: ['componentControllerDependency', function(componentControllerDependency) {
                this.user = {name: 'world'};
            }]
        })
        .animation('animationName', ['someAnimationService', function(someAnimationService) {
            // ...
        }])
        .service('serviceId6', function(someServiceService6) {
            // ...
        })
        .decorator('decoratee', function(someDecorateeService) {
            // ...
        })
        .provider('providerId1', function(someProviderIdService1){
            this.$get = function alsoInjected(providerCreatedInjectableFunctinDependency1){
                // ..
            }
        })
        .config(function($provide) {
            $provide.service('serviceId7', function(someConfigServiceService7){})
            $provide.provider('providerId2', function(someProviderService2){
                this.$get = function alsoInjected(providerCreatedInjectableFunctinDependency2){
                    // ..
                }
            })
        })
    ;

    angular.module('myApp', [])
        .directive('myDirective',  function() {
            return {
                link: function linkFunction(scope, element, attrs) { // A scope is injected here, but this is not an injectable function
                    // ...
                },
                controller: function(linkControllerDependency){
                }
            };
        });

    angular.module('myApp', [])
        .config(function($controllerProvider) {
            $controllerProvider.register('controllerThroughProvider', function(controllerThroughProviderDependency){})
        })
        .config(function($filterProvider) {
            $filterProvider.register('filterThroughProvider', function(filterThroughProviderDependency){})
        })
        .config(function($compileProvider) {
            $compileProvider.directive('directiveThroughProvider', function(directiveThroughProviderDependency){})
        })
        .config(function($compileProvider) {
            $compileProvider.component('componentThroughProvider', function(componentThroughProviderDependency){})
        })
        .config(function($animateProvider) {
            $animateProvider.register('animationThroughProvider', function(animationThroughProviderDependency){})
        })
        .animation('animation', function(animationDependency){})
    ;

    // currently unsupported:
    angular.module('myApp', [])
        .factory(unknownString, function(serviceForFactoryWithUnknownName, $filterProvider, $compileProvider) {
            $filterProvider.register('myFilter', function(serviceForFilterProviderFilterInFactoryWithUnknownName){})
            $filterProvider.register('anotherUnknownString', function(serviceForFilterProviderFilterWithUnknownNameInFactoryWithUnknownName){}),
            $compileProvider.directive('myDirective', function(serviceForCompileProviderDirectiveInFactoryWithUnknownName){})
        })
    ;

    angular.module('myApp', [])
        .config(function($routeProvider) {
            $routeProvider
                .when('somePath', {
                    controller: function (routeControllerDependency) {
                    }
                });
        })
    ;

    angular.module('myModule', [])
        .run(['moduleRunService', function({foo, bar}) {
            // ...
        }])
})();
