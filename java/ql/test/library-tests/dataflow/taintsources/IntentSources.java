package com.example.myapp;

import android.app.Activity;

public class IntentSources extends Activity {

	public void test() {

		String trouble = this.getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);

	}

	public void test2() {

		String trouble = getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);

	}

	public void test3() {

		String trouble = getIntent().getExtras().getString("key");
		Runtime.getRuntime().exec(trouble);

	}

}

class OtherClass {

	public void test(IntentSources is) {
		String trouble = is.getIntent().getStringExtra("key");
		Runtime.getRuntime().exec(trouble);
	}

}