public class UselessTypeTest {
	private static class B {}
	private static class D extends B {}

	public static void main(String[] args) {
		D d = new D();
		if(d instanceof B) {	// violation
			System.out.println("Mon dieu, d is a B!");
		}
	}
}