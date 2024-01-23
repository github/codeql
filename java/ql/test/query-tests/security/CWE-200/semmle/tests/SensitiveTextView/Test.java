package com.example.test;

import android.app.Activity;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.LinearLayout;
import android.view.View;
import android.text.InputType;

class Test extends Activity {
    void test(String password) {
        EditText test1 = findViewById(R.id.test1);
        test1.setText(password); // $sensitive-text
        test1.setHint(password); // $sensitive-text
        test1.append(password); // $sensitive-text
        test1.setText(R.string.password_prompt);

        TextView test2 = findViewById(R.id.test2);
        test2.setVisibility(View.INVISIBLE);
        test2.setText(password);

        EditText test3 = findViewById(R.id.test3);
        test3.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        test3.setText(password);

        LinearLayout test4 = findViewById(R.id.test4);
        TextView test5 = findViewById(R.id.test5);
        test4.setVisibility(View.INVISIBLE);
        test5.setText(password);
    }
}