package com.example.test;
import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import android.view.View;
import android.text.InputType;

class Test extends Activity {
    public void onCreate(Bundle b) {
        EditText test7pw = findViewById(R.id.test7_password);
        test7pw.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);

        EditText test8pw = requireViewById(R.id.test8_password);
        test8pw.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
    }
}