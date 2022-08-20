package com.example.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class Safe extends Activity {

	void sink(Object o) {}

	public void onCreate(Bundle saved) {
		Intent explicitIntent = new Intent(this, Activity.class);
		startActivityForResult(explicitIntent, 0);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		sink(requestCode); // safe
		sink(resultCode); // safe
		sink(data); // Safe
	}
}
