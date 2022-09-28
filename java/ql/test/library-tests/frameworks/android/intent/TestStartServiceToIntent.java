import android.app.Service;
import android.os.IBinder;
import android.content.Context;
import android.content.Intent;

public class TestStartServiceToIntent {

    static Object source() {
        return null;
    }

    static void sink(Object sink) {
    }

    public void test(Context ctx) {
        {
            Intent intent = new Intent(null, SomeService.class);
            intent.putExtra("data", (String) source());
            ctx.startService(intent);
        }

        {
            Intent intent = new Intent(null, SafeService.class);
            ctx.startService(intent);
        }
    }

    static class SomeService extends Service {

        @Override
        public void onStart(Intent intent, int startId) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
        }

        @Override
        public int onStartCommand(Intent intent, int flags, int startId) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
            return -1;
        }

        @Override
        public IBinder onBind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
            return null;
        }

        @Override
        public boolean onUnbind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
            return false;
        }

        @Override
        public void onRebind(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
        }

        @Override
        public void onTaskRemoved(Intent intent) {
            sink(intent.getStringExtra("data")); // $ hasValueFlow
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
