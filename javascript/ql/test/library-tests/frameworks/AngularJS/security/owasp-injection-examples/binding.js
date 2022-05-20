// Adapted from https://github.com/hakanson/ng-owasp
angular
    .module('app')
    .controller('BindingController', BindingController);

function BindingController($sanitize, $sce) {
    var vm = this;

    var data = document.cookie;

    vm.untrusted = data;
    vm.sanitized = $sanitize(data);
    vm.trusted = $sce.trustAsHtml(data);
}
