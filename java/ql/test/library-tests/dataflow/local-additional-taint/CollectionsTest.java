import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Set;
import java.util.Map;

class CollectionsTest {
	public static void taintSteps(List<String> list, List<String> other, Enumeration enumeration, Map<String,String> map) {
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

		List.of();
		java.util.List.of("a");
		List.of("b", "c");
		java.util.List.copyOf(list);
		Set.of();
		Set.of("d");
		Set.of("e" , "f");
		Set.copyOf(list);
		Map.of();
		Map.of("k", "v");
		Map.of("k1", "v1", "k2", "v2");
		Map.copyOf(map);
		Map.ofEntries();
		Map.ofEntries(Map.entry("k3", "v3"));
		Map.ofEntries(Map.entry("k4", "v4"), Map.entry("k5", "v5"));
	}
}

