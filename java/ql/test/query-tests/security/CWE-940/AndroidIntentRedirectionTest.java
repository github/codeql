package com.example.app;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class AndroidIntentRedirectionTest extends Activity {

    public void onCreate(Bundle savedInstanceState) {
        Intent intent = (Intent) getIntent().getParcelableExtra("forward_intent");

        // @formatter:off
        startActivities(new Intent[] {intent}); // $ BAD
        startActivities(new Intent[] {intent}, null); // $ BAD
        startActivity(intent); // $ BAD
        startActivity(intent, null); // $ BAD
        startActivityAsUser(intent, null); // $ BAD
        startActivityAsCaller(intent, null, false, 0); // $ BAD
        startActivityForResult(intent, 0); // $ BAD
        startActivityForResult(intent, 0, null); // $ BAD
        startActivityForResult(null, intent, 0, null); // $ BAD
        startActivityForResultAsUser(intent, null, 0, null, null); // $ BAD
        startActivityForResultAsUser(intent, 0, null, null); // $ BAD
        startActivityForResultAsUser(intent, 0, null); // $ BAD
        bindService(intent, null, 0);
        bindServiceAsUser(intent, null, 0, null);
        startService(intent); // $ BAD
        startServiceAsUser(intent, null); // $ BAD
        startForegroundService(intent); // $ BAD
        sendBroadcast(intent); // $ BAD
        sendBroadcast(intent, null); // $ BAD
        sendBroadcastAsUser(intent, null); // $ BAD
        sendBroadcastAsUser(intent, null, null); // $ BAD
        sendBroadcastWithMultiplePermissions(intent, null); // $ BAD
        sendStickyBroadcast(intent); // $ BAD
        sendStickyBroadcastAsUser(intent, null); // $ BAD
        sendStickyOrderedBroadcast(intent, null, null, 0, null, null); // $ BAD
        sendStickyOrderedBroadcastAsUser(intent, null, null, null, 0, null, null); // $ BAD
        // @formatter:on

        // Sanitizing only the package or the class still allows redirecting
        // to non-exported activities in the same package
        // or activities with the same name in other packages, respectively.
        if (intent.getComponent().getPackageName().equals("something")) {
            startActivity(intent); // $ BAD
        } else {
            startActivity(intent); // $ BAD
        }
        if (intent.getComponent().getClassName().equals("something")) {
            startActivity(intent); // $ BAD
        } else {
            startActivity(intent); // $ BAD
        }

        if (intent.getComponent().getPackageName().equals("something")
                && intent.getComponent().getClassName().equals("something")) {
            startActivity(intent); // Safe
        } else {
            startActivity(intent); // $ BAD
        }

        try {
            {
                // Delayed cast
                Object obj = getIntent().getParcelableExtra("forward_intent");
                Intent fwdIntent = (Intent) obj;
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName((Context) null, intent.getStringExtra("className"));
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName(intent.getStringExtra("packageName"), null);
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                fwdIntent.setClassName(intent.getStringExtra("packageName"),
                        intent.getStringExtra("className"));
                startActivity(fwdIntent); // $ BAD
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
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName(intent.getStringExtra("packageName"), null);
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = new ComponentName("", intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        new ComponentName((Context) null, intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ BAD
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
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component =
                        ComponentName.createRelative(intent.getStringExtra("packageName"), "");
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = new Intent();
                ComponentName component = ComponentName.createRelative((Context) null,
                        intent.getStringExtra("className"));
                fwdIntent.setComponent(component);
                startActivity(fwdIntent); // $ BAD
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
                Intent originalIntent = getIntent();
                Intent fwdIntent = (Intent) originalIntent.getParcelableExtra("forward_intent");
                if (originalIntent.getBooleanExtra("use_fwd_intent", false)) {
                    startActivity(fwdIntent); // $ BAD
                } else {
                    startActivity(originalIntent); // Safe - not an Intent obtained from the Extras
                }
            }
            {
                Intent originalIntent = getIntent();
                originalIntent.setClassName(originalIntent.getStringExtra("package_name"),
                        originalIntent.getStringExtra("class_name"));
                startActivity(originalIntent); // $ BAD
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
                Intent fwdIntent = Intent.parseUri(getIntent().getStringExtra("uri"), 0);
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = Intent.getIntent(getIntent().getStringExtra("uri"));
                startActivity(fwdIntent); // $ BAD
            }
            {
                Intent fwdIntent = Intent.getIntentOld(getIntent().getStringExtra("uri"));
                startActivity(fwdIntent); // $ BAD
            }
        } catch (Exception e) {
        }
    }
}
