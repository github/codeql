// --- stubs ---
class UIApplication {
    struct OpenURLOptionsKey : Hashable {
        static func == (lhs: OpenURLOptionsKey, rhs: OpenURLOptionsKey) -> Bool {
            return true;
        }

        func hash(into hasher: inout Hasher) {}
    }
    struct LaunchOptionsKey: Hashable {
        init(rawValue: String) {}
        public static let url: UIApplication.LaunchOptionsKey = UIApplication.LaunchOptionsKey(rawValue: "")
        func hash(into hasher: inout Hasher) {}
    }
}

struct URL {}

protocol UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool
}

// --- tests ---

class AppDelegate: UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool { // SOURCE
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool { // SOURCE
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool { // SOURCE
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        launchOptions?[.url] // SOURCE
        return true
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        launchOptions?[.url] // SOURCE
        return true
    }

}
