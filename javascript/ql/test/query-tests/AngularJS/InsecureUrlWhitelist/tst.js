angular.module('myApp', [])
    .config(function($sceDelegateProvider) {
        $sceDelegateProvider.resourceUrlWhitelist([
            "**://example.com/*", // $ RelatedLocation - (exploit: http://evil.com/?ignore=://example.org/a or javascript:alert(1);://example.org/a)
            "*://example.org/*", // $ RelatedLocation - (exploit: javascript://example.org/a%0A%0Dalert(1) using a linebreak to end the comment starting with "//"!)
            "https://**.example.com/*", // $ RelatedLocation - exploit: https://evil.com/?ignore=://example.com/a
            "https://example.**", // $ RelatedLocation - exploit: https://example.evil.com or http://example.:foo@evil.com
            "https://example.*", // $ RelatedLocation - exploit: https://example.UnexpectedTLD

            "https://example.com",
            "https://example.com/**",
            "https://example.com/*",
            "https://example.com/foo/*",
            "https://example.com/foo/**",
            "https://example.com/foo/*/bar",
            "https://example.com/foo/**/bar",
            "https://example.com/?**",
            "https://example.com/?**://example.com",
            "https://*.example.com",

            // not flagged:
            /http:\/\/www.example.org/g // $ MISSING: RelatedLocation - (exploit http://wwwaexample.org (dots are not escaped))
        ]); // $ Alert
    });
