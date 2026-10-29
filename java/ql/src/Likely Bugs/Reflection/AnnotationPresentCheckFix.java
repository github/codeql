public class AnnotationPresentCheckFix {
	@Retention(RetentionPolicy.RUNTIME)  // Annotate the annotation
	public static @interface UntrustedData { }

	@UntrustedData
	public static String getUserData() {
		Scanner scanner = new Scanner(System.in);
		return scanner.nextLine();
	}

	public static void main(String[] args) throws NoSuchMethodException, SecurityException {
		String data = getUserData();
		Method m = AnnotationPresentCheckFix.class.getMethod("getUserData");
		if(m.isAnnotationPresent(UntrustedData.class)) {  // Returns 'true'
			System.out.println("Not trusting data from user.");
		}
	}
}