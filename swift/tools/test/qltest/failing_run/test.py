from swift.tools.test.qltest.utils import *

set_dummy_extractor('if [[ " $@ " =~ b.swift ]]; then exit 1; fi')
run_qltest(expected_returncode=1)
assert_extractor_executed_with(
    "a.swift",
    "b.swift",
    "c.swift",
)
