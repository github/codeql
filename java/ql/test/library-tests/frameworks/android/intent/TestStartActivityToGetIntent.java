import android.app.Activity;
import android.content.Context;
import android.content.Intent;

public class TestStartActivityToGetIntent {

    static Object source() {
        return null;
    }

    static void sink(Object sink) {}

    public void test(Context ctx) {
        Intent intent = new Intent(null, SomeActivity.class);
        intent.putExtra("data", (String) source());
        ctx.startActivity(intent);
    }

    static class SomeActivity extends Activity {

        public void test() {
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow
        }
    }
}
