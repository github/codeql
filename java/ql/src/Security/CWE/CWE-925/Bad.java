public class ShutdownReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, final Intent intent) {
        mainActivity.saveLocalData();
        mainActivity.stopActivity();
    }
}