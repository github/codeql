package test;
import android.content.Intent;
import android.content.Context;
import android.content.BroadcastReceiver;

class BootReceiverXml extends BroadcastReceiver {
    void doStuff(Intent intent) {}

    @Override
    public void onReceive(Context ctx, Intent intent) { // $ Alert
        doStuff(intent);
    }
}
