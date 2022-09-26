import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class TestStartBroadcastReceiverToIntent {

    static Object source(String kind) {
        return null;
    }

    static void sink(Object sink) {}

    public void test(Context ctx) {

        // test all methods that send a broadcast
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send"));
            ctx.sendBroadcast(intent);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-as-user"));
            ctx.sendBroadcastAsUser(intent, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-with-perm"));
            ctx.sendBroadcastWithMultiplePermissions(intent, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-ordered"));
            ctx.sendOrderedBroadcast(intent, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-ordered-as-user"));
            ctx.sendOrderedBroadcastAsUser(intent, null, null, null, null, 0, null, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-sticky"));
            ctx.sendStickyBroadcast(intent);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-sticky-as-user"));
            ctx.sendStickyBroadcastAsUser(intent, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-sticky-ordered"));
            ctx.sendStickyOrderedBroadcast(intent, null, null, 0, null, null);
        }
        {
            Intent intent = new Intent(null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("send-sticky-ordered-as-user"));
            ctx.sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null);
        }

        // test 4-arg Intent constructor
        {
            Intent intent = new Intent(null, null, null, SomeBroadcastReceiver.class);
            intent.putExtra("data", (String) source("4-arg"));
            ctx.sendBroadcast(intent);
        }

        // safe test
        {
            Intent intent = new Intent(null, SafeBroadcastReceiver.class);
            intent.putExtra("data", "safe");
            ctx.sendBroadcast(intent);
        }
    }

    static class SomeBroadcastReceiver extends BroadcastReceiver {

        // test method that receives an Intent as a parameter
        @Override
        public void onReceive(Context context, Intent intent) {
            sink(intent.getStringExtra("data")); // $  hasValueFlow=send hasValueFlow=send-as-user hasValueFlow=send-with-perm hasValueFlow=send-ordered hasValueFlow=send-ordered-as-user hasValueFlow=send-sticky hasValueFlow=send-sticky-as-user hasValueFlow=send-sticky-ordered hasValueFlow=send-sticky-ordered-as-user hasValueFlow=4-arg
        }
    }

    static class SafeBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
        }
    }
}
