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
        // BAD: Exposing sensitive data to text view
        test1.setText(password); // $sensitive-text
        test1.setHint(password); // $sensitive-text
        test1.append(password); // $sensitive-text
        // GOOD: resource constant is not sensitive info
        test1.setText(R.string.password_prompt); 

        // GOOD: Visibility is dynamically set
        TextView test2 = findViewById(R.id.test2);
        test2.setVisibility(View.INVISIBLE);
        test2.setText(password);

        // GOOD: Input type is dynamically set
        EditText test3 = findViewById(R.id.test3);
        test3.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        test3.setText(password);

        // GOOD: Visibility of parent is dynamically set
        LinearLayout test4 = findViewById(R.id.test4);
        TextView test5 = findViewById(R.id.test5);
        test4.setVisibility(View.INVISIBLE);
        test5.setText(password);

        // GOOD: Input type set to textPassword in XML
        EditText test6 = findViewById(R.id.test6);
        test6.setText(password);

        // GOOD: Input type set to textWebPassword in XML
        EditText test7 = findViewById(R.id.test7);
        test7.setText(password);

        // GOOD: Input type set to numberPassword in XML
        EditText test8 = findViewById(R.id.test8);
        test8.setText(password);

        // BAD: Input type set to textVisiblePassword in XML, which is not hidden
        EditText test9 = findViewById(R.id.test9);
        test9.setText(password); // $sensitive-text

        // GOOD: Visibility set to invisible in XML
        EditText test10 = findViewById(R.id.test10);
        test10.setText(password);

        // GOOD: Visibility set to gone in XML
        EditText test11 = findViewById(R.id.test11);
        test11.setText(password);

        // GOOD: Visibility of parent set to invisible in XML
        EditText test12 = findViewById(R.id.test12);
        test12.setText(password);

        // GOOD: Input type set to textPassword in XML
        EditText test13 = findViewById(R.id.test13);
        test13.setText(password);

        test14 = findViewById(R.id.test14);
    }

    EditText test14;

    void test2(String password) {
        // GOOD: Input type set to textPassword in XML
        test14.setText(password);
    }
}