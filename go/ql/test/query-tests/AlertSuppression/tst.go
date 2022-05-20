package main

// autoformat-ignore (avoid gofmt changing line-endings, which should be specifically LFs here)

func main() {
	x := 42
	x = x // lgtm
	x = x // lgtm[go/redundant-assignment]
	x = x // lgtm[go/redundant-assignment]
	x = x // lgtm[go/redundant-assignment, go/redundant-operation]
	x = x // lgtm[@tag:nullness]
	x = x // lgtm[@tag:nullness,go/redundant-assignment]
	x = x // lgtm[@expires:2017-06-11]
	x = x // lgtm[go/redundant-operation] because I know better than lgtm
	x = x // lgtm: blah blah
	x = x // lgtm blah blah #falsepositive
	x = x //lgtm  [go/redundant-operation]
	x = x /* lgtm */
	x = x // lgtm[]
	x = x // lgtmfoo
	x = x //lgtm
	x = x //	lgtm
	x = x // lgtm	[go/redundant-assignment]
	x = x // foolgtm[go/redundant-assignment]
	x = x // foolgtm
	x = x // foo; lgtm
	x = x // foo; lgtm[go/redundant-assignment]
	x = x // foo lgtm
	x = x // foo lgtm[go/redundant-assignment]
	x = x // foo lgtm bar
	x = x // foo lgtm[go/redundant-assignment] bar
	x = x // LGTM!
	x = x // LGTM[go/redundant-assignment]
	x = x // lgtm[go/redundant-assignment] and lgtm[go/redundant-operation]
	x = x // lgtm[go/redundant-assignment]; lgtm
	x = x /* lgtm[] */
	x = x /* lgtm[go/redundant-assignment] */
	x = x /* lgtm
               */
	x = x /* lgtm

               */
	x = x /* lgtm[@tag:nullness,go/redundant-assignment] */
	x = x /* lgtm[@tag:nullness] */
}
