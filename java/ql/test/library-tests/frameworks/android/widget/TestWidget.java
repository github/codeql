import android.widget.EditText;

public class TestWidget {

    private EditText source() {
        return null;
    }

    private void sink(Object sink) {}

    public void test() {
        sink(source().getText().toString()); // $ hasTaintFlow
    }
}

