import TestUIKit
import MyLib

func testInitializers(url: URL, path: String) {
    _ = String(testSource: url)  // $ isSource=remote
    _ = String.init(testSource: url)  // $ isSource=remote
    _ = Swift.String(testSource: url)  // $ isSource=remote
    _ = String(testSource: url, testEncoding: .utf8)  // $ isSource=remote-encoding
    _ = String(url)  // not a source
    _ = String(testSink: path)  // $ isSink=path-injection
    _ = String.Index(testOffset: 0)  // $ isSink=string-length
}

func testTypeModels() {
    let fm = FileManager.default
    _ = fm.contents(atPath: "x")  // $ isSource=local
    _ = FileManager.default.contents(atPath: "y")  // $ isSource=local
    _ = TestFoundation.FileManager.default.contents(atPath: "z")  // $ isSource=local
    _ = FileManager.contents(atPath: "w")  // not a source (static access)
}

func testAnnotations(fm: FileManager, fm2: FileManager?, fm3: FileManager!) {
    _ = fm.contents(atPath: "x")  // $ isSource=local
    _ = fm2?.contents(atPath: "x")  // $ isSource=local
    _ = fm2!.contents(atPath: "x")  // $ isSource=local
    let fm4 = fm2
    _ = fm4?.contents(atPath: "x")  // $ isSource=local
    _ = (fm as! FileManager).contents(atPath: "x")  // $ isSource=local
}

func testProperties(tf: UITextField, conf: URLSessionConfiguration) {
    _ = tf.text  // $ isSource=local
    tf.text = ""  // not a source
    conf.tlsMinimumSupportedProtocol = 0  // $ isSink=tls
    _ = conf.tlsMinimumSupportedProtocol  // not a sink
}

class MyDelegate: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String  // $ isSource=local
    ) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, replacementString string: String) {}  // not a source
}

class MyProcess: Process {
    var harmless: String = ""

    func setup(x: String) {
        arguments = [x]  // $ isSink=command-injection
        self.arguments = [x]  // $ isSink=command-injection
        harmless = x  // not a sink
    }
}

class MyProcess2: MyProcess {}

func makeProcess() -> Process? {
    return Process()
}

struct ProcessHolder {
    let p: Process
}

func testSubclasses(holder: ProcessHolder) {
    let p = MyProcess()
    p.arguments = ["a"]  // $ isSink=command-injection
    MyProcess2().arguments = ["a"]  // $ isSink=command-injection
    makeProcess()?.arguments = ["a"]  // $ isSink=command-injection
    holder.p.arguments = ["a"]  // $ MISSING: isSink=command-injection
    let p2 = Process()
    p2.arguments = ["b"]  // $ isSink=command-injection
    try! p2.run()  // $ isSink=receiver
}

func testCallbacks(session: URLSession, url: URL) {
    session.dataTask(with: url, completionHandler: { data, response, error in  // $ isSource=remote
    })
    let handler = { (data: Data?, response: URLResponse?, error: Error?) in  // $ isSource=remote
    }
    session.dataTask(with: url, completionHandler: handler)
    session.dataTask(with: url) { data, response, error in  // $ MISSING: isSource=remote
    }
}

func testStubs(b: Builder) {
    let obj = StubClass()
    obj.sink(arg: "x")  // $ isSink=stub
    StubClass.make().sink(arg: "y")  // $ isSink=stub
    MyLib.StubClass().sink(arg: "z")  // $ isSink=stub
    b.withFoo().withBar().run(cmd: "x")  // $ isSink=builder
    b.run(cmd: "y")  // $ isSink=builder
}

func testModuleMembers() {
    _ = getRemoteData()  // $ isSource=remote
    NSLog("x")  // $ isSink=log-injection
}

func testShadowing() {
    func NSLog(_ s: String) {}
    NSLog("x")  // not a sink (local function)
}
