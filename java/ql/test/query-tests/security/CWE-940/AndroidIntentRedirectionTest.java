package com.example.app;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AndroidIntentRedirectionTest extends Activity {

    public void onCreate(Bundle savedInstanceState) {
        Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");

        if (intent.getComponent().getPackageName().equals("something")) {
            startActivity(intent); // Safe - sanitized
        } else {
            startActivity(intent); // $ hasAndroidIntentRedirection
        }
        if (intent.getComponent().getClassName().equals("something")) {
            startActivity(intent); // Safe - sanitized
        } else {
            startActivity(intent); // $ hasAndroidIntentRedirection
        }

        startActivity(getIntent()); // Safe - not an intent obtained from the Extras

        // @formatter:off
        startActivities(new Intent[] {intent}); // $ hasAndroidIntentRedirection
        startActivities(new Intent[] {intent}, null); // $ hasAndroidIntentRedirection
        startActivity(intent); // $ hasAndroidIntentRedirection
        startActivity(intent, null); // $ hasAndroidIntentRedirection
        startActivityAsUser(intent, null); // $ hasAndroidIntentRedirection
        startActivityAsUser(intent, null, null); // $ hasAndroidIntentRedirection
        startActivityAsCaller(intent, null, false, 0); // $ hasAndroidIntentRedirection
        startActivityForResult(intent, 0); // $ hasAndroidIntentRedirection
        startActivityForResult(intent, 0, null); // $ hasAndroidIntentRedirection
        startActivityForResult(null, intent, 0, null); // $ hasAndroidIntentRedirection
        startActivityForResultAsUser(intent, null, 0, null, null); // $ hasAndroidIntentRedirection
        startActivityForResultAsUser(intent, 0, null, null); // $ hasAndroidIntentRedirection
        startActivityForResultAsUser(intent, 0, null); // $ hasAndroidIntentRedirection
        startService(intent); // $ hasAndroidIntentRedirection
        startServiceAsUser(intent, null); // $ hasAndroidIntentRedirection
        sendBroadcast(intent); // $ hasAndroidIntentRedirection
        sendBroadcast(intent, null); // $ hasAndroidIntentRedirection
        sendBroadcast(intent, null, null); // $ hasAndroidIntentRedirection
        sendBroadcast(intent, null, 0); // $ hasAndroidIntentRedirection
        sendBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirection
        sendBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirection
        sendBroadcastAsUser(intent, null, null, null); // $ hasAndroidIntentRedirection
        sendBroadcastAsUser(intent, null, null, 0); // $ hasAndroidIntentRedirection
        sendBroadcastWithMultiplePermissions(intent, null); // $ hasAndroidIntentRedirection
        sendStickyBroadcast(intent); // $ hasAndroidIntentRedirection
        sendStickyBroadcastAsUser(intent, null); // $ hasAndroidIntentRedirection
        sendStickyBroadcastAsUser(intent, null, null); // $ hasAndroidIntentRedirection
        sendStickyOrderedBroadcast(intent, null, null, 0, null, null); // $ hasAndroidIntentRedirection
        sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null); // $ hasAndroidIntentRedirection
        // @formatter:on

        try {
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName((Context) null, (String) intent.getExtra("className"));
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName((String) intent.getExtra("packageName"), null);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName((String) intent.getExtra("packageName"),
                        (String) intent.getExtra("className"));
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClass(null, Class.forName((String) intent.getExtra("className")));
                // needs taint step for Class.forName
                startActivity(fwdIntent); // $ MISSING: $hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setPackage((String) intent.getExtra("packageName"));
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName((String) intent.getExtra("packageName"), null);
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName("", (String) intent.getExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName((Context) null, (String) intent.getExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = new ComponentName((Context) null,
                        Class.forName((String) intent.getExtra("className")));
                fwdIntent.setComponent(component);
                // needs taint step for Class.forName
                startActivity(fwdIntent); // $ MISSING: $hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        ComponentName.createRelative("", (String) intent.getExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        ComponentName.createRelative((String) intent.getExtra("packageName"), "");
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = ComponentName.createRelative((Context) null,
                        (String) intent.getExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ hasAndroidIntentRedirection
            }
        } catch (Exception e) {
        }
    }
}
