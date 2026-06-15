func validateCommand(_ command: String) -> String? {
    let allowedCommands = ["ls -l", "pwd", "echo"]
    if allowedCommands.contains(command) {
        return command
    }
    return nil
}

if let validatedString = validateCommand(userControlledString) {
    var task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", validatedString] // GOOD

    task.launch()
}
