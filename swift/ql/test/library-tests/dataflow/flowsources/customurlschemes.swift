// --- stubs ---
class UIApplication {
    struct OpenURLOptionsKey {}
}

struct URL {}

protocol UIApplicationDelegate {
    optional func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    optional func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    optional func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
}

// --- tests ---

class AppDelegate: UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool { // SOURCE
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool { // SOURCE
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool { // SOURCE
    }

}