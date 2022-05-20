public class Cart {
	private Set<Item> items;
	// ...
	// AVOID: Exposes representation
	public Set<Item> getItems() {
		return items;
	}
}
....
int countItems(Set<Cart> carts) {
	int result = 0;
	for (Cart cart : carts) {
		Set<Item> items = cart.getItems();
		result += items.size();
		items.clear(); // AVOID: Changes internal representation
	}
	return result;
}