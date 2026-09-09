package p

func sharedTarget() {} // $ hit

func valuedTarget() {} // $ mark[go/test/q1]=q1 mark[go/test/q2]=q2

func q1Target() {} // $ one[go/test/q1]

func q2Target() {} // $ two[go/test/q2]

func foreignTarget() {} // $ hit hit[go/test/other]

func missingTarget() {} // $ MISSING: absent[go/test/q1] absent[go/test/q2]

func spuriousTarget() {} // $ SPURIOUS: spurious[go/test/q1]

func noteTarget() {} // $ hit // trailing note
