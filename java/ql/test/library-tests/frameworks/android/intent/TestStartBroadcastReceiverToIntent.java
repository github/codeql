import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class TestStartBroadcastReceiverToIntent {

    static Object source() {
        return null;
    }

    static void sink(Object sink) {
    }

    public void test(Context ctx) {
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source());
            ctx.sendBroadcast(intent);
        }

        {
            Intent intent = new Intent(null, SafeBroadcastReceiver.class);
            ctx.sendBroadcast(intent);
        }
    }

    static class SomeBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
        }
    }

    static class SafeBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
        }
    }
}
