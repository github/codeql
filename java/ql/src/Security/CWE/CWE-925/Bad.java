public class ShutdownReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, final Intent intent) {
        // BAD: The code does not check if the intent is an ACTION_SHUTDOWN intent
        mainActivity.saveLocalData();
        mainActivity.stopActivity();
    }
}