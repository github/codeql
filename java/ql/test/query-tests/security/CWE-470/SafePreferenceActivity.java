package com.example.myapp;

import android.preference.PreferenceActivity;

public class SafePreferenceActivity extends PreferenceActivity {

    @Override
    protected boolean isValidFragment(String fragmentName) { // Safe: not all paths return true
        return fragmentName.equals("MySafeFragment") || fragmentName.equals("MySafeFragment2");
    }
}
