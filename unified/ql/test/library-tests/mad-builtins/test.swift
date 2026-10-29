// No stubs are declared in this file, so the types below must be resolved via the builtins,
// as is the case when analyzing real code whose dependencies are not extracted.

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
