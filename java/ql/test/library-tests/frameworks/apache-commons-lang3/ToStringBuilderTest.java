import org.apache.commons.lang3.builder.ToStringBuilder;

class ToStringBuilderTest {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {

        ToStringBuilder sb1 = new ToStringBuilder(null); sb1.append((Object)taint()); sink(sb1.toString()); // $hasTaintFlow
        ToStringBuilder sb2 = new ToStringBuilder(null); sb2.append(new Object[] { taint() }); sink(sb2.toString()); // $hasTaintFlow
        ToStringBuilder sb3 = new ToStringBuilder(null); sb3.append(taint(), true); sink(sb3.toString()); // $hasTaintFlow
        ToStringBuilder sb4 = new ToStringBuilder(null); sb4.append("fieldname", taint()); sink(sb4.toString()); // $hasTaintFlow
        ToStringBuilder sb5 = new ToStringBuilder(null); sb5.append("fieldname", new Object[] { taint() }); sink(sb5.toString()); // $hasTaintFlow
        ToStringBuilder sb6 = new ToStringBuilder(null); sb6.append("fieldname", new Object[] { taint() }, true); sink(sb6.toString()); // $hasTaintFlow
        // GOOD: this appends an Object using the Object.toString style, which does not expose fields or String content.
        ToStringBuilder sb7 = new ToStringBuilder(null); sb7.appendAsObjectToString(taint()); sink(sb7.toString());
        ToStringBuilder sb8 = new ToStringBuilder(null); sb8.appendSuper(taint()); sink(sb8.toString()); // $hasTaintFlow
        ToStringBuilder sb9 = new ToStringBuilder(null); sb9.appendToString(taint()); sink(sb9.toString()); // $hasTaintFlow
        ToStringBuilder sb10 = new ToStringBuilder(null); sb10.append((Object)taint()); sink(sb10.build()); // $hasTaintFlow
        ToStringBuilder sb11 = new ToStringBuilder(null); sb11.append((Object)taint()); sink(sb11.getStringBuffer().toString()); // $hasTaintFlow

        // Test fluent methods:
        ToStringBuilder fluentTest = new ToStringBuilder(null);
        sink(fluentTest.append("Harmless").append(taint()).append("Also harmless").toString()); // $hasTaintFlow

        ToStringBuilder fluentBackflowTest = new ToStringBuilder(null);
        fluentBackflowTest.append("Harmless").append(taint()).append("Also harmless");
        sink(fluentBackflowTest.toString()); // $hasTaintFlow

        // Test the case where the fluent method contributing taint is at the end of a statement:
        ToStringBuilder fluentBackflowTest2 = new ToStringBuilder(null);
        fluentBackflowTest2.append("Harmless").append(taint());
        sink(fluentBackflowTest2.toString()); // $hasTaintFlow

    }
}