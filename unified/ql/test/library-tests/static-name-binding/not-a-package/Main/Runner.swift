func main() {
    Driver(); // $ access=Main.Driver
    Driver.Nested(); // $ access=Main.Driver access=Main.Driver.Nested
    UniqueToMain(); // $ access=UniqueToMain
    UniqueToMock(); // $ access=UniqueToMock
}

class MyDriver: Driver { // $ access=Main.Driver
    class B: Nested {} // $ access=Main.Driver.Nested
}
