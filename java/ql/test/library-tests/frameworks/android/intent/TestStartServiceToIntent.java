import android.app.Service;
import android.os.IBinder;
import android.content.Context;
import android.content.Intent;

public class TestStartServiceToIntent {

    static Object source(String kind) {
        return null;
    }

    static void sink(Object sink) {}

    public void test(Context ctx) {

        // test all methods that start a service
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source("bind"));
            ctx.bindService(intent, null, 0);
        }
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source("bind-as-user"));
            ctx.bindServiceAsUser(intent, null, 0, null);
        }
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source("bind-isolated"));
            ctx.bindIsolatedService(intent, 0, null, null, null);
        }
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source("start"));
            ctx.startService(intent);
        }
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source("start-foreground"));
            ctx.startForegroundService(intent);
        }

        // test 4-arg Intent constructor
        {
            Intent intent = new Intent(null, null, null, SomeService.class);
            intent.putExtra("data", (String) source("4-arg"));
            ctx.startService(intent);
        }

        // safe test
        {
            Intent intent = new Intent(null, SafeService.class);
            intent.putExtra("data", "safe");
            ctx.startService(intent);
        }
    }

    static class SomeService extends Service {

        // test methods that receive an Intent as a parameter
        @Override
        public void onStart(Intent intent, int startId) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
        }

        @Override
        public int onStartCommand(Intent intent, int flags, int startId) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
            return -1;
        }

        @Override
        public IBinder onBind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
            return null;
        }

        @Override
        public boolean onUnbind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
            return false;
        }

        @Override
        public void onRebind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
        }

        @Override
        public void onTaskRemoved(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow=bind hasValueFlow=bind-as-user hasValueFlow=bind-isolated hasValueFlow=start hasValueFlow=start-foreground hasValueFlow=4-arg
        }
    }

    static class SafeService extends Service {

        @Override
        public void onStart(Intent intent, int startId) {
            sink(intent.getStringExtra("data")); // Safe
        }

        @Override
        public int onStartCommand(Intent intent, int flags, int startId) {
            sink(intent.getStringExtra("data")); // Safe
            return -1;
        }

        @Override
        public IBinder onBind(Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
            return null;
        }

        @Override
        public boolean onUnbind(Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
            return false;
        }

        @Override
        public void onRebind(Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
        }

        @Override
        public void onTaskRemoved(Intent intent) {
            sink(intent.getStringExtra("data")); // Safe
        }
    }
}
