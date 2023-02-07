// --- stubs ---

struct URL {}

class NSUserActivity: Hashable {
    static func == (lhs: NSUserActivity, rhs: NSUserActivity) -> Bool {
        return true;
    }

    func hash(into hasher: inout Hasher) {}
}

class UIApplicationShortcutItem {}

class UIOpenURLContext: Hashable {
    var url: URL = URL()
    var options: UIScene.OpenURLOptions = UIScene.OpenURLOptions()

    static func == (lhs: UIOpenURLContext, rhs: UIOpenURLContext) -> Bool {
        return true;
    }

    func hash(into hasher: inout Hasher) {}
}

struct CKShareMetadata {}

class UNNotificationResponse {}

class UIScene {
    class ConnectionOptions {
        var userActivities: Set<NSUserActivity> = []
        var shortcutItem: UIApplicationShortcutItem? = nil
        var urlContexts: Set<UIOpenURLContext> = []
        var handoffUserActivityType: String? = nil
        var cloudKitShareMetadata: CKShareMetadata? = nil
        var notificationResponse: UNNotificationResponse? = nil
        var sourceApplication: String? = nil
    }

    class OpenURLOptions {}
}

// --- tests ---

func source() -> Any { return "" }
func sink(_: Any) {}

func testUIOpenURLContext() {
    let safe = UIOpenURLContext()
    let tainted = source() as! UIOpenURLContext

    sink(safe.url)
    sink(safe.options)
    sink(tainted.url) // $ tainted=51
    sink(tainted.options)
}

func testConnectionOptions() {
    let safe = UIScene.ConnectionOptions()
    let tainted = source() as! UIScene.ConnectionOptions

    sink(safe.userActivities)
    sink(tainted.userActivities) // $ tainted=61
    sink(safe.shortcutItem)
    sink(tainted.shortcutItem)
    sink(safe.urlContexts)
    sink(tainted.urlContexts) // $ tainted=61
    sink(safe.handoffUserActivityType)
    sink(tainted.handoffUserActivityType)
    sink(safe.cloudKitShareMetadata)
    sink(tainted.cloudKitShareMetadata)
    sink(safe.notificationResponse)
    sink(tainted.notificationResponse)
    sink(safe.sourceApplication)
    sink(tainted.sourceApplication)
}
