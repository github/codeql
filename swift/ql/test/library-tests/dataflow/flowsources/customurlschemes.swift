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

class UIScene {
    class ConnectionOptions {}
}

class UISceneSession {}

class NSUserActivity {}

class UIOpenURLContext: Hashable {
    static func == (lhs: UIOpenURLContext, rhs: UIOpenURLContext) -> Bool {
        return true;
    }

    func hash(into hasher: inout Hasher) {}
}

protocol UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions)
    func scene(_: UIScene, continue: NSUserActivity)
    func scene(_: UIScene, didUpdate: NSUserActivity)
    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>)
}

// --- tests ---

class AppDelegate: UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool { // $ source=remote
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool { // $ source=remote
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool { // $ source=remote
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        launchOptions?[.url] // $ source=remote
        return true
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        launchOptions?[.url] // $ source=remote
        return true
    }
}

class SceneDelegate : UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {} // $ source=remote
    func scene(_: UIScene, continue: NSUserActivity) {} // $ source=remote
    func scene(_: UIScene, didUpdate: NSUserActivity) {} // $ source=remote
    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>) {} // $ source=remote
}

class Extended {}

extension Extended : UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {} // $ source=remote
    func scene(_: UIScene, continue: NSUserActivity) {} // $ source=remote
    func scene(_: UIScene, didUpdate: NSUserActivity) {} // $ source=remote
    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>) {} // $ source=remote
}
