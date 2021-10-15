public class AnnotationValueTest {

	public static @interface TestAnnotation {
		public String[] value();
	}

	@TestAnnotation(value = AnnotationValueUtil.LIVE_STRING_CONSTANT_FIELD)
	public static String liveField = "";

	@TestAnnotation(value = AnnotationValueUtil.DEAD_STRING_CONSTANT_FIELD)
	public static String deadField = "";

	@TestAnnotation(value = { AnnotationValueUtil.LIVE_STRING_CONSTANT_METHOD })
	public static void liveMethod() {
	}

	@TestAnnotation(value = AnnotationValueUtil.DEAD_STRING_CONSTANT_METHOD)
	public static void deadMethod() {
	}

	/**
	 * Class is live because it is constructed in the main method, which in turn should make this
	 * annotation live, causing LIVE_STRING_CONSTANT_CLASS to be live because it is read in the
	 * annotation.
	 */
	@TestAnnotation(value = AnnotationValueUtil.LIVE_STRING_CONSTANT_CLASS + "..")
	public static class LiveClass {
	}

	/**
	 * This class is dead, so the annotation is dead, and the field read of
	 * DEAD_STRING_CONSTANT_CLASS will not make the field live.
	 */
	@TestAnnotation(value = AnnotationValueUtil.DEAD_STRING_CONSTANT_CLASS)
	public static class DeadClass {
	}

	public static void main(String[] args) {
		System.out.println(liveField);
		liveMethod();
		new LiveClass();
	}
}
