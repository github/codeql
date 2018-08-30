package annotations;

@Ann(key="value")
public class A {
}

// Sub inherits the Ann annotation from A
class Sub extends A {}

@Ann(key="IAnn")
interface I {}

// Sub2 inherits the Ann annotation from A, but not from I
class Sub2 extends Sub implements I {}

// Sub3 does not inherit any Ann annotations since it has its own
@Ann(key="Sub3Ann")
class Sub3 extends Sub2 {}