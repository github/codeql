package com.example.myapp;

import android.app.Activity;

public class IntentSources extends Activity {

	public void test() throws java.io.IOException {

		String trouble = this.getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);

	}

	public void test2() throws java.io.IOException {

		String trouble = getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);

	}

	public void test3() throws java.io.IOException {

		String trouble = getIntent().getExtras().getString("key");
		Runtime.getRuntime().exec(trouble);

	}

}

class OtherClass {

	public void test(IntentSources is) throws java.io.IOException {
		String trouble = is.getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);
	}

}
