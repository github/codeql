public class Utilities
{
	public static int max(int a, int b, int c) {
		int ret = Math.max(a, b)
		return ret = Math.max(ret, c);  // Redundant assignment
	}
}