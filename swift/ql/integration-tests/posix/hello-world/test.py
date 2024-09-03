import runs_on
import commands


@runs_on.posix
def test(codeql, swift):
    commands.run(
        "du -sh /System/Volumes/Data/Library/Developer/CoreSimulator",
        "swift build",
        "du -sh /System/Volumes/Data/Library/Developer/CoreSimulator",
        "swift package clean",
    )
    try:
        codeql.database.create(command="swift build")
    finally:
        commands.run("du -sh /System/Volumes/Data/Library/Developer/CoreSimulator")
