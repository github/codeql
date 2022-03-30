package com.example.app;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class TestMissing extends Activity {

	void sink(Object o) {}

	public void onCreate(Bundle saved) {
		Helper.startNewActivity(this);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		sink(requestCode); // safe
		sink(resultCode); // safe
		sink(data); // $ MISSING: $hasValueFlow
	}

	static class Helper {
		public static void startNewActivity(Activity ctx) {
			Intent implicitIntent = new Intent("SOME_ACTION");
			ctx.startActivityForResult(implicitIntent, 0);
		}
	}
}
