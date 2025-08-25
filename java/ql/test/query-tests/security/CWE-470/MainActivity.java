package com.example.myapp;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentTransaction;

public class MainActivity extends FragmentActivity {

    @Override
    public void onCreate(Bundle savedInstance) {
        try {
            super.onCreate(savedInstance);
            final String fname = getIntent().getStringExtra("fname"); // $ Source
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            Class<Fragment> fClass = (Class<Fragment>) Class.forName(fname);
            ft.add(fClass.newInstance(), ""); // $ Alert
            ft.add(0, Fragment.instantiate(this, fname), null); // $ Alert
            ft.add(0, Fragment.instantiate(this, fname, null)); // $ Alert
            ft.add(0, fClass, null, ""); // $ Alert
            ft.add(0, fClass.newInstance(), ""); // $ Alert
            ft.attach(fClass.newInstance()); // $ Alert
            ft.replace(0, fClass, null); // $ Alert
            ft.replace(0, fClass.newInstance()); // $ Alert
            ft.replace(0, fClass, null, ""); // $ Alert
            ft.replace(0, fClass.newInstance(), ""); // $ Alert

            ft.add(Fragment.class.newInstance(), ""); // Safe
            ft.attach(Fragment.class.newInstance()); // Safe
            ft.replace(0, Fragment.class.newInstance(), ""); // Safe
        } catch (Exception e) {
        }
    }

}
