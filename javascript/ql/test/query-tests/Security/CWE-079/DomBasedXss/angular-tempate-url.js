angular.module('myApp', [])
    .directive('myCustomer', function() {
        return {
            templateUrl: "SAFE" // OK
        }
    })
    .directive('myCustomer', function() {
        return {
            templateUrl: Cookie.get("unsafe") // NOT OK
        }
    });

addEventListener('message', (ev) => {
    Cookie.set("unsafe", ev.data);
});
