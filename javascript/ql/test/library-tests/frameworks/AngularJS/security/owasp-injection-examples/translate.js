// Adapted from https://github.com/hakanson/ng-owasp
angular
    .module('app')
    .filter('trust', function($sce) {
        return function(input) {
            return $sce.trustAsHtml(input);
        };
    });

angular
    .module('app')
    .config(function ($translateProvider) {
        $translateProvider.translations('en', {
            GREETING: document.cookie,
            GREETINGX: '<b>Hello</b> {{name | uppercase}}'
        });
    });

angular
    .module('app')
    .controller('TranslateController', TranslateController);

function TranslateController() {
    var vm = this;
    vm.parameters = {name:document.cookie};
}
