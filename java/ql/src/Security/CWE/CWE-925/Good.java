public class ShutdownReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, final Intent intent) {
        if (!intent.getAction().equals(Intent.ACTION_SHUTDOWN)) {
            return;
        }
        mainActivity.saveLocalData();
        mainActivity.stopActivity();
    }
}