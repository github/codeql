public class BasicTest {
	private static String deadStaticField = "Dead"; // $ Alert
	private static String liveStaticField = "Live";
	private String deadField; // $ Alert
	private String deadCycleField; // $ Alert
	private String liveField;

	public BasicTest(String deadField, String liveField) {
		this.deadField = deadField;
		this.liveField = liveField;
	}

	public String getDeadField() {
		return deadField;
	}

	public String getLiveField() {
		return liveField;
	}

	public String useDeadCycleFielda() {
		return useDeadCycleFieldb(deadCycleField);
	}

	public String useDeadCycleFieldb(String val) {
		return val + useDeadCycleFielda();
	}

	public static String getDeadStaticField() {
		return deadStaticField;
	}

	public static String getLiveStaticField() {
		return liveStaticField;
	}

	public static void main(String[] args) {
		new BasicTest("dead", "live").getLiveField();
		getLiveStaticField();
	}
}
