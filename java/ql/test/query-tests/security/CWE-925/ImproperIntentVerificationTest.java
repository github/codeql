package test;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.Context;
import android.content.BroadcastReceiver;

class ImproperIntentVerificationTest {
    static void doStuff(Intent intent) {}

    class ShutdownBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context ctx, Intent intent) { // $hasResult
            doStuff(intent);
        }
    }

    class ShutdownBroadcastReceiverSafe extends BroadcastReceiver {
        @Override
        public void onReceive(Context ctx, Intent intent) {
            if (!intent.getAction().equals(Intent.ACTION_SHUTDOWN)) {
                return;
            }
            doStuff(intent);
        }
    }

    void test(Context c) {
        c.registerReceiver(new ShutdownBroadcastReceiver(), new IntentFilter(Intent.ACTION_SHUTDOWN));
        c.registerReceiver(new ShutdownBroadcastReceiverSafe(), new IntentFilter(Intent.ACTION_SHUTDOWN));
    }
}