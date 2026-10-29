package com.example.app;

import android.app.Activity;
import android.os.Bundle;

/** Android activity that tests app crash by NumberFormatException  */
public class NFEAndroidDoS extends Activity {
	// BAD - parse string extra to double
	public void testOnCreate1(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		String minPriceStr = getIntent().getStringExtra("priceMin"); // $ Source
		double minPrice = Double.parseDouble(minPriceStr); // $ Alert
	}

	// BAD - parse string extra to integer
	public void testOnCreate2(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		String widthStr = getIntent().getStringExtra("width"); // $ Source
		int width = Integer.parseInt(widthStr); // $ Alert

		String heightStr = getIntent().getStringExtra("height"); // $ Source
		int height = Integer.parseInt(heightStr); // $ Alert
	}	

	// GOOD - parse int extra to integer
	public void testOnCreate3(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		int width = getIntent().getIntExtra("width", 0);
		int height = getIntent().getIntExtra("height", 0);
	}		

	// BAD - convert string extra to double
	public void testOnCreate4(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);
	
		String minPriceStr = getIntent().getStringExtra("priceMin"); // $ Source
		double minPrice = new Double(minPriceStr); // $ Alert

		String maxPriceStr = getIntent().getStringExtra("priceMax");
		double maxPrice = Double.valueOf(minPriceStr); // $ Alert
	}	

	// GOOD - parse string extra to double with caught NFE
	public void testOnCreate5(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		double minPrice = 0;
		try {
			String minPriceStr = getIntent().getStringExtra("priceMin");
			minPrice = Double.parseDouble(minPriceStr);
		} catch (NumberFormatException nfe) {
			nfe.printStackTrace();
		}
	}

	// GOOD - parse string extra to double with caught NFE as the supertype Throwable
	public void testOnCreate6(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		double minPrice = 0;
		try {
			String minPriceStr = getIntent().getStringExtra("priceMin");
			minPrice = Double.parseDouble(minPriceStr);
		} catch (Throwable te) {
			te.printStackTrace();
		}
	}

	// BAD - parse string extra to double
	// Note this case of invoking utility method that takes an Activity a then calls `a.getIntent().getStringExtra(...)` is not yet detected thus is beyond what the query is capable of.
	public void testOnCreate7(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		double priceMin = IntentUtils.getDoubleExtra(this, "priceMin");
	}
}
