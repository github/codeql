package aliases

// Tests how interfaces defining identical types are represented in the database.

type IntAlias = int

type S1 = struct{ x int }
type S2 = struct{ x IntAlias }

type I1 = interface{ F(int) }
type I2 = interface{ F(IntAlias) }
type I3 = interface{ F(S1) }
type I4 = interface{ F(S2) }

func Test1(param1 I1, param2 I3, arg int) {
	param1.F(arg)
	param2.F(S1{arg})
}
