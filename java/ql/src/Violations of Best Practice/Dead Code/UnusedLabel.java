public class WebStore {
	public boolean itemIsBeingBought(Item item) {
		boolean found = false;
		carts:  // AVOID: Unused label
		for (int i = 0; i < carts.size(); i++) {
			Cart cart = carts.get(i);
			for (int j = 0; j < cart.numItems(); j++) {
				if (item.equals(cart.getItem(j))) {
					found = true;
					break;
				}
			}
		}
		return found;
	}
}