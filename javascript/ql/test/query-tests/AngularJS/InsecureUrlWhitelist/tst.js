angular.module('myApp', [])
    .config(function($sceDelegateProvider) {
        $sceDelegateProvider.resourceUrlWhitelist([
            "**://example.com/*", // BAD (exploit: http://evil.com/?ignore=://example.org/a or javascript:alert(1);://example.org/a)
            "*://example.org/*", // BAD (exploit: javascript://example.org/a%0A%0Dalert(1) using a linebreak to end the comment starting with "//"!)
            "https://**.example.com/*", // BAD (exploit: https://evil.com/?ignore=://example.com/a)
            "https://example.**", // BAD (exploit: https://example.evil.com or http://example.:foo@evil.com)
            "https://example.*", // BAD (exploit: https://example.UnexpectedTLD)

            "https://example.com", // OK
            "https://example.com/**", // OK
            "https://example.com/*", // OK
            "https://example.com/foo/*", // OK
            "https://example.com/foo/**", // OK
            "https://example.com/foo/*/bar", // OK
            "https://example.com/foo/**/bar", // OK
            "https://example.com/?**", // OK
            "https://example.com/?**://example.com", // OK
            "https://*.example.com",

            // not flagged:
            /http:\/\/www.example.org/g // BAD (exploit http://wwwaexample.org (dots are not escaped))
        ]);
    });
