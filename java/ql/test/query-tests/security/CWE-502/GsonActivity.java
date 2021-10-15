package com.example.app;

import android.app.Activity;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.Gson; 

public class GsonActivity extends Activity {
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(-1);

        ParcelableEntity entity = (ParcelableEntity) getIntent().getParcelableExtra("jsonEntity");
    }
}
