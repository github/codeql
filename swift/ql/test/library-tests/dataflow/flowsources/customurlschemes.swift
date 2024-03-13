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
    class ConnectionOptions {
        var userActivities: Set<NSUserActivity> { get { return Set() } }
        var urlContexts: Set<UIOpenURLContext> { get { return Set() } }
    }
}

class UISceneSession {}

class NSUserActivity: Hashable {
    static func == (lhs: NSUserActivity, rhs: NSUserActivity) -> Bool {
        return true;
    }

    func hash(into hasher: inout Hasher) {}

    var webpageURL: URL? { get { return nil } set { } }
    var referrerURL: URL? { get { return nil } set { } }
}

class UIOpenURLContext: Hashable {
    static func == (lhs: UIOpenURLContext, rhs: UIOpenURLContext) -> Bool {
        return true;
    }

    func hash(into hasher: inout Hasher) {}

    var url: URL { get { return URL() } }
}

protocol UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions)
    func scene(_: UIScene, continue: NSUserActivity)
    func scene(_: UIScene, didUpdate: NSUserActivity)
    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>)
}

func sink(arg: Any) {}

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
        let url = launchOptions?[.url] // $ source=remote
        sink(arg: url) // $ tainted
        return true
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        let url = launchOptions?[.url] // $ source=remote
        sink(arg: url) // $ tainted

        let url2 = launchOptions?[.url] as! String // $ source=remote
        sink(arg: url2) // $ tainted

        if let url3 = launchOptions?[.url] as? String { // $ source=remote
          sink(arg: url3) // $ tainted
        }

        if let options = launchOptions {
          let url4 = options[.url] as! String // $ source=remote
          sink(arg: url4) // $ tainted
        }

        switch launchOptions {
          case .some(let options):
            let url5 = options[.url] // $ MISSING: source=remote
            sink(arg: url5) // $ MISSING: tainted
          case .none:
            break
        }

        processLaunchOptions(options: launchOptions)

        return true
    }

    private func processLaunchOptions(options: [UIApplication.LaunchOptionsKey : Any]?) {
      // (called above)
      let url = options?[.url] // $ MISSING: source=remote
      sink(arg: url) // $ MISSING: tainted
    }
}

class SceneDelegate : UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) { // $ source=remote
      for userActivity in options.userActivities {
        let x = userActivity.webpageURL
        sink(arg: x) // $ MISSING: tainted
        let y = userActivity.referrerURL
        sink(arg: y) // $ MISSING: tainted
      }

      for urlContext in options.urlContexts {
        let z = urlContext.url
        sink(arg: z) // $ MISSING: tainted
      }
    }

    func scene(_: UIScene, continue: NSUserActivity) { // $ source=remote
      let x = `continue`.webpageURL
      sink(arg: x) // $ tainted
      let y = `continue`.referrerURL
      sink(arg: y) // $ tainted
    }

    func scene(_: UIScene, didUpdate: NSUserActivity) { // $ source=remote
      let x = didUpdate.webpageURL
      sink(arg: x) // $ tainted
      let y = didUpdate.referrerURL
      sink(arg: y) // $ tainted
    }

    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>) { // $ source=remote
      for openURLContext in openURLContexts {
        let x = openURLContext.url
        sink(arg: x) // $ MISSING: tainted
      }
    }
}

class Extended {}

extension Extended : UISceneDelegate {
    func scene(_: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) { // $ source=remote
      for userActivity in options.userActivities {
        let x = userActivity.webpageURL
        sink(arg: x) // $ MISSING: tainted
        let y = userActivity.referrerURL
        sink(arg: y) // $ MISSING: tainted
      }

      for urlContext in options.urlContexts {
        let z = urlContext.url
        sink(arg: z) // $ MISSING: tainted
      }
    }

    func scene(_: UIScene, continue: NSUserActivity) { // $ source=remote
      let x = `continue`.webpageURL
      sink(arg: x) // $ tainted
      let y = `continue`.referrerURL
      sink(arg: y) // $ tainted
    }

    func scene(_: UIScene, didUpdate: NSUserActivity) { // $ source=remote
      let x = didUpdate.webpageURL
      sink(arg: x) // $ tainted
      let y = didUpdate.referrerURL
      sink(arg: y) // $ tainted
    }

    func scene(_: UIScene, openURLContexts: Set<UIOpenURLContext>) { // $ source=remote
      for openURLContext in openURLContexts {
        let x = openURLContext.url
        sink(arg: x) // $ MISSING: tainted
      }
    }
}
