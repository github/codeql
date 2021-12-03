angular.module('myApp', [])
    .config(function($sceDelegateProvider) {
        $sceDelegateProvider.resourceUrlWhitelist([
            "*://example.org/*", // BAD
            "https://**.example.com/*", // BAD
            "https://example.**", // BAD
            "https://example.*" // BAD
        ]);
    });
