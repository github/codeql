import java.util.List;
import java.util.ArrayList;

class ExternalLibraryUsage {
	public static void main(String[] args) {
		List<?> foo = new ArrayList(); // Java Runtime
		System.out.println(foo);
	}
}
