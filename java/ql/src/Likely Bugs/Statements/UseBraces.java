class Cart {
    Map<Integer, Integer> items = ...
    public void addItem(Item i) {
        // No braces and misleading indentation.
        if (i != null)
            log("Adding item: " + i);
            // Indentation suggests that the following statements
            // are in the body of the 'if'.
            Integer curQuantity = items.get(i.getID());
            if (curQuantity == null) curQuantity = 0;
            items.put(i.getID(), curQuantity+1);
    }
}