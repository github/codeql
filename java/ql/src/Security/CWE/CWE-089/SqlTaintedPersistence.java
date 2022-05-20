{
    // BAD: the category might have Java Persistence Query Language special characters in it
    String category = System.getenv("ITEM_CATEGORY");
    Statement statement = connection.createStatement();
    String query1 = "SELECT p FROM Product p WHERE p.category LIKE '"
        + category + "' ORDER BY p.price";
    Query q = entityManager.createQuery(query1);
}

{
    // GOOD: use a named parameter and set its value
    String category = System.getenv("ITEM_CATEGORY");
    String query2 = "SELECT p FROM Product p WHERE p.category LIKE :category ORDER BY p.price"
    Query q = entityManager.createQuery(query2);
    q.setParameter("category", category);
}

{
    // GOOD: use a positional parameter and set its value
    String category = System.getenv("ITEM_CATEGORY");
    String query3 = "SELECT p FROM Product p WHERE p.category LIKE ?1 ORDER BY p.price"
    Query q = entityManager.createQuery(query3);
    q.setParameter(1, category);
}

{
    // GOOD: use a named query with a named parameter and set its value
    @NamedQuery(
            name="lookupByCategory",
            query="SELECT p FROM Product p WHERE p.category LIKE :category ORDER BY p.price")
    private static class NQ {}
    ...
    String category = System.getenv("ITEM_CATEGORY");
    Query namedQuery1 = entityManager.createNamedQuery("lookupByCategory");
    namedQuery1.setParameter("category", category);
}

{
    // GOOD: use a named query with a positional parameter and set its value
    @NamedQuery(
            name="lookupByCategory",
            query="SELECT p FROM Product p WHERE p.category LIKE ?1 ORDER BY p.price")
    private static class NQ {}
    ...
    String category = System.getenv("ITEM_CATEGORY");
    Query namedQuery2 = entityManager.createNamedQuery("lookupByCategory");
    namedQuery2.setParameter(1, category);
}