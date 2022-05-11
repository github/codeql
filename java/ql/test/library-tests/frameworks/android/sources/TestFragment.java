package com.example.app;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;

public class TestFragment extends Fragment {

    void sink(Object o) {}

    public void onCreate(Bundle savedInstance) {
        Intent implicitIntent = new Intent("SOME_ACTION");
        startActivityForResult(implicitIntent, 0);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        sink(requestCode); // safe
        sink(resultCode); // safe
        sink(data); // $ hasValueFlow
    }
}
