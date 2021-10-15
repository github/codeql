
public class AnnotationValueUtil {



	/**
	 * Live because it is used as an annotation value on a live field.
	 */
	public static final String LIVE_STRING_CONSTANT_FIELD = "A string constant.";
	/**
	 * Live because it is used as annotation values on a live method.
	 */
	public static final String LIVE_STRING_CONSTANT_METHOD = "A string constant.";
	/**
	 * Live because it is used as annotation values on a live class.
	 */
	public static final String LIVE_STRING_CONSTANT_CLASS = "A string constant.";

	/**
	 * These three should be dead because they are used as annotation values on dead fields/methods/classes.
	 */
	public static final String DEAD_STRING_CONSTANT_FIELD = "A string constant.";
	public static final String DEAD_STRING_CONSTANT_METHOD = "A string constant.";
	public static final String DEAD_STRING_CONSTANT_CLASS = "A string constant.";

	public static void main(String[] args) {
		// Ensure outer class is live.
	}
}
