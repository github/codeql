package com.example.myapp;

import android.preference.PreferenceActivity;

public class UnsafePreferenceActivity extends PreferenceActivity {

    @Override
    protected boolean isValidFragment(String fragmentName) { // $ hasPreferenceFragmentInjection
        return true;
    }
}
