// Before refactoring:
class Item { .. }
class Basket {
	// ..
	float getTotalPrice(Item i) {
		float price = i.getPrice() + i.getTax();
		if (i.isOnSale())
			price = price - i.getSaleDiscount() * price;
		return price;
	}
}

// After refactoring:
class Item {
	// ..
	float getTotalPrice() {
		float price = getPrice() + getTax();
		if (isOnSale())
			price = price - getSaleDiscount() * price;
		return price;
	}
}