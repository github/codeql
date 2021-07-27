package com.example.app;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AndroidIntentRedirectTest extends Activity {
    AndroidIntentRedirectTest(Context base) {
        super(base);
    }

    public void onCreate(Bundle savedInstanceState) {
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            startActivities(new Intent[] {intent}); // $ hasAndroidIntentRedirect
            startActivities(new Intent[] {intent}, null); // $ hasAndroidIntentRedirect
            startActivity(intent); // $ hasAndroidIntentRedirect
            startActivity(intent, null); // $ hasAndroidIntentRedirect
            startActivityAsUser(intent, null); // $ hasAndroidIntentRedirect
            startActivityAsUser(intent, null, null); // $ hasAndroidIntentRedirect
            startActivityAsCaller(intent, null, false, 0); // $ hasAndroidIntentRedirect
            startActivityAsUserFromFragment(null, intent, 0, null, null); // $ hasAndroidIntentRedirect
            startActivityForResult(intent, 0); // $ hasAndroidIntentRedirect
            startActivityForResult(intent, 0, null); // $ hasAndroidIntentRedirect
            startActivityForResult(null, intent, 0, null); // $ hasAndroidIntentRedirect
            startActivityForResultAsUser(intent, null, 0, null, null); // $ hasAndroidIntentRedirect
            startActivityForResultAsUser(intent, 0, null, null); // $ hasAndroidIntentRedirect
            startActivityForResultAsUser(intent, 0, null); // $ hasAndroidIntentRedirect
        }
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            startService(intent); // $ hasAndroidIntentRedirect
            startServiceAsUser(intent, null); // $ hasAndroidIntentRedirect
        }
        {
            Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");
            sendBroadcast(intent); // $ hasAndroidIntentRedirect
            sendBroadcast(intent, null); // $ hasAndroidIntentRedirect
            sendBroadcast(intent, null, null); // $ hasAndroidIntentRedirect
            sendBroadcast(intent, null, 0); // $ hasAndroidIntentRedirect
            sendBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirect
            sendBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirect
            sendBroadcastAsUser(intent, null, null, null); // $ hasAndroidIntentRedirect
            sendBroadcastAsUser(intent, null, null, 0); // $ hasAndroidIntentRedirect
            sendBroadcastAsUserMultiplePermissions(intent, null, null); // $ hasAndroidIntentRedirect
            sendStickyBroadcast(intent); // $ hasAndroidIntentRedirect
            sendStickyBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirect
            sendStickyBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirect
            sendStickyOrderedBroadcast(intent, null, null, 0, null, null); // $ hasAndroidIntentRedirect
            sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null); // $ hasAndroidIntentRedirect
        }

    }
}
