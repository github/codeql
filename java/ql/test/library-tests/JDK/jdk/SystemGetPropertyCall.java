package jdk;

public class SystemGetPropertyCall {
    private static final String USER_DIR_PROPERTY = "user.dir";

    void a() {
        System.getProperty("user.dir");
    }

    void b() {
        System.getProperty("user.dir", "HOME");
    }

    void c() {
        System.getProperty(USER_DIR_PROPERTY);
    }

    void d() {
        System.getProperty("random.property");
    }
}
