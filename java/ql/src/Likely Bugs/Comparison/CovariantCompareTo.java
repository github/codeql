public class CovariantCompareTo {
	static class Super implements Comparable<Super> {
		public int compareTo(Super rhs) {
			return -1;
		}
	}
	
	static class Sub extends Super {
		public int compareTo(Sub rhs) {  // Definition of compareTo uses a different parameter type
			return 0;
		}
	}
	
	public static void main(String[] args) {
		Super a = new Sub();
		Super b = new Sub();
		System.out.println(a.compareTo(b));
	}
}