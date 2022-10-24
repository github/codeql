// --- stubs ---
class UIApplication {
    struct OpenURLOptionsKey : Hashable {
        static func == (lhs: OpenURLOptionsKey, rhs: OpenURLOptionsKey) -> Bool {
            return true;
        }

        func hash(into hasher: inout Hasher) {}
    }
}

struct URL {}

protocol UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
}

// --- tests ---

class AppDelegate: UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool { // SOURCE
        return true;
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool { // SOURCE
        return true;
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool { // SOURCE
        return true;
    }

}
