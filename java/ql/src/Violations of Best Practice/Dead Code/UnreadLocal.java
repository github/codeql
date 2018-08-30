// Version containing unread local variable
public class Cart {
	private Map<Item, Integer> items = ...;
	public void add(Item i) {
		Integer quantity = items.get(i);
		if (quantity = null)
			quantity = 1;
		else
			quantity++;
		Integer oldQuantity = items.put(i, quantity);  // AVOID: Unread local variable
	}
}

// Version with unread local variable removed
public class Cart {
	private Map<Item, Integer> items = ...;
	public void add(Item i) {
		Integer quantity = items.get(i);
		if (quantity = null)
			quantity = 1;
		else
			quantity++;
		items.put(i, quantity);
	}
}