
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init(fileURLWithPath: String) {}
}

class NSObject {
}

class Process : NSObject {
	var launchPath: String? { get { nil } set {} }
	var arguments: [String]? { get { nil } set {} }
	func launch() {}

	var executableURL: URL? { get { nil } set {} }
	func run() throws {}

	class func launchedProcess(launchPath path: String, arguments: [String]) -> Process {
		return Process()
	}

	class func run(_ url: URL, arguments: [String], terminationHandler: (@Sendable (Process) -> Void)? = nil) throws -> Process {
		return Process()
	}
}

extension String {
    init(contentsOf url: URL) throws {
        self.init("")
    }
}

class NSUserScriptTask : NSObject {
	typealias CompletionHandler = @Sendable (Error?) -> Void

	init(url: URL) throws {}
	func execute(completionHandler handler: NSUserScriptTask.CompletionHandler? = nil) { }
}

class NSUserUnixTask : NSUserScriptTask {
	func execute(withArguments arguments: [String]?, completionHandler handler: NSUserScriptTask.CompletionHandler? = nil) { }
}

protocol NSSecureCoding {
}

class NSUserAutomatorTask : NSUserScriptTask {
	func execute(withInput input: NSSecureCoding?, completionHandler handler: NSUserScriptTask.CompletionHandler? = nil) { }

	var variables: [String: Any]? { get { return nil } set { } }
}

class FileManager : NSObject {
	class var `default`: FileManager { get { return 0 as! FileManager } }

	func contentsOfDirectory(atPath path: String) throws -> [String] { [] }
}

// --- tests ---

func validateCommand(_ command: String) -> String? {
    let allowedCommands = ["ls -l", "pwd", "echo"]

    if allowedCommands.contains(command) {
        return command
    }

    return nil
}

func testCommandInjectionQhelpExamples() {
	guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else { // $ MISSING: Source
		return
	}

	let task1 = Process()
	task1.launchPath = "/bin/bash" // GOOD
	task1.arguments = ["-c", userControlledString] // $ MISSING: Alert
	task1.launch()

	if let validatedString = validateCommand(userControlledString) {
    	let task2 = Process()
    	task2.launchPath = "/bin/bash" // GOOD
    	task2.arguments = ["-c", validatedString] // GOOD [FALSE POSITIVE]
	    task2.launch()
	}
}

func mkProcess() -> Process? {
	return Process()
}

class MyProcess : Process {
	var harmlessField: String?

	func setArguments(_ arguments: [String]) {
		self.arguments = arguments // $ MISSING: Alert
	}
}

func testCommandInjectionMore(mySafeString: String) {
	guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else { // $ Source
		return
	}

	let task1 = Process()
	task1.executableURL = URL(string: mySafeString)! // GOOD
	task1.arguments = ["abc"] // GOOD
	try! task1.run()

	let task2 = Process()
	task2.executableURL = URL(fileURLWithPath: mySafeString) // GOOD
	task2.arguments = ["abc", "def"] // GOOD
	try! task2.run()

	let task3 = Process()
	task3.executableURL = URL(string: userControlledString)! // $ MISSING: Alert
	task3.arguments = ["abc", userControlledString] // $ MISSING: Alert
	try! task3.run()

	let task4 = Process()
	task4.executableURL = URL(fileURLWithPath: userControlledString) // $ MISSING: Alert
	task4.executableURL = URL(string: userControlledString)! // $ MISSING: Alert
	task4.arguments = ["abc", "def" + userControlledString] // $ MISSING: Alert
	try! task4.run()

	let task5 = mkProcess()
	task5?.executableURL = URL(fileURLWithPath: userControlledString) // $ MISSING: Alert
	task5?.arguments = [userControlledString] // $ MISSING: Alert
	try! task5?.run()

	let task6 = MyProcess()
	task6.executableURL = URL(fileURLWithPath: userControlledString) // $ MISSING: Alert
	task6.executableURL = URL(string: userControlledString)! // $ MISSING: Alert
	task6.arguments = [userControlledString] // $ MISSING: Alert
	task6.setArguments([userControlledString]) // BAD (flagged inside `setArguments`)
	task6.harmlessField = userControlledString // GOOD
	try! task6.run()

	let task7 = Process()
	task7.executableURL = URL(fileURLWithPath: mySafeString) // GOOD
	task7.arguments = ["abc", "def"]
	task7.arguments?.append(userControlledString) // $ MISSING: Alert // Originally missing
	try! task7.run()

	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", mySafeString]) // GOOD
	_ = Process.launchedProcess(launchPath: userControlledString, arguments: ["abc", mySafeString]) // $ Alert
	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", userControlledString]) // $ MISSING: Alert

	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", mySafeString]) // GOOD
	_ = try? Process.run(URL(string: userControlledString)!, arguments: ["abc", mySafeString]) // $ MISSING: Alert
	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", userControlledString]) // $ MISSING: Alert

	let task8 = try! NSUserScriptTask(url: URL(string: mySafeString)!) // GOOD
	task8.execute()

	let task9 = try! NSUserScriptTask(url: URL(string: userControlledString)!) // $ Alert
	task9.execute()

	let task10 = try! NSUserUnixTask(url: URL(string: userControlledString)!) // $ MISSING: Alert
	task10.execute(withArguments: [userControlledString]) // $ MISSING: Alert

	let task11 = try! NSUserAutomatorTask(url: URL(string: userControlledString)!) // $ MISSING: Alert
	task11.variables = ["abc": userControlledString] // $ MISSING: Alert // Originally missing
	task11.execute(withInput: nil)

	let files = try! FileManager.default.contentsOfDirectory(atPath: "some/directory")
	for file in files {
		let task12 = Process()
		task12.launchPath = "/bin/rm" // GOOD
		task12.arguments = [file] // GOOD (cases like this vary, but our analysis doesn't work well on them)
		task12.launch()
		task12.arguments = files // GOOD (similar to previous)
		task12.launch()
		task12.arguments = [files[0]] // GOOD (similar to previous)
		task12.launch()
	}

}

struct MyClass {
	let p1 : Process
	let p2 : Process?
	let p3 : Process!

	var myValue: [String]? {
		get {
			return nil
		}
		set {
			p1.arguments = newValue // $ MISSING: Alert
			p2!.arguments = newValue // $ MISSING: Alert
			p3.arguments = newValue // $ MISSING: Alert
		}
	}

	mutating func myFunc() {
		guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else { // $ MISSING: Source
			return
		}

		let tainted1 = [userControlledString]

		p1.arguments = tainted1 // $ MISSING: Alert
		p2!.arguments = tainted1 // $ MISSING: Alert
		p3.arguments = tainted1 // $ MISSING: Alert

		let tainted2 : [String]? = [userControlledString]

		p1.arguments = tainted2 // $ MISSING: Alert
		p2!.arguments = tainted2 // $ MISSING: Alert
		p3.arguments = tainted2 // $ MISSING: Alert

		myValue = tainted2
	}
}
