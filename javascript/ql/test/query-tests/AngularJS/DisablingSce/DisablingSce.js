angular.module('app', [])
    .config(function($sceProvider) {
        $sceProvider.enabled(false); // BAD
    })
    .config(['otherProvider', function($sceProvider) {
        $sceProvider.enabled(false); // OK
    }])
    .config(['$sceProvider', function(x) {
        x.enabled(false); // BAD
    }])
    .config(function($sceProvider) {
        $sceProvider.enabled(true); // OK
    })
    .config(function($sceProvider) {
        var x = false;
        $sceProvider.enabled(x); // BAD
    });
