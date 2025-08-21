public class LocalClassInTestMethod {
    public void testNestedCase() {
        class OuterLocalClass {
            void func() {
                class NestedLocalClass {
                    void nestedMethod() {
                        System.exit(4);
                        Runtime.getRuntime().halt(5);
                    }
                }
            }
        }
        OuterLocalClass outer = new OuterLocalClass();
        outer.func();
    }
    public void testNestedCase2() {
        class OuterLocalClass {
            class NestedLocalClass {
                void nestedMethod() {
                    System.exit(4);
                    Runtime.getRuntime().halt(5);
                }
            }
        }
    }
}