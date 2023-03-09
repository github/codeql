



func winMain() {
	var x = 42
	x = 1 // lgtm
	x = 1 // lgtm[swift/redundant-assignment]
	x = 1 // lgtm[swift/redundant-assignment]
	x = 1 // lgtm[swift/redundant-assignment, swift/redundant-operation]
	x = 1 // lgtm[@tag:nullness]
	x = 1 // lgtm[@tag:nullness,swift/redundant-assignment]
	x = 1 // lgtm[@expires:2017-06-11]
	x = 1 // lgtm[swift/redundant-operation] because I know better than lgtm
	x = 1 // lgtm: blah blah
	x = 1 // lgtm blah blah #falsepositive
	x = 1 //lgtm  [swift/redundant-operation]
	x = 1 /* lgtm */
	x = 1 // lgtm[]
	x = 1 // lgtmfoo
	x = 1 //lgtm
	x = 1 //	lgtm
	x = 1 // lgtm	[swift/redundant-assignment]
	x = 1 // foolgtm[swift/redundant-assignment]
	x = 1 // foolgtm
	x = 1 // foo; lgtm
	x = 1 // foo; lgtm[swift/redundant-assignment]
	x = 1 // foo lgtm
	x = 1 // foo lgtm[swift/redundant-assignment]
	x = 1 // foo lgtm bar
	x = 1 // foo lgtm[swift/redundant-assignment] bar
	x = 1 // LGTM!
	x = 1 // LGTM[swift/redundant-assignment]
	x = 1 // lgtm[swift/redundant-assignment] and lgtm[swift/redundant-operation]
	x = 1 // lgtm[swift/redundant-assignment]; lgtm
	x = 1 /* lgtm[] */
	x = 1 /* lgtm[swift/redundant-assignment] */
	x = 1 /* lgtm
               */
	x = 1 /* lgtm

               */
	x = 1 /* lgtm[@tag:nullness,swift/redundant-assignment] */
	x = 1 /* lgtm[@tag:nullness] */
	// codeql[swift/redundant-assignment]
	x = 1 
	// CODEQL[swift/redundant-assignment]
	x = 1
	// codeql[swift/redundant-assignment] -- because I know better than codeql
	x = 1
	/* codeql[swift/redundant-assignment] */
	x = 1
	/* codeql[swift/redundant-assignment] 
	*/
	x = 1
	x = 1 // codeql[swift/redundant-assignment]	
}	

