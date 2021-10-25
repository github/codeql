Function.RegisterNamespace("Test");

[Fixture]
Test.ExampleTest = function() {
    [Fixture]
    function inner() {
        [Fact]
        function inner2(){
            var expected="expected";
            var actual=expected;
            Assert.Equal(expected,actual);
        }
    }
};

[Import("../../Source/xUnit.js/Assert.js")]
[Fixture]
Test.xUnit.js.Assert = function() {

//    [...]

};

[Fixture]
Test.ExampleTest2 = function() {
    var response = null;
    [ImportJson("../../Source/xUnit.js/Assert.js",function(path,result){
        response=result;
    })]
    [Fact]
    function f(){
//        [...]
    }
};
