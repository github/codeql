package com.example.app;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AndroidIntentRedirectionTest extends Activity {
    AndroidIntentRedirectionTest(Context base) {
        super(base);
    }

    public void onCreate(Bundle savedInstanceState) {
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            startActivities(new Intent[] {intent}); // $ hasAndroidIntentRedirection
            startActivities(new Intent[] {intent}, null); // $ hasAndroidIntentRedirection
            startActivity(intent); // $ hasAndroidIntentRedirection
            startActivity(intent, null); // $ hasAndroidIntentRedirection
            startActivityAsUser(intent, null); // $ hasAndroidIntentRedirection
            startActivityAsUser(intent, null, null); // $ hasAndroidIntentRedirection
            startActivityAsCaller(intent, null, false, 0); // $ hasAndroidIntentRedirection
            startActivityAsUserFromFragment(null, intent, 0, null, null); // $ hasAndroidIntentRedirection
            startActivityForResult(intent, 0); // $ hasAndroidIntentRedirection
            startActivityForResult(intent, 0, null); // $ hasAndroidIntentRedirection
            startActivityForResult(null, intent, 0, null); // $ hasAndroidIntentRedirection
            startActivityForResultAsUser(intent, null, 0, null, null); // $ hasAndroidIntentRedirection
            startActivityForResultAsUser(intent, 0, null, null); // $ hasAndroidIntentRedirection
            startActivityForResultAsUser(intent, 0, null); // $ hasAndroidIntentRedirection
        }
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            startService(intent); // $ hasAndroidIntentRedirection
            startServiceAsUser(intent, null); // $ hasAndroidIntentRedirection
        }
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            sendBroadcast(intent); // $ hasAndroidIntentRedirection
            sendBroadcast(intent, null); // $ hasAndroidIntentRedirection
            sendBroadcast(intent, null, null); // $ hasAndroidIntentRedirection
            sendBroadcast(intent, null, 0); // $ hasAndroidIntentRedirection
            sendBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirection
            sendBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirection
            sendBroadcastAsUser(intent, null, null, null); // $ hasAndroidIntentRedirection
            sendBroadcastAsUser(intent, null, null, 0); // $ hasAndroidIntentRedirection
            sendBroadcastAsUserMultiplePermissions(intent, null, null); // $ hasAndroidIntentRedirection
            sendStickyBroadcast(intent); // $ hasAndroidIntentRedirection
            sendStickyBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirection
            sendStickyBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirection
            sendStickyOrderedBroadcast(intent, null, null, 0, null, null); // $ hasAndroidIntentRedirection
            sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null); // $ hasAndroidIntentRedirection
        }

    }
}
