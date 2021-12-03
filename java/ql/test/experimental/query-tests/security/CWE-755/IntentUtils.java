package com.example.app;

import android.app.Activity;

import android.os.Bundle;


/** A utility program for getting intent extra information from Android activity */
public class IntentUtils {

	/** Get double extra */
	public static double getDoubleExtra(Activity a, String key) {
		String value = a.getIntent().getStringExtra(key);
		return Double.parseDouble(value);
	}
}