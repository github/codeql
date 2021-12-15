//correct:
//  only one protected base,
//  multiple interfaces ("pure virtual" classes), and
//  multiple private implementations
class C : protected Superclass,
          public InterfaceA, public InterfaceB,
          private ImplementationA, private ImplementationB
{
    //implementation
};

//wrong: multiple protected bases
class D : protected Superclass1, protected Superclass2,
          public Interface, private Implementation
{
    //implementation
};

