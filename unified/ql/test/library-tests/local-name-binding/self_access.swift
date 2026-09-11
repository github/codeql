class C {
    func t1() { // implicit-self=t1.self
        print(self) // $ access=t1.self
    }

    var instanceField = 123;

    func t2() { // implicit-self=t2.self
        print(instanceField) // $ access=instanceField implicit-qualifier=t2.self
    }

    func t3() { // implicit-self=t3.self
        foo(123) { [self] in // name=closure.self
            print(self) // $ access=closure.self
            print(instanceField) // $ access=instanceField implicit-qualifier=closure.self
        }
    }

    func t4() { // implicit-self=t4.self
        foo(123) { [weak self] in // name=weak.self
            // Here, 'self' is an Option<C> referring to .some(<outer self>) if it
            // has not been GC'ed yet. Swift does not allow unqualified self access here.

            print(self) // $ access=weak.self

            // Unwrap the 'self' optional to get a strong reference.
            guard let self else { return } // $ access=weak.self // name=guarded.self

            print(self) // $ access=guarded.self
            print(instanceField) // $ access=instanceField implicit-qualifier=guarded.self
        }
    }
}
