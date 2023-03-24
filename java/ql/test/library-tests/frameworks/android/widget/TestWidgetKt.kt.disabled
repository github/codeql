 import android.text.Editable

 class TestWidgetKt {

    fun source() : Editable? { return null }
    fun sink(sink : String) {}

    fun test() {
        val t = source()
        sink(t.toString()); // $ hasTaintFlow

        val t2 : Any? = source()
        sink(t2.toString()); // $ MISSING: hasTaintFlow
    }
}

