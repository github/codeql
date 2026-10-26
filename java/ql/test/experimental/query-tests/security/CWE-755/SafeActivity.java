package com.example.app;

import android.app.Activity;
import android.os.Bundle;

/** Android activity that tests app crash by NumberFormatException, which is not exported in `AndroidManifest.xml` */
public class SafeActivity extends Activity {
	// BAD - parse string extra to double
	public void testOnCreate1(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		String minPriceStr = getIntent().getStringExtra("priceMin");
		double minPrice = Double.parseDouble(minPriceStr);
	}
}