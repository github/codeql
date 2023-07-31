
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
	task1.launch() // [FALSE POSITIVE]

	if let validatedString = validateCommand(userControlledString) {
    	let task2 = Process()
    	task2.launchPath = "/bin/bash" // GOOD
    	task2.arguments = ["-c", validatedString] // GOOD [FALSE POSITIVE]
	    task2.launch() // [FALSE POSITIVE]
	}
}

func mkProcess() -> Process? {
	return Process()
}

class MyProcess : Process {
	var harmlessField: String?

	func setArguments(_ arguments: [String]) {
		self.arguments = arguments
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
	try! task3.run() // [FALSE POSITIVE]

	let task4 = Process()
	task4.executableURL = URL(fileURLWithPath: userControlledString) // BAD
	task4.arguments = ["abc", "def" + userControlledString] // BAD
	try! task4.run() // [FALSE POSITIVE]

	let task5 = mkProcess()
	task5?.executableURL = URL(fileURLWithPath: userControlledString) // BAD
	task5?.arguments = [userControlledString] // BAD
	try! task5?.run()

	let task6 = MyProcess()
	task6.executableURL = URL(string: userControlledString)! // BAD [NOT DETECTED]
	task6.arguments = [userControlledString] // BAD [NOT DETECTED]
	task6.setArguments([userControlledString]) // BAD [NOT DETECTED]
	task6.harmlessField = userControlledString // GOOD [FALSE POSITIVE]
	try! task6.run() // [FALSE POSITIVE]

	let task7 = Process()
	task7.executableURL = URL(fileURLWithPath: mySafeString) // GOOD
	task7.arguments = ["abc", "def"]
	task7.arguments?.append(userControlledString) // BAD [NOT DETECTED]
	try! task7.run()

	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", mySafeString]) // GOOD
	_ = Process.launchedProcess(launchPath: userControlledString, arguments: ["abc", mySafeString]) // BAD [NOT DETECTED]
	_ = Process.launchedProcess(launchPath: mySafeString, arguments: ["abc", userControlledString]) // BAD [NOT DETECTED]

	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", mySafeString]) // GOOD
	_ = try? Process.run(URL(string: userControlledString)!, arguments: ["abc", mySafeString]) // BAD [NOT DETECTED]
	_ = try? Process.run(URL(string: mySafeString)!, arguments: ["abc", userControlledString]) // BAD [NOT DETECTED]
}
