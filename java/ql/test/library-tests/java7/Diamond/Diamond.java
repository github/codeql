

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Diamond {
	// normal parameterized class instance expressions
	List<Integer> list = new ArrayList<Integer>();
	Map<String, Object> map = new  HashMap<String, Object>();
	
	// same, but with diamond
	List<Integer> diamond_list = new ArrayList<>();
	Map<String, Object> diamond_map = new HashMap<>();
	
	// other class instance expressions
	List l = new ArrayList();
	Error e = new Error();
}
