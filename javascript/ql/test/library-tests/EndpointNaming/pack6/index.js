class C {
    instanceMethod() {} // $ method=(pack6).instanceMethod
    static staticMethod() {} // not accessible
} // $ instance=(pack6)

export default new C();
