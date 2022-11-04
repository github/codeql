from swift.tools.test.qltest.utils import *

set_dummy_extractor("""
if [[ " $@ " =~ a.swift ]]; then exit 42; fi
if [[ " $@ " =~ b.swift ]]; then exit 1; fi
""")
run_qltest()
assert_extractor_executed_with(
    "a.swift",
    "b.swift",
)
