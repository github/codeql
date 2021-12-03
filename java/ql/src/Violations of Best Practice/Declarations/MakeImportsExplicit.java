import java.util.*;  // AVOID: Implicit import statements
import java.awt.*;

public class Customers {
	public List getCustomers() {  // Compiler error: 'List' is ambiguous.
		...
	}
}