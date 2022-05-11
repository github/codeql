package com.example.myapp;

import android.preference.PreferenceActivity;

public class UnexportedPreferenceActivity extends PreferenceActivity {

    @Override
    protected boolean isValidFragment(String fragmentName) { // Safe: not exported
        return true;
    }
}
