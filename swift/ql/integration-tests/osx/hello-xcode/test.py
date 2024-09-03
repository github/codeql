import runs_on
import pytest
import commands


@runs_on.macos
@pytest.mark.ql_test("DB-CHECK", xfail=True)
def test(codeql, swift):
    cmd = ("xcodebuild build "
           "-project codeql-swift-autobuild-test.xcodeproj "
           "-target codeql-swift-autobuild-test "
           "CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO")
    commands.run(
        "du -sh /System/Volumes/Data/Library/Developer/CoreSimulator",
        cmd,
        "du -sh /System/Volumes/Data/Library/Developer/CoreSimulator",
        "xcodebuild clean",
    )
    try:
        codeql.database.create(command=cmd)
    finally:
        commands.run(
            "du -sh /System/Volumes/Data/Library/Developer/CoreSimulator")
