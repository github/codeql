public class EntryPointTypesTest {

    static class TestObject {
        public String field1;
        private String field2;
        private AnotherTestObject field3;

        public String getField2() {
            return field2;
        }

        public AnotherTestObject getField3() {
            return field3;
        }
    }

    static class AnotherTestObject {
        public String field4;
        private String field5;

        public String getField5() {
            return field5;
        }
    }

    static class ParameterizedTestObject<T, K> {
        public String field6;
        public T field7;
        private K field8;

        public K getField8() {
            return field8;
        }
    }

    private static void sink(String sink) {}

    public static void test(TestObject source) {
        sink(source.field1); // $hasTaintFlow
        sink(source.getField2()); // $hasTaintFlow
        sink(source.getField3().field4); // $hasTaintFlow
        sink(source.getField3().getField5()); // $hasTaintFlow
    }

    public static void testParameterized(
            ParameterizedTestObject<TestObject, AnotherTestObject> source) {
        sink(source.field6); // $hasTaintFlow
        sink(source.field7.field1); // $hasTaintFlow
        sink(source.field7.getField2()); // $hasTaintFlow
        sink(source.getField8().field4); // $hasTaintFlow
        sink(source.getField8().getField5()); // $hasTaintFlow
    }
}
