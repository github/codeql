angular.module("app")
    .controller("controller", function($cacheFactory, $templateCache, $cookies){
        $cacheFactory.put("x", data1.password); // $ Alert[js/clear-text-storage-of-sensitive-data]
        $templateCache.put("x", data2.password); // $ Alert[js/clear-text-storage-of-sensitive-data]
        $cookies.put("x", data3.password); // $ Alert[js/clear-text-storage-of-sensitive-data]
        $cookies.putObject("x", data4.password); // $ Alert[js/clear-text-storage-of-sensitive-data]

        $cookies.other("x", data5.password);
        other.put("x", data6.password);
        $cookies.put(data7.password, "x");
    })
