import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

class CollectionsTest {
	public static void taintSteps(List<String> list, List<String> other, Enumeration enumeration) {
		Collections.addAll(list);
		Collections.addAll(list, "one");
		Collections.addAll(list, "two", "three");
		Collections.addAll(list, new String[]{ "four" });

		Collections.checkedList(list, String.class);
		Collections.min(list);
		Collections.enumeration(list);
		Collections.list(enumeration);
		Collections.singletonMap("key", "value");
		Collections.copy(list, other);
		Collections.nCopies(10, "item");
		Collections.replaceAll(list, "search", "replace");
	}
}

