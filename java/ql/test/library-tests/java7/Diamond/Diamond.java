

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Diamond {
	// normal parameterized class instance expressions
	List<Integer> list = new ArrayList<Integer>();
	Map<String, Object> map = new HashMap<String, Object>();

	// same, but with diamond
	List<Integer> diamond_list = new ArrayList<>();
	Map<String, Object> diamond_map = new HashMap<>();

	// anonymous without diamond
	Object obj = new Object() {};
	Runnable runnable = new Runnable() {
		@Override
		public void run() {
		}
	};
	List<Integer> list2 = new ArrayList<Integer>() {};

	// anonymous with diamond (supported since Java 9)
	List<Integer> list3 = new ArrayList<>() {};
	Map<String, Object> map2 = new HashMap<>() {
		@Override
		public String toString() {
			return "custom map";
		}
	};

	// other class instance expressions
	List l = new ArrayList();
	List l2 = new ArrayList() {};
	Error e = new Error();
}
