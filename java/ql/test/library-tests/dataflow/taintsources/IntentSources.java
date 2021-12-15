package com.example.myapp;

import android.app.Activity;

public class IntentSources extends Activity {

	private static void sink(Object o) {}

	public void test() throws java.io.IOException {

		String trouble = this.getIntent().getStringExtra("key");
		sink(trouble); // $hasRemoteTaintFlow

	}

	public void test2() throws java.io.IOException {

		String trouble = getIntent().getStringExtra("key");
		sink(trouble); // $hasRemoteTaintFlow

	}

	public void test3() throws java.io.IOException {

		String trouble = getIntent().getExtras().getString("key");
		sink(trouble); // $hasRemoteTaintFlow

	}

}

class OtherClass {

	private static void sink(Object o) {}

	public void test(IntentSources is) throws java.io.IOException {
		String trouble = is.getIntent().getStringExtra("key");
		sink(trouble); // $hasRemoteTaintFlow
	}

}
