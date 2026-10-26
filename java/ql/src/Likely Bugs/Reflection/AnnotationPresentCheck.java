public class AnnotationPresentCheck {
	public static @interface UntrustedData { }

	@UntrustedData
	public static String getUserData() {
		Scanner scanner = new Scanner(System.in);
		return scanner.nextLine();
	}

	public static void main(String[] args) throws NoSuchMethodException, SecurityException {
		String data = getUserData();
		Method m = AnnotationPresentCheck.class.getMethod("getUserData");
		if(m.isAnnotationPresent(UntrustedData.class)) {  // Returns 'false'
			System.out.println("Not trusting data from user.");
		}
	}
}