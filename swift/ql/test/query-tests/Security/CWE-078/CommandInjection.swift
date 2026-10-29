
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
	guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else {
		return
	}

	let task1 = Process()
	task1.launchPath = "/bin/bash" // GOOD
	task1.arguments = ["-c", userControlledString] // BAD
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
		self.arguments = arguments // BAD
	}
}

func testCommandInjectionMore(mySafeString: String) {
	guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else {
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
	task3.executableURL = URL(string: userControlledString)! // BAD
	task3.arguments = ["abc", userControlledString] // BAD
	try! task3.run()

	let task4 = Process()
	task4.executableURL = URL(fileURLWithPath: userControlledString) // BAD
	task4.executableURL = URL(string: userControlledString)! // BAD
	task4.arguments = ["abc", "def" + userControlledString] // BAD
	try! task4.run()

	let task5 = mkProcess()
	task5?.executableURL = URL(fileURLWithPath: userControlledString) // BAD
	task5?.arguments = [userControlledString] // BAD
	try! task5?.run()

	let task6 = MyProcess()
	task6.executableURL = URL(fileURLWithPath: userControlledString) // BAD
	task6.executableURL = URL(string: userControlledString)! // BAD
	task6.arguments = [userControlledString] // BAD
	task6.setArguments([userControlledString]) // BAD (flagged inside `setArguments`)
	task6.harmlessField = userControlledString // GOOD
	try! task6.run()

	let task7 = Process()
	task7.executableURL = URL(fileURLWithPath: mySafeString) // GOOD
	task7.arguments = ["abc", "def"]
	task7.arguments?.append(userControlledString) // BAD [NOT DETECTED]
	try! task7.run()

	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", mySafeString]) // GOOD
	_ = Process.launchedProcess(launchPath: userControlledString, arguments: ["abc", mySafeString]) // BAD
	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", userControlledString]) // BAD

	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", mySafeString]) // GOOD
	_ = try? Process.run(URL(string: userControlledString)!, arguments: ["abc", mySafeString]) // BAD
	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", userControlledString]) // BAD

	let task8 = try! NSUserScriptTask(url: URL(string: mySafeString)!) // GOOD
	task8.execute()

	let task9 = try! NSUserScriptTask(url: URL(string: userControlledString)!) // BAD
	task9.execute()

	let task10 = try! NSUserUnixTask(url: URL(string: userControlledString)!) // BAD
	task10.execute(withArguments: [userControlledString]) // BAD

	let task11 = try! NSUserAutomatorTask(url: URL(string: userControlledString)!) // BAD
	task11.variables = ["abc": userControlledString] // BAD [NOT DETECTED]
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
			p1.arguments = newValue // BAD
			p2!.arguments = newValue // BAD
			p3.arguments = newValue // BAD
		}
	}

	mutating func myFunc() {
		guard let userControlledString = try? String(contentsOf: URL(string: "http://example.com/")!) else {
			return
		}

		let tainted1 = [userControlledString]

		p1.arguments = tainted1 // BAD
		p2!.arguments = tainted1 // BAD
		p3.arguments = tainted1 // BAD

		let tainted2 : [String]? = [userControlledString]

		p1.arguments = tainted2 // BAD
		p2!.arguments = tainted2 // BAD
		p3.arguments = tainted2 // BAD

		myValue = tainted2
	}
}
