class Singleton {
    private static Resource resource;

    static {
        resource = new Resource();  // Initialize "resource" only once
    }
 
    public Resource getResource() {
        return resource;
    }
}