// Class for bean 'chart2'
public class ChartMaker {
	private AxisRenderer axisRenderer = new DefaultAxisRenderer();
	private TrendRenderer trendRenderer = new DefaultTrendRenderer();
	
	public ChartMaker() {}
	
	public void setAxisRenderer(AxisRenderer axisRenderer) {
		this.axisRenderer = axisRenderer;
	}
	
	public void setTrendRenderer(TrendRenderer trendRenderer) {
		this.trendRenderer = trendRenderer;
	}
}