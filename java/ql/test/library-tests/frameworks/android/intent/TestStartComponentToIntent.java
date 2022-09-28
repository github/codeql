import android.app.Activity;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class TestStartComponentToIntent {

    static Object source() {
        return null;
    }

    static void sink(Object sink) {
    }

    public void testActivity(Context ctx) {
        Intent intent = new Intent(null, SomeActivity.class);
        intent.putExtra("data", (String) source());
        ctx.startActivity(intent);
    }

    static class SomeActivity extends Activity {

        public void testActivity() {
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow
        }
    }

    // ! WIP
    public void testService(Context ctx) {
        Intent intent = new Intent(null, SomeService.class);
        intent.putExtra("data", (String) source());
        ctx.startService(intent);
    }

    public void testBroadcastReceiver(Context ctx) {
        Intent intent = new Intent(null, SomeBroadcastReceiver.class);
        intent.putExtra("data", (String) source());
        ctx.sendBroadcast(intent);
    }

    static class SomeService extends Service {

        public void test() {
            // ! WIP
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow
        }
    }

    static class SomeBroadcastReceiver extends BroadcastReceiver {

        public void test() {
            // ! WIP
            sink(getIntent().getStringExtra("data")); // $ hasValueFlow
        }
    }
}
