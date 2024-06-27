var task = Process()
task.launchPath = "/bin/bash"
task.arguments = ["-c", userControlledString] // BAD

task.launch()