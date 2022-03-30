// Class for bean 'chart1'
public class WrongChartMaker {
	private AxisRenderer axisRenderer = new DefaultAxisRenderer();
	private TrendRenderer trendRenderer = new DefaultTrendRenderer();
	
	public WrongChartMaker() {}

	// Each combination of the optional parameters must be represented by a constructor.
	public WrongChartMaker(AxisRenderer customAxisRenderer) {
		this.axisRenderer = customAxisRenderer;
	}
	
	public WrongChartMaker(TrendRenderer customTrendRenderer) {
		this.trendRenderer = customTrendRenderer;
	}
	
	public WrongChartMaker(AxisRenderer customAxisRenderer, 
							TrendRenderer customTrendRenderer) {
		this.axisRenderer = customAxisRenderer;
		this.trendRenderer = customTrendRenderer;
	}
}