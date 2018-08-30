class Cart {
    Map<Integer, Integer> items = ...
    public void addItem(Item i) {
        // Braces included.
        if (i != null) {
            log("Adding item: " + i);
            Integer curQuantity = items.get(i.getID());
            if (curQuantity == null) curQuantity = 0;
            items.put(i.getID(), curQuantity+1);
        }
    }
}