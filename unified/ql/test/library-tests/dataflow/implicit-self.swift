class Box {
    var x: String = ""
}

class C {
    var x: String = ""
    var box = Box()

    func t1() {
        self.x = source("t1.1");
        sink(self.x); // $ hasValueFlow=t1.1
    }

    func t2() {
        x = source("t2.1");
        sink(x); // $ hasValueFlow=t2.1
    }

    func t3() {
        x = source("t3.1");
        sink(self.x); // $ hasValueFlow=t3.1
    }

    func t4() {
        self.x = source("t4.1");
        sink(x); // $ hasValueFlow=t4.1
    }

    func t5() {
        self.box.x = source("t5.1");
        sink(self.box.x); // $ hasValueFlow=t5.1
    }

    func t6() {
        box.x = source("t6.1");
        sink(box.x); // $ hasValueFlow=t6.1
    }

    func t7() {
        box.x = source("t7.1");
        sink(self.box.x); // $ hasValueFlow=t7.1
    }

    func t8() {
        self.box.x = source("t8.1");
        sink(box.x); // $ hasValueFlow=t8.1
    }
}
