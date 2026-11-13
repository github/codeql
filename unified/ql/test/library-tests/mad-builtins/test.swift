// No stubs are declared in this file, so the types below must be resolved via builtins or other means.

class MyProcess: Process {}

func testPropertiesWithoutStubs(
    string: String,
    textField: UITextField,
    configuration: URLSessionConfiguration,
    process: Process,
    myProcess: MyProcess
) {
    _ = textField.text  // $ isSource=local

    configuration.tlsMinimumSupportedProtocolVersion = 0  // $ isSink=tls-protocol-version

    process.launchPath = string  // $ isSink=command-injection
    process.arguments = [string]  // $ isSink=command-injection
    myProcess.arguments = [string]  // $ isSink=command-injection

    let localProcess = Process()
    localProcess.arguments = [string]  // $ isSink=command-injection
}

extension Process {
    func testImplicitSelfSink(string: String) {
        launchPath = string  // $ MISSING: isSink=command-injection
        arguments = [string]  // $ MISSING: isSink=command-injection
        arguments.append(string)  // $ MISSING: isSink=command-injection
    }
}
