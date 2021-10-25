class Singleton {
    private static Resource resource;

    public Resource getResource() {
        if(resource == null)
            resource = new Resource();  // Lazily initialize "resource"
        return resource;
    }
}