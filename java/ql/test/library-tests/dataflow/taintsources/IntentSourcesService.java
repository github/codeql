package com.example.myapp;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;

public class IntentSourcesService extends Service {

	private static void sink(Object o) {}

	@Override
	public void onStart(Intent intent, int startId) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		return -1;
	}

	@Override
	public IBinder onBind(Intent intent) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		return null;
	}

	@Override
	public boolean onUnbind(Intent intent) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		return false;
	}

	@Override
	public void onRebind(Intent intent) {
		{
			String trouble = intent.getStringExtra("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
		{
			String trouble = intent.getExtras().getString("data");
			sink(trouble); // $ hasRemoteTaintFlow
		}
	}

	@Override
	public void onTaskRemoved(Intent intent) {
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
