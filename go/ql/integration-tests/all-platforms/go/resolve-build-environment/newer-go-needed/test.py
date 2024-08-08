import os


def test(check_build_environment, go):
    # the check for resolve build-environment runs after the test and will pick up this environment variable
    os.environ["GOTOOLCHAIN"] = "go1.21.0"
