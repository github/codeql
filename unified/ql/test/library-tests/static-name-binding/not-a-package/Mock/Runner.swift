func main() {
    Driver(); // $ access=Mock.Driver
    Driver.Nested(); // $ access=Mock.Driver access=Mock.Driver.Nested
    UniqueToMain(); // $ access=UniqueToMain
    UniqueToMock(); // $ access=UniqueToMock
}

class MyDriver: Driver { // $ access=Mock.Driver
    class B: Nested {} // $ access=Mock.Driver.Nested
}
