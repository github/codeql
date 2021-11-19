package com.example.myapp;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentTransaction;

public class MainActivity extends FragmentActivity {

    @Override
    public void onCreate(Bundle savedInstance) {
        try {
            super.onCreate(savedInstance);
            final String fname = getIntent().getStringExtra("fname");
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            Class<Fragment> fClass = (Class<Fragment>) Class.forName(fname);
            ft.add(fClass.newInstance(), ""); // $ hasTaintFlow
            ft.add(0, Fragment.instantiate(this, fname), null); // $ hasTaintFlow
            ft.add(0, Fragment.instantiate(this, fname, null)); // $ hasTaintFlow
            ft.add(0, fClass, null, ""); // $ hasTaintFlow
            ft.add(0, fClass.newInstance(), ""); // $ hasTaintFlow
            ft.attach(fClass.newInstance()); // $ hasTaintFlow
            ft.replace(0, fClass, null); // $ hasTaintFlow
            ft.replace(0, fClass.newInstance()); // $ hasTaintFlow
            ft.replace(0, fClass, null, ""); // $ hasTaintFlow
            ft.replace(0, fClass.newInstance(), ""); // $ hasTaintFlow

            ft.add(Fragment.class.newInstance(), ""); // Safe
            ft.attach(Fragment.class.newInstance()); // Safe
            ft.replace(0, Fragment.class.newInstance(), ""); // Safe
        } catch (Exception e) {
        }
    }

}
