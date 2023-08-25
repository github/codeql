func validateCommand(_ command: String) -> String? {
    let allowedCommands = ["ls -l", "pwd", "echo"]
    if allowedCommands.contains(command) {
        return command
    }
    return nil
}

var task = Process()
task.launchPath = "/bin/bash"
task.arguments = ["-c", validateCommand(userControlledString)] // GOOD

task.launch()