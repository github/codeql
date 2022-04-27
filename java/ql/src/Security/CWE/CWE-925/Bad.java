...
IntentFilter filter = new IntentFilter(Intent.ACTION_SHUTDOWN);
BroadcastReceiver sReceiver = new ShutDownReceiver();
context.registerReceiver(sReceiver, filter);
...

public class ShutdownReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, final Intent intent) {
        mainActivity.saveLocalData();
        mainActivity.stopActivity();
    }
}