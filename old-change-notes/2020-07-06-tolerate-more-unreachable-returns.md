lgtm,codescanning
* The query "Unreachable statement" (`go/unreachable-statement`) now tolerates more unreachable return statements, which can often be required in Go following a function call that cannot return. Newly tolerated statements include `return true`, `return MyStruct{0, true}`, and any return when the return value has type `error`. This eliminates some nuisance results.
