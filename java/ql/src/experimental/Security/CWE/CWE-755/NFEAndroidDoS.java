public class NFEAndroidDoS extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_view);

		// BAD: Uncaught NumberFormatException due to remote user inputs
		{
			String minPriceStr = getIntent().getStringExtra("priceMin");
			double minPrice = Double.parseDouble(minPriceStr);	
		}

		// GOOD: Use the proper Android method to get number extra  
		{
			int width = getIntent().getIntExtra("width", 0);
			int height = getIntent().getIntExtra("height", 0);
		}
	}
}