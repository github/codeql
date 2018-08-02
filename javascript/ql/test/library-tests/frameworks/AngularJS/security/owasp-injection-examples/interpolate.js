// Adapted from https://github.com/hakanson/ng-owasp
angular
    .module('app')
    .controller('InterpolateController', InterpolateController);

function InterpolateController($interpolate, $sce) {
    var vm = this, i;

    vm.twitter = "hakanson";
    vm.template = document.cookie;
    vm.rendered = "";

    var context = { twitter : vm.twitter};
    i = $interpolate(vm.template);
    vm.renderedUntrusted = i(context);
    vm.renderedTrusted = $sce.trustAsHtml(vm.renderedUntrusted);
}
