package literals;

public class Literals {
	public int notAliteral;
	public void doStuff() {
		System.out.println("literal string");
		System.out.println(123);
		System.out.println(456L);
		System.out.println(123.0F);
		System.out.println(456.0D);
		System.out.println(true);
		System.out.println('x');
	}
	int min_int = -2147483648;
	long min_long = -9223372036854775808l;
	int neg_max_int = -2147483647;
	long neg_max_long = -9223372036854775807l;
	int alt_min_int = 0x80000000;
	long alt_min_long = 0x8000000000000000L;
	int i = 23 + 19;
	int j = 23  +19;
	String twostrings = "hello" + "world";
	String threestrings = "hello" + ", " + "world";
	String fourstrings = "hello" + ", " + "world" + "!";
	String escape_seq = "hello,\tworld";
	String unicode_escape_seq = "hello,\u0009world";
}
