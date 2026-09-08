func t1() {
    sink(source("t1")); // $ hasValueFlow=t1
}

func t2() {
    sink(source("t2.1") + "blah"); // $ hasTaintFlow=t2.1
    sink("blah" + source("t2.2")); // $ hasTaintFlow=t2.2
}
