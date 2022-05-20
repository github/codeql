class A {
    // ...
    public final boolean equals(Object obj) {
        if (!(obj instanceof A)) {
        	return false;
        }
        A a = (A)obj;
        // ...further checks...
    }
    // ...
}