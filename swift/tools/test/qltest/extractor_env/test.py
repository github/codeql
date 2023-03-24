from swift.tools.test.qltest.utils import *

set_dummy_extractor('''
set -x

if [[ " $@ " =~ a.swift ]]; then 
    [[ "$VAR1" == "foo" && "$VAR2" == "" ]] || exit 1
elif [[ " $@ " =~ b.swift ]]; then
    [[ "$VAR1" == "bar" && "$VAR2" == "baz" ]] || exit 1
fi
''')
run_qltest()
assert_extractor_executed_with(
    "a.swift",
    "b.swift",
)
