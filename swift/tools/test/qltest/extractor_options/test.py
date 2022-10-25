from swift.tools.test.qltest.utils import *

set_dummy_extractor()
run_qltest()
assert_extractor_executed_with(
    "a.swift -some -option-for-a",
    "b.swift -some-other -option-for-b",
)
