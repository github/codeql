angular.module('app', [])
    .config(function($sceProvider) {
        $sceProvider.enabled(false); // $ Alert
    })
    .config(['otherProvider', function($sceProvider) {
        $sceProvider.enabled(false);
    }])
    .config(['$sceProvider', function(x) {
        x.enabled(false); // $ Alert
    }])
    .config(function($sceProvider) {
        $sceProvider.enabled(true);
    })
    .config(function($sceProvider) {
        var x = false;
        $sceProvider.enabled(x); // $ Alert
    });
