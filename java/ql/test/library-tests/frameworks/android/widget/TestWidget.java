import android.widget.EditText;

public class TestWidget {

    private void sink(Object sink) {}

    public void test(EditText t) {
        sink(t.getText().toString()); // $ hasTaintFlow
    }
}

