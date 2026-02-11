package com.example.app;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AndroidIntentRedirectionTest extends Activity {

    public void onCreate(Bundle savedInstanceState) {
        Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent"); // $ Source=intent

        // @formatter:off
        startActivities(new Intent[] {intent}); // $ Alert=intent
        startActivities(new Intent[] {intent}, null); // $ Alert=intent
        startActivity(intent); // $ Alert=intent
        startActivity(intent, null); // $ Alert=intent
        startActivityAsUser(intent, null); // $ Alert=intent
        startActivityAsCaller(intent, null, false, 0); // $ Alert=intent
        startActivityForResult(intent, 0); // $ Alert=intent
        startActivityForResult(intent, 0, null); // $ Alert=intent
        startActivityForResult(null, intent, 0, null); // $ Alert=intent
        startActivityForResultAsUser(intent, null, 0, null, null); // $ Alert=intent
        startActivityForResultAsUser(intent, 0, null, null); // $ Alert=intent
        startActivityForResultAsUser(intent, 0, null); // $ Alert=intent
        bindService(intent, null, 0);
        bindServiceAsUser(intent, null, 0, null);
        startService(intent); // $ Alert=intent
        startServiceAsUser(intent, null); // $ Alert=intent
        startForegroundService(intent); // $ Alert=intent
        sendBroadcast(intent); // $ Alert=intent
        sendBroadcast(intent, null); // $ Alert=intent
        sendBroadcastAsUser(intent, null); // $ Alert=intent
        sendBroadcastAsUser(intent, null, null); // $ Alert=intent
        sendBroadcastWithMultiplePermissions(intent, null); // $ Alert=intent
        sendStickyBroadcast(intent); // $ Alert=intent
        sendStickyBroadcastAsUser(intent, null); // $ Alert=intent
        sendStickyOrderedBroadcast(intent, null, null, 0, null, null); // $ Alert=intent
        sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null); // $ Alert=intent
        // @formatter:on

        // Sanitizing only the package or the class still allows redirecting
        // to non-exported activities in the same package
        // or activities with the same name in other packages, respectively.
        if (intent.getComponent().getPackageName().equals("something")) {
            startActivity(intent); // $ Alert=intent
        } else {
            startActivity(intent); // $ Alert=intent
        }
        if (intent.getComponent().getClassName().equals("something")) {
            startActivity(intent); // $ Alert=intent
        } else {
            startActivity(intent); // $ Alert=intent
        }

        if (intent.getComponent().getPackageName().equals("something")
                && intent.getComponent().getClassName().equals("something")) {
            startActivity(intent); // Safe
        } else {
            startActivity(intent); // $ Alert=intent
        }

        try {
            {
                // Delayed cast
                Object obj = getIntent().getParcelableExtra("forward_intent"); // $ Source=intent2
                Intent fwdIntent = (Intent) obj;
                startActivity(fwdIntent); // $ Alert=intent2
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName((Context) null, intent.getStringExtra("className"));
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName(intent.getStringExtra("packageName"), null);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName(intent.getStringExtra("packageName"),
                        intent.getStringExtra("className"));
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClass(null, Class.forName(intent.getStringExtra("className")));
                // needs taint step for Class.forName
                startActivity(fwdIntent); // $ MISSING: $hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setPackage(intent.getStringExtra("packageName"));
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName(intent.getStringExtra("packageName"), null);
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = new ComponentName("", intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName((Context) null, intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = new ComponentName((Context) null,
                        Class.forName(intent.getStringExtra("className")));
                fwdIntent.setComponent(component);
                // needs taint step for Class.forName
                startActivity(fwdIntent); // $ MISSING: $hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        ComponentName.createRelative("", intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        ComponentName.createRelative(intent.getStringExtra("packageName"), "");
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = ComponentName.createRelative((Context) null,
                        intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ Alert=intent
            }
            {
                Intent originalIntent = getIntent();
                ComponentName cp = new ComponentName(originalIntent.getStringExtra("packageName"),
                        originalIntent.getStringExtra("className"));
                Intent anotherIntent = new Intent();
                anotherIntent.setComponent(cp);
                startActivity(originalIntent); // Safe - not a tainted Intent
            }
            {
                Intent originalIntent = getIntent();
                Intent anotherIntent = new Intent(originalIntent);
                startActivity(anotherIntent); // Safe - copy constructor from original Intent
            }
            {
                Intent originalIntent = getIntent(); // $ Source=intent3
                Intent fwdIntent = (Intent) originalIntent.getParcelableExtra("forward_intent");
                if (originalIntent.getBooleanExtra("use_fwd_intent", false)) {
                    startActivity(fwdIntent); // $ Alert=intent3
                } else {
                    startActivity(originalIntent); // Safe - not an Intent obtained from the Extras
                }
            }
            {
                Intent originalIntent = getIntent(); // $ Source=intent4
                originalIntent.setClassName(originalIntent.getStringExtra("package_name"),
                        originalIntent.getStringExtra("class_name"));
                startActivity(originalIntent); // $ Alert=intent4
            }
            {
                Intent originalIntent = getIntent();
                originalIntent.setClassName("not_user_provided", "not_user_provided");
                startActivity(originalIntent); // Safe - component changed but not tainted
            }
            {
                Intent originalIntent = getIntent();
                Intent fwdIntent;
                if (originalIntent.getBooleanExtra("use_fwd_intent", false)) {
                    fwdIntent = (Intent) originalIntent.getParcelableExtra("forward_intent");
                } else {
                    fwdIntent = originalIntent;
                }
                // Conditionally tainted sinks aren't supported currently
                startActivity(fwdIntent); // $ MISSING: $hasAndroidIntentRedirection
            }
            {
                Intent fwdIntent = Intent.parseUri(getIntent().getStringExtra("uri"), 0); // $ Source=intent5
                startActivity(fwdIntent); // $ Alert=intent5
            }
            {
                Intent fwdIntent = Intent.getIntent(getIntent().getStringExtra("uri")); // $ Source=intent6
                startActivity(fwdIntent); // $ Alert=intent6
            }
            {
                Intent fwdIntent = Intent.getIntentOld(getIntent().getStringExtra("uri")); // $ Source=intent7
                startActivity(fwdIntent); // $ Alert=intent7
            }
        } catch (Exception e) {
        }
    }
}
