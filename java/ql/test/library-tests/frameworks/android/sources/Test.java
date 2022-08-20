package com.example.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class Test extends Activity {

	void sink(Object o) {}

	public void onCreate(Bundle saved) {
		Intent implicitIntent = new Intent("SOME_ACTION");
		startActivityForResult(implicitIntent, 0);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		sink(requestCode); // safe
		sink(resultCode); // safe
		sink(data); // $ hasValueFlow
	}
}
