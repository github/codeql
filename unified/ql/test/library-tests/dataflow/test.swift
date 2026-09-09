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

func t4() {
    let a = source("t4.1");
    sink(a); // $ hasValueFlow=t4.1
}

func t5() {
    let (a, b) = (source("t5.1"), "safe");
    sink(a); // $ hasValueFlow=t5.1
    sink(b); // no flow

    let (c, d) = ("safe", source("t5.2"));
    sink(c); // no flow
    sink(d); // $ hasValueFlow=t5.2
}

func t6() {
    var a = source("t6.1");
    sink(a); // $ hasValueFlow=t6.1
    a = "safe";
    sink(a); // $ SPURIOUS: hasValueFlow=t6.1
}

func t7() {
    var tuple = ("safe", "safe")
    tuple.0 = source("t7.1");
    sink(tuple.0); // $ hasValueFlow=t7.1
    sink(tuple.1); // no flow
}

func t8() {
    var deep_tuple = (("safe", "safe"), ("safe", "safe"))
    deep_tuple.1.0 = source("t8.1");
    sink(deep_tuple); // no flow
    sink(deep_tuple.0); // no flow
    sink(deep_tuple.1); // no flow
    sink(deep_tuple.0.1); // no flow
    sink(deep_tuple.1.0); // $ hasValueFlow=t8.1
    sink(deep_tuple.1.1); // no flow
}

func t9() {
    var tuple = ("safe", "safe")
    (tuple.1, _) = (source("t9.1"), source("t9.2"));
    sink(tuple.0); // no flow
    sink(tuple.1); // $ hasValueFlow=t9.1
}
