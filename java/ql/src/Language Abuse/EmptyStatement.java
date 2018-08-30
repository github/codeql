public class Cart {
	// AVOID: Empty statement
	List<Item> items = new ArrayList<Cart>();;
	public void applyDiscount(float discount) {
		// AVOID: Empty statement as loop body
		for (int i = 0; i < items.size(); items.get(i++).applyDiscount(discount));
	}
}