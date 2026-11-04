package p

func sharedTarget() {} // $ hit

func qualifiedTarget() {} // $ hit[go/test/q1] hit[go/test/q2]

func valuedTarget() {} // $ mark[go/test/q1]=q1 mark[go/test/q2]=q2

func q1Target() {} // $ one[go/test/q1]

func q2Target() {} // $ two[go/test/q2]

func survivingSiblingTarget() {} // $ two[go/test/q2]

func foreignTarget() {} // $ hit hit[go/test/other]

func missingTarget() {} // $ MISSING: absent[go/test/q1] absent[go/test/q2]

func spuriousTarget() {} // $ SPURIOUS: spurious[go/test/q1]

func suppressedSiblingTarget() {} // $ hit[go/test/q2] SPURIOUS: hit[go/test/q1]

func namedMissingTarget() {} // $ hit[go/test/q1] MISSING: hit[go/test/q2]

func namedSpuriousTarget() {} // $ SPURIOUS: hit[go/test/q2]

func noteTarget() {} // $ hit // trailing note
