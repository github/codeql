func t1() {
    sink(source("t1")); // $ hasValueFlow=t1
}

func t2() {
    sink(source("t2.1") + "blah"); // $ hasTaintFlow=t2.1
    sink("blah" + source("t2.2")); // $ hasTaintFlow=t2.2
}

func t3() {
    sink((source("t3.1"), "safe").0); // $ hasValueFlow=t3.1
    sink((source("t3.2"), "safe").1); // no flow
    sink(("safe", source("t3.3")).0); // no flow
    sink(("safe", source("t3.4")).1); // $ hasValueFlow=t3.4
}
