Function.RegisterNamespace("Test");

[Fixture]
Test.test = function() {
    [Fixture]
    function inner(){
        [Fact]
        function inner2() {
            var expected="expected";
            var actual=expected;
            Assert.Equal(expected,actual);
        }
    }
};
