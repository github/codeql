import java.text.SimpleDateFormat;
import java.util.Date;

public class A {
	public static void main(String[] args) {
		System.out.println(new SimpleDateFormat("yyyy-MM-dd").format(new Date())); // OK
		System.out.println(new SimpleDateFormat("YYYY-ww").format(new Date())); // OK
		System.out.println(new SimpleDateFormat("YYYY-MM-dd").format(new Date())); // BAD
	}
}
