
public class Test {
	public static void main(String[] args) {
		for (int i = 0; i < args.length; i++) {
			switch(args.length) {
			case -2:
				return;
			case -1:
				continue;
			case 0:
				System.out.println("No args");
				break;
			case 1:
			case 2:
				System.out.println("1-2 args");
				// missing break.
			case 3:
				System.out.println("3 or more args");
				// fall-through
			case 4:
				System.out.println("4 or more args");
				if (i > 1)
					break;
				// conditionally missing break.
			case 5:
				System.out.println("foo");
				// Missing break, but switch ends.
			}
		}
	}
}
