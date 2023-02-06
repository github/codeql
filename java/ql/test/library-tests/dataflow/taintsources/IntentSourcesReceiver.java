package com.example.myapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class IntentSourcesReceiver extends BroadcastReceiver {

	private static void sink(Object o) {}

	@Override
	public void onReceive(Context context, Intent intent) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
	}
}
