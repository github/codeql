angular.module('myApp', [])
    .directive('myCustomer', function() {
        return {
            templateUrl: "SAFE"
        }
    })
    .directive('myCustomer', function() {
        return {
            templateUrl: Cookie.get("unsafe") // $ Alert
        }
    });

addEventListener('message', (ev) => { // $ Source
    Cookie.set("unsafe", ev.data);
});
