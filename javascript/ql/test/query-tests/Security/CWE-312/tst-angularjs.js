angular.module("app")
    .controller("controller", function($cacheFactory, $templateCache, $cookies){
        $cacheFactory.put("x", data1.password); // NOT OK
        $templateCache.put("x", data2.password); // NOT OK
        $cookies.put("x", data3.password); // NOT OK
        $cookies.putObject("x", data4.password); // NOT OK

        $cookies.other("x", data5.password); // OK
        other.put("x", data6.password); // OK
        $cookies.put(data7.password, "x"); // OK
    })
