package js

import (
	"bytes"
	"encoding/hex"

	"github.com/tdewolff/minify/v2"
	"github.com/tdewolff/parse/v2/js"
	"github.com/tdewolff/parse/v2/strconv"
)

var (
	spaceBytes                 = []byte(" ")
	newlineBytes               = []byte("\n")
	starBytes                  = []byte("*")
	colonBytes                 = []byte(":")
	semicolonBytes             = []byte(";")
	commaBytes                 = []byte(",")
	dotBytes                   = []byte(".")
	ellipsisBytes              = []byte("...")
	openBraceBytes             = []byte("{")
	closeBraceBytes            = []byte("}")
	openParenBytes             = []byte("(")
	closeParenBytes            = []byte(")")
	openBracketBytes           = []byte("[")
	closeBracketBytes          = []byte("]")
	openParenBracketBytes      = []byte("({")
	closeParenOpenBracketBytes = []byte("){")
	notBytes                   = []byte("!")
	questionBytes              = []byte("?")
	equalBytes                 = []byte("=")
	optChainBytes              = []byte("?.")
	arrowBytes                 = []byte("=>")
	zeroBytes                  = []byte("0")
	oneBytes                   = []byte("1")
	letBytes                   = []byte("let")
	getBytes                   = []byte("get")
	setBytes                   = []byte("set")
	asyncBytes                 = []byte("async")
	functionBytes              = []byte("function")
	staticBytes                = []byte("static")
	ifOpenBytes                = []byte("if(")
	elseBytes                  = []byte("else")
	withOpenBytes              = []byte("with(")
	doBytes                    = []byte("do")
	whileOpenBytes             = []byte("while(")
	forOpenBytes               = []byte("for(")
	forAwaitOpenBytes          = []byte("for await(")
	inBytes                    = []byte("in")
	ofBytes                    = []byte("of")
	switchOpenBytes            = []byte("switch(")
	throwBytes                 = []byte("throw")
	tryBytes                   = []byte("try")
	catchBytes                 = []byte("catch")
	finallyBytes               = []byte("finally")
	importBytes                = []byte("import")
	exportBytes                = []byte("export")
	fromBytes                  = []byte("from")
	returnBytes                = []byte("return")
	classBytes                 = []byte("class")
	asSpaceBytes               = []byte("as ")
	asyncSpaceBytes            = []byte("async ")
	spaceDefaultBytes          = []byte(" default")
	spaceExtendsBytes          = []byte(" extends")
	yieldBytes                 = []byte("yield")
	newBytes                   = []byte("new")
	openNewBytes               = []byte("(new")
	newTargetBytes             = []byte("new.target")
	importMetaBytes            = []byte("import.meta")
	nanBytes                   = []byte("NaN")
	undefinedBytes             = []byte("undefined")
	infinityBytes              = []byte("Infinity")
	nullBytes                  = []byte("null")
	voidZeroBytes              = []byte("void 0")
	groupedVoidZeroBytes       = []byte("(void 0)")
	oneDivZeroBytes            = []byte("1/0")
	groupedOneDivZeroBytes     = []byte("(1/0)")
	notZeroBytes               = []byte("!0")
	groupedNotZeroBytes        = []byte("(!0)")
	notOneBytes                = []byte("!1")
	groupedNotOneBytes         = []byte("(!1)")
	debuggerBytes              = []byte("debugger")
	regExpScriptBytes          = []byte("/script>")
)

func isEmptyStmt(stmt js.IStmt) bool {
	if stmt == nil {
		return true
	} else if _, ok := stmt.(*js.EmptyStmt); ok {
		return true
	} else if decl, ok := stmt.(*js.VarDecl); ok && decl.TokenType == js.ErrorToken {
		for _, item := range decl.List {
			if item.Default != nil {
				return false
			}
		}
		return true
	} else if block, ok := stmt.(*js.BlockStmt); ok {
		for _, item := range block.List {
			if ok := isEmptyStmt(item); !ok {
				return false
			}
		}
		return true
	}
	return false
}

func isFlowStmt(stmt js.IStmt) bool {
	if _, ok := stmt.(*js.ReturnStmt); ok {
		return true
	} else if _, ok := stmt.(*js.ThrowStmt); ok {
		return true
	} else if _, ok := stmt.(*js.BranchStmt); ok {
		return true
	}
	return false
}

func lastStmt(stmt js.IStmt) js.IStmt {
	if block, ok := stmt.(*js.BlockStmt); ok && 0 < len(block.List) {
		return lastStmt(block.List[len(block.List)-1])
	}
	return stmt
}

func endsInIf(istmt js.IStmt) bool {
	switch stmt := istmt.(type) {
	case *js.IfStmt:
		if stmt.Else == nil {
			_, ok := optimizeStmt(stmt).(*js.IfStmt)
			return ok
		}
		return endsInIf(stmt.Else)
	case *js.BlockStmt:
		if 0 < len(stmt.List) {
			return endsInIf(stmt.List[len(stmt.List)-1])
		}
	case *js.LabelledStmt:
		return endsInIf(stmt.Value)
	case *js.WithStmt:
		return endsInIf(stmt.Body)
	case *js.WhileStmt:
		return endsInIf(stmt.Body)
	case *js.ForStmt:
		return endsInIf(stmt.Body)
	case *js.ForInStmt:
		return endsInIf(stmt.Body)
	case *js.ForOfStmt:
		return endsInIf(stmt.Body)
	}
	return false
}

// precedence maps for the precedence inside the operation
var unaryPrecMap = map[js.TokenType]js.OpPrec{
	js.PostIncrToken: js.OpLHS,
	js.PostDecrToken: js.OpLHS,
	js.PreIncrToken:  js.OpUnary,
	js.PreDecrToken:  js.OpUnary,
	js.NotToken:      js.OpUnary,
	js.BitNotToken:   js.OpUnary,
	js.TypeofToken:   js.OpUnary,
	js.VoidToken:     js.OpUnary,
	js.DeleteToken:   js.OpUnary,
	js.PosToken:      js.OpUnary,
	js.NegToken:      js.OpUnary,
	js.AwaitToken:    js.OpUnary,
}

var binaryLeftPrecMap = map[js.TokenType]js.OpPrec{
	js.EqToken:         js.OpLHS,
	js.MulEqToken:      js.OpLHS,
	js.DivEqToken:      js.OpLHS,
	js.ModEqToken:      js.OpLHS,
	js.ExpEqToken:      js.OpLHS,
	js.AddEqToken:      js.OpLHS,
	js.SubEqToken:      js.OpLHS,
	js.LtLtEqToken:     js.OpLHS,
	js.GtGtEqToken:     js.OpLHS,
	js.GtGtGtEqToken:   js.OpLHS,
	js.BitAndEqToken:   js.OpLHS,
	js.BitXorEqToken:   js.OpLHS,
	js.BitOrEqToken:    js.OpLHS,
	js.ExpToken:        js.OpUpdate,
	js.MulToken:        js.OpMul,
	js.DivToken:        js.OpMul,
	js.ModToken:        js.OpMul,
	js.AddToken:        js.OpAdd,
	js.SubToken:        js.OpAdd,
	js.LtLtToken:       js.OpShift,
	js.GtGtToken:       js.OpShift,
	js.GtGtGtToken:     js.OpShift,
	js.LtToken:         js.OpCompare,
	js.LtEqToken:       js.OpCompare,
	js.GtToken:         js.OpCompare,
	js.GtEqToken:       js.OpCompare,
	js.InToken:         js.OpCompare,
	js.InstanceofToken: js.OpCompare,
	js.EqEqToken:       js.OpEquals,
	js.NotEqToken:      js.OpEquals,
	js.EqEqEqToken:     js.OpEquals,
	js.NotEqEqToken:    js.OpEquals,
	js.BitAndToken:     js.OpBitAnd,
	js.BitXorToken:     js.OpBitXor,
	js.BitOrToken:      js.OpBitOr,
	js.AndToken:        js.OpAnd,
	js.OrToken:         js.OpOr,
	js.NullishToken:    js.OpBitOr, // or OpCoalesce
	js.CommaToken:      js.OpExpr,
}

var binaryRightPrecMap = map[js.TokenType]js.OpPrec{
	js.EqToken:         js.OpAssign,
	js.MulEqToken:      js.OpAssign,
	js.DivEqToken:      js.OpAssign,
	js.ModEqToken:      js.OpAssign,
	js.ExpEqToken:      js.OpAssign,
	js.AddEqToken:      js.OpAssign,
	js.SubEqToken:      js.OpAssign,
	js.LtLtEqToken:     js.OpAssign,
	js.GtGtEqToken:     js.OpAssign,
	js.GtGtGtEqToken:   js.OpAssign,
	js.BitAndEqToken:   js.OpAssign,
	js.BitXorEqToken:   js.OpAssign,
	js.BitOrEqToken:    js.OpAssign,
	js.ExpToken:        js.OpExp,
	js.MulToken:        js.OpExp,
	js.DivToken:        js.OpExp,
	js.ModToken:        js.OpExp,
	js.AddToken:        js.OpMul,
	js.SubToken:        js.OpMul,
	js.LtLtToken:       js.OpAdd,
	js.GtGtToken:       js.OpAdd,
	js.GtGtGtToken:     js.OpAdd,
	js.LtToken:         js.OpShift,
	js.LtEqToken:       js.OpShift,
	js.GtToken:         js.OpShift,
	js.GtEqToken:       js.OpShift,
	js.InToken:         js.OpShift,
	js.InstanceofToken: js.OpShift,
	js.EqEqToken:       js.OpCompare,
	js.NotEqToken:      js.OpCompare,
	js.EqEqEqToken:     js.OpCompare,
	js.NotEqEqToken:    js.OpCompare,
	js.BitAndToken:     js.OpEquals,
	js.BitXorToken:     js.OpBitAnd,
	js.BitOrToken:      js.OpBitXor,
	js.AndToken:        js.OpAnd,   // changes order in AST but not in execution
	js.OrToken:         js.OpOr,    // changes order in AST but not in execution
	js.NullishToken:    js.OpBitOr, // or OpCoalesce
	js.CommaToken:      js.OpAssign,
}

// precedence maps of the operation itself
var unaryOpPrecMap = map[js.TokenType]js.OpPrec{
	js.PostIncrToken: js.OpUpdate,
	js.PostDecrToken: js.OpUpdate,
	js.PreIncrToken:  js.OpUpdate,
	js.PreDecrToken:  js.OpUpdate,
	js.NotToken:      js.OpUnary,
	js.BitNotToken:   js.OpUnary,
	js.TypeofToken:   js.OpUnary,
	js.VoidToken:     js.OpUnary,
	js.DeleteToken:   js.OpUnary,
	js.PosToken:      js.OpUnary,
	js.NegToken:      js.OpUnary,
	js.AwaitToken:    js.OpUnary,
}

var binaryOpPrecMap = map[js.TokenType]js.OpPrec{
	js.EqToken:         js.OpAssign,
	js.MulEqToken:      js.OpAssign,
	js.DivEqToken:      js.OpAssign,
	js.ModEqToken:      js.OpAssign,
	js.ExpEqToken:      js.OpAssign,
	js.AddEqToken:      js.OpAssign,
	js.SubEqToken:      js.OpAssign,
	js.LtLtEqToken:     js.OpAssign,
	js.GtGtEqToken:     js.OpAssign,
	js.GtGtGtEqToken:   js.OpAssign,
	js.BitAndEqToken:   js.OpAssign,
	js.BitXorEqToken:   js.OpAssign,
	js.BitOrEqToken:    js.OpAssign,
	js.ExpToken:        js.OpExp,
	js.MulToken:        js.OpMul,
	js.DivToken:        js.OpMul,
	js.ModToken:        js.OpMul,
	js.AddToken:        js.OpAdd,
	js.SubToken:        js.OpAdd,
	js.LtLtToken:       js.OpShift,
	js.GtGtToken:       js.OpShift,
	js.GtGtGtToken:     js.OpShift,
	js.LtToken:         js.OpCompare,
	js.LtEqToken:       js.OpCompare,
	js.GtToken:         js.OpCompare,
	js.GtEqToken:       js.OpCompare,
	js.InToken:         js.OpCompare,
	js.InstanceofToken: js.OpCompare,
	js.EqEqToken:       js.OpEquals,
	js.NotEqToken:      js.OpEquals,
	js.EqEqEqToken:     js.OpEquals,
	js.NotEqEqToken:    js.OpEquals,
	js.BitAndToken:     js.OpBitAnd,
	js.BitXorToken:     js.OpBitXor,
	js.BitOrToken:      js.OpBitOr,
	js.AndToken:        js.OpAnd,
	js.OrToken:         js.OpOr,
	js.NullishToken:    js.OpCoalesce,
	js.CommaToken:      js.OpExpr,
}

func exprPrec(i js.IExpr) js.OpPrec {
	switch expr := i.(type) {
	case *js.Var, *js.LiteralExpr, *js.ArrayExpr, *js.ObjectExpr, *js.FuncDecl, *js.ClassDecl:
		return js.OpPrimary
	case *js.UnaryExpr:
		return unaryOpPrecMap[expr.Op]
	case *js.BinaryExpr:
		return binaryOpPrecMap[expr.Op]
	case *js.NewExpr:
		if expr.Args == nil {
			return js.OpNew
		}
		return js.OpMember
	case *js.TemplateExpr:
		if expr.Tag == nil {
			return js.OpPrimary
		}
		return expr.Prec
	case *js.DotExpr:
		return expr.Prec
	case *js.IndexExpr:
		return expr.Prec
	case *js.NewTargetExpr, *js.ImportMetaExpr:
		return js.OpMember
	case *js.CallExpr:
		return js.OpCall
	case *js.CondExpr, *js.YieldExpr, *js.ArrowFunc:
		return js.OpAssign
	case *js.GroupExpr:
		return exprPrec(expr.X)
	}
	return js.OpExpr // CommaExpr
}

func hasSideEffects(i js.IExpr) bool {
	// assume that variable usage and that the index operator themselves have no side effects
	switch expr := i.(type) {
	case *js.Var, *js.LiteralExpr, *js.FuncDecl, *js.ClassDecl, *js.ArrowFunc, *js.NewTargetExpr, *js.ImportMetaExpr:
		return false
	case *js.NewExpr, *js.CallExpr, *js.YieldExpr:
		return true
	case *js.GroupExpr:
		return hasSideEffects(expr.X)
	case *js.DotExpr:
		return hasSideEffects(expr.X)
	case *js.IndexExpr:
		return hasSideEffects(expr.X) || hasSideEffects(expr.Y)
	case *js.CondExpr:
		return hasSideEffects(expr.Cond) || hasSideEffects(expr.X) || hasSideEffects(expr.Y)
	case *js.CommaExpr:
		for _, item := range expr.List {
			if hasSideEffects(item) {
				return true
			}
		}
	case *js.ArrayExpr:
		for _, item := range expr.List {
			if hasSideEffects(item.Value) {
				return true
			}
		}
		return false
	case *js.ObjectExpr:
		for _, item := range expr.List {
			if hasSideEffects(item.Value) || item.Init != nil && hasSideEffects(item.Init) || item.Name != nil && item.Name.IsComputed() && hasSideEffects(item.Name.Computed) {
				return true
			}
		}
		return false
	case *js.TemplateExpr:
		if hasSideEffects(expr.Tag) {
			return true
		}
		for _, item := range expr.List {
			if hasSideEffects(item.Expr) {
				return true
			}
		}
		return false
	case *js.UnaryExpr:
		if expr.Op == js.DeleteToken || expr.Op == js.PreIncrToken || expr.Op == js.PreDecrToken || expr.Op == js.PostIncrToken || expr.Op == js.PostDecrToken {
			return true
		}
		return hasSideEffects(expr.X)
	case *js.BinaryExpr:
		return binaryOpPrecMap[expr.Op] == js.OpAssign
	}
	return true
}

// TODO: use in more cases
func groupExpr(i js.IExpr, prec js.OpPrec) js.IExpr {
	precInside := exprPrec(i)
	if _, ok := i.(*js.GroupExpr); !ok && precInside < prec && (precInside != js.OpCoalesce || prec != js.OpBitOr) {
		return &js.GroupExpr{X: i}
	}
	return i
}

// TODO: use in more cases
func condExpr(cond, x, y js.IExpr) js.IExpr {
	if comma, ok := cond.(*js.CommaExpr); ok {
		comma.List[len(comma.List)-1] = &js.CondExpr{
			Cond: groupExpr(comma.List[len(comma.List)-1], js.OpCoalesce),
			X:    groupExpr(x, js.OpAssign),
			Y:    groupExpr(y, js.OpAssign),
		}
		return comma
	}
	return &js.CondExpr{
		Cond: groupExpr(cond, js.OpCoalesce),
		X:    groupExpr(x, js.OpAssign),
		Y:    groupExpr(y, js.OpAssign),
	}
}

func commaExpr(x, y js.IExpr) js.IExpr {
	comma, ok := x.(*js.CommaExpr)
	if !ok {
		comma = &js.CommaExpr{List: []js.IExpr{x}}
	}
	if comma2, ok := y.(*js.CommaExpr); ok {
		comma.List = append(comma.List, comma2.List...)
	} else {
		comma.List = append(comma.List, y)
	}
	return comma
}

func innerExpr(i js.IExpr) js.IExpr {
	for {
		if group, ok := i.(*js.GroupExpr); ok {
			i = group.X
		} else {
			return i
		}
	}
}

func finalExpr(i js.IExpr) js.IExpr {
	i = innerExpr(i)
	if comma, ok := i.(*js.CommaExpr); ok {
		i = comma.List[len(comma.List)-1]
	}
	if binary, ok := i.(*js.BinaryExpr); ok && binary.Op == js.EqToken {
		i = binary.X // return first
	}
	return i
}

func isTrue(i js.IExpr) bool {
	i = innerExpr(i)
	if lit, ok := i.(*js.LiteralExpr); ok && lit.TokenType == js.TrueToken {
		return true
	} else if unary, ok := i.(*js.UnaryExpr); ok && unary.Op == js.NotToken {
		ret, _ := isFalsy(unary.X)
		return ret
	}
	return false
}

func isFalse(i js.IExpr) bool {
	i = innerExpr(i)
	if lit, ok := i.(*js.LiteralExpr); ok {
		return lit.TokenType == js.FalseToken
	} else if unary, ok := i.(*js.UnaryExpr); ok && unary.Op == js.NotToken {
		ret, _ := isTruthy(unary.X)
		return ret
	}
	return false
}

func isEqualExpr(a, b js.IExpr) bool {
	a = innerExpr(a)
	b = innerExpr(b)
	if left, ok := a.(*js.Var); ok {
		if right, ok := b.(*js.Var); ok {
			return bytes.Equal(left.Name(), right.Name())
		}
	}
	// TODO: use reflect.DeepEqual?
	return false
}

func toNullishExpr(condExpr *js.CondExpr) (js.IExpr, bool) {
	if v, not, ok := isUndefinedOrNullVar(condExpr.Cond); ok {
		left, right := condExpr.X, condExpr.Y
		if not {
			left, right = right, left
		}
		if isEqualExpr(v, right) {
			// convert conditional expression to nullish:  a==null?b:a  =>  a??b
			return &js.BinaryExpr{js.NullishToken, groupExpr(right, binaryLeftPrecMap[js.NullishToken]), groupExpr(left, binaryRightPrecMap[js.NullishToken])}, true
		} else if isUndefined(left) {
			// convert conditional expression to optional expr:  a==null?undefined:a.b  =>  a?.b
			expr := right
			var parent js.IExpr
			for {
				prevExpr := expr
				if callExpr, ok := expr.(*js.CallExpr); ok {
					expr = callExpr.X
				} else if dotExpr, ok := expr.(*js.DotExpr); ok {
					expr = dotExpr.X
				} else if indexExpr, ok := expr.(*js.IndexExpr); ok {
					expr = indexExpr.X
				} else if templateExpr, ok := expr.(*js.TemplateExpr); ok {
					expr = templateExpr.Tag
				} else {
					break
				}
				parent = prevExpr
			}
			if parent != nil && isEqualExpr(v, expr) {
				if callExpr, ok := parent.(*js.CallExpr); ok {
					callExpr.Optional = true
				} else if dotExpr, ok := parent.(*js.DotExpr); ok {
					dotExpr.Optional = true
				} else if indexExpr, ok := parent.(*js.IndexExpr); ok {
					indexExpr.Optional = true
				} else if templateExpr, ok := parent.(*js.TemplateExpr); ok {
					templateExpr.Optional = true
				}
				return right, true
			}
		}
	}
	return nil, false
}

func isUndefinedOrNullVar(i js.IExpr) (*js.Var, bool, bool) {
	i = innerExpr(i)
	if binary, ok := i.(*js.BinaryExpr); ok && (binary.Op == js.OrToken || binary.Op == js.AndToken) {
		eqEqOp := js.EqEqToken
		eqEqEqOp := js.EqEqEqToken
		if binary.Op == js.AndToken {
			eqEqOp = js.NotEqToken
			eqEqEqOp = js.NotEqEqToken
		}

		left, isBinaryX := innerExpr(binary.X).(*js.BinaryExpr)
		right, isBinaryY := innerExpr(binary.Y).(*js.BinaryExpr)
		if isBinaryX && isBinaryY && (left.Op == eqEqOp || left.Op == eqEqEqOp) && (right.Op == eqEqOp || right.Op == eqEqEqOp) {
			var leftVar, rightVar *js.Var
			if v, ok := left.X.(*js.Var); ok && isUndefinedOrNull(left.Y) {
				leftVar = v
			} else if v, ok := left.Y.(*js.Var); ok && isUndefinedOrNull(left.X) {
				leftVar = v
			}
			if v, ok := right.X.(*js.Var); ok && isUndefinedOrNull(right.Y) {
				rightVar = v
			} else if v, ok := right.Y.(*js.Var); ok && isUndefinedOrNull(right.X) {
				rightVar = v
			}
			if leftVar != nil && leftVar == rightVar {
				return leftVar, binary.Op == js.AndToken, true
			}
		}
	} else if ok && (binary.Op == js.EqEqToken || binary.Op == js.NotEqToken) {
		var variable *js.Var
		if v, ok := binary.X.(*js.Var); ok && isUndefinedOrNull(binary.Y) {
			variable = v
		} else if v, ok := binary.Y.(*js.Var); ok && isUndefinedOrNull(binary.X) {
			variable = v
		}
		if variable != nil {
			return variable, binary.Op == js.NotEqToken, true
		}
	}
	return nil, false, false
}

func isUndefinedOrNull(i js.IExpr) bool {
	i = innerExpr(i)
	if lit, ok := i.(*js.LiteralExpr); ok {
		return lit.TokenType == js.NullToken
	}
	return isUndefined(i)
}

func isUndefined(i js.IExpr) bool {
	i = innerExpr(i)
	if v, ok := i.(*js.Var); ok {
		if bytes.Equal(v.Name(), undefinedBytes) { // TODO: only if not defined
			return true
		}
	} else if unary, ok := i.(*js.UnaryExpr); ok && unary.Op == js.VoidToken {
		return !hasSideEffects(unary.X)
	}
	return false
}

// returns whether truthy and whether it could be coerced to a boolean (i.e. when returns (false,true) this means it is falsy)
func isTruthy(i js.IExpr) (bool, bool) {
	if falsy, ok := isFalsy(i); ok {
		return !falsy, true
	}
	return false, false
}

// returns whether falsy and whether it could be coerced to a boolean (i.e. when returns (false,true) this means it is truthy)
func isFalsy(i js.IExpr) (bool, bool) {
	negated := false
	group, isGroup := i.(*js.GroupExpr)
	unary, isUnary := i.(*js.UnaryExpr)
	for isGroup || isUnary && unary.Op == js.NotToken {
		if isGroup {
			i = group.X
		} else {
			i = unary.X
			negated = !negated
		}
		group, isGroup = i.(*js.GroupExpr)
		unary, isUnary = i.(*js.UnaryExpr)
	}
	if lit, ok := i.(*js.LiteralExpr); ok {
		tt := lit.TokenType
		d := lit.Data
		if tt == js.FalseToken || tt == js.NullToken || tt == js.StringToken && len(lit.Data) == 0 {
			return !negated, true // falsy
		} else if tt == js.TrueToken || tt == js.StringToken {
			return negated, true // truthy
		} else if tt == js.DecimalToken || tt == js.BinaryToken || tt == js.OctalToken || tt == js.HexadecimalToken || tt == js.BigIntToken {
			for _, c := range d {
				if c == 'e' || c == 'E' || c == 'n' {
					break
				} else if c != '0' && c != '.' && c != 'x' && c != 'X' && c != 'b' && c != 'B' && c != 'o' && c != 'O' {
					return negated, true // truthy
				}
			}
			return !negated, true // falsy
		}
	} else if isUndefined(i) {
		return !negated, true // falsy
	} else if v, ok := i.(*js.Var); ok && bytes.Equal(v.Name(), nanBytes) {
		return !negated, true // falsy
	}
	return false, false // unknown
}

func isBooleanExpr(expr js.IExpr) bool {
	if unaryExpr, ok := expr.(*js.UnaryExpr); ok {
		return unaryExpr.Op == js.NotToken
	} else if binaryExpr, ok := expr.(*js.BinaryExpr); ok {
		op := binaryOpPrecMap[binaryExpr.Op]
		if op == js.OpAnd || op == js.OpOr {
			return isBooleanExpr(binaryExpr.X) && isBooleanExpr(binaryExpr.Y)
		}
		return op == js.OpCompare || op == js.OpEquals
	} else if litExpr, ok := expr.(*js.LiteralExpr); ok {
		return litExpr.TokenType == js.TrueToken || litExpr.TokenType == js.FalseToken
	} else if groupExpr, ok := expr.(*js.GroupExpr); ok {
		return isBooleanExpr(groupExpr.X)
	}
	return false
}

func invertBooleanOp(op js.TokenType) js.TokenType {
	if op == js.EqEqToken {
		return js.NotEqToken
	} else if op == js.NotEqToken {
		return js.EqEqToken
	} else if op == js.EqEqEqToken {
		return js.NotEqEqToken
	} else if op == js.NotEqEqToken {
		return js.EqEqEqToken
	}
	return js.ErrorToken
}

func optimizeBooleanExpr(expr js.IExpr, invert bool, prec js.OpPrec) js.IExpr {
	if invert {
		// unary !(boolean) has already been handled
		if binaryExpr, ok := expr.(*js.BinaryExpr); ok && binaryOpPrecMap[binaryExpr.Op] == js.OpEquals {
			binaryExpr.Op = invertBooleanOp(binaryExpr.Op)
			return expr
		} else {
			return optimizeUnaryExpr(&js.UnaryExpr{js.NotToken, groupExpr(expr, js.OpUnary)}, prec)
		}
	} else if isBooleanExpr(expr) {
		return groupExpr(expr, prec)
	} else {
		return &js.UnaryExpr{js.NotToken, &js.UnaryExpr{js.NotToken, groupExpr(expr, js.OpUnary)}}
	}
}

func optimizeUnaryExpr(expr *js.UnaryExpr, prec js.OpPrec) js.IExpr {
	if expr.Op == js.NotToken {
		invert := true
		var expr2 js.IExpr = expr.X
		for {
			if unary, ok := expr2.(*js.UnaryExpr); ok && unary.Op == js.NotToken {
				invert = !invert
				expr2 = unary.X
			} else if group, ok := expr2.(*js.GroupExpr); ok {
				expr2 = group.X
			} else {
				break
			}
		}
		if !invert && isBooleanExpr(expr2) {
			return groupExpr(expr2, prec)
		} else if binary, ok := expr2.(*js.BinaryExpr); ok && invert {
			if binaryOpPrecMap[binary.Op] == js.OpEquals {
				binary.Op = invertBooleanOp(binary.Op)
				return groupExpr(binary, prec)
			} else if binary.Op == js.AndToken || binary.Op == js.OrToken {
				op := js.AndToken
				if binary.Op == js.AndToken {
					op = js.OrToken
				}
				precInside := binaryOpPrecMap[op]
				needsGroup := precInside < prec && (precInside != js.OpCoalesce || prec != js.OpBitOr)

				// rewrite !(a||b) to !a&&!b
				// rewrite !(a==0||b==0) to a!=0&&b!=0
				score := 3 // savings if rewritten (group parentheses and not-token)
				if needsGroup {
					score -= 2
				}
				score -= 2 // add two not-tokens for left and right

				// == and === can become != and !==
				var isEqX, isEqY bool
				if binaryExpr, ok := binary.X.(*js.BinaryExpr); ok && binaryOpPrecMap[binaryExpr.Op] == js.OpEquals {
					score += 1
					isEqX = true
				}
				if binaryExpr, ok := binary.Y.(*js.BinaryExpr); ok && binaryOpPrecMap[binaryExpr.Op] == js.OpEquals {
					score += 1
					isEqY = true
				}

				// add group if it wasn't already there
				var needsGroupX, needsGroupY bool
				if !isEqX && binaryLeftPrecMap[binary.Op] <= exprPrec(binary.X) && exprPrec(binary.X) < js.OpUnary {
					score -= 2
					needsGroupX = true
				}
				if !isEqY && binaryRightPrecMap[binary.Op] <= exprPrec(binary.Y) && exprPrec(binary.Y) < js.OpUnary {
					score -= 2
					needsGroupY = true
				}

				// remove group
				if op == js.OrToken {
					if exprPrec(binary.X) == js.OpOr {
						score += 2
					}
					if exprPrec(binary.Y) == js.OpAnd {
						score += 2
					}
				}

				if 0 < score {
					binary.Op = op
					if isEqX {
						binary.X.(*js.BinaryExpr).Op = invertBooleanOp(binary.X.(*js.BinaryExpr).Op)
					}
					if isEqY {
						binary.Y.(*js.BinaryExpr).Op = invertBooleanOp(binary.Y.(*js.BinaryExpr).Op)
					}
					if needsGroupX {
						binary.X = &js.GroupExpr{binary.X}
					}
					if needsGroupY {
						binary.Y = &js.GroupExpr{binary.Y}
					}
					if !isEqX {
						binary.X = &js.UnaryExpr{js.NotToken, binary.X}
					}
					if !isEqY {
						binary.Y = &js.UnaryExpr{js.NotToken, binary.Y}
					}
					if needsGroup {
						return &js.GroupExpr{binary}
					}
					return binary
				}
			}
		}
	}
	return expr
}

func (m *jsMinifier) optimizeCondExpr(expr *js.CondExpr, prec js.OpPrec) js.IExpr {
	// remove double negative !! in condition, or switch cases for single negative !
	if unary1, ok := expr.Cond.(*js.UnaryExpr); ok && unary1.Op == js.NotToken {
		if unary2, ok := unary1.X.(*js.UnaryExpr); ok && unary2.Op == js.NotToken {
			if isBooleanExpr(unary2.X) {
				expr.Cond = unary2.X
			}
		} else {
			expr.Cond = unary1.X
			expr.X, expr.Y = expr.Y, expr.X
		}
	}

	finalCond := finalExpr(expr.Cond)
	if truthy, ok := isTruthy(expr.Cond); truthy && ok {
		// if condition is truthy
		return expr.X
	} else if !truthy && ok {
		// if condition is falsy
		return expr.Y
	} else if isEqualExpr(finalCond, expr.X) && (exprPrec(finalCond) < js.OpAssign || binaryLeftPrecMap[js.OrToken] <= exprPrec(finalCond)) && (exprPrec(expr.Y) < js.OpAssign || binaryRightPrecMap[js.OrToken] <= exprPrec(expr.Y)) {
		// if condition is equal to true body
		// for higher prec we need to add group parenthesis, and for lower prec we have parenthesis anyways. This only is shorter if len(expr.X) >= 3. isEqualExpr only checks for literal variables, which is a name will be minified to a one or two character name.
		return &js.BinaryExpr{js.OrToken, groupExpr(expr.Cond, binaryLeftPrecMap[js.OrToken]), expr.Y}
	} else if isEqualExpr(finalCond, expr.Y) && (exprPrec(finalCond) < js.OpAssign || binaryLeftPrecMap[js.AndToken] <= exprPrec(finalCond)) && (exprPrec(expr.X) < js.OpAssign || binaryRightPrecMap[js.AndToken] <= exprPrec(expr.X)) {
		// if condition is equal to false body
		// for higher prec we need to add group parenthesis, and for lower prec we have parenthesis anyways. This only is shorter if len(expr.X) >= 3. isEqualExpr only checks for literal variables, which is a name will be minified to a one or two character name.
		return &js.BinaryExpr{js.AndToken, groupExpr(expr.Cond, binaryLeftPrecMap[js.AndToken]), expr.X}
	} else if isEqualExpr(expr.X, expr.Y) {
		// if true and false bodies are equal
		return groupExpr(&js.CommaExpr{[]js.IExpr{expr.Cond, expr.X}}, prec)
	} else if nullishExpr, ok := toNullishExpr(expr); ok && !m.o.NoNullishOperator {
		// no need to check whether left/right need to add groups, as the space saving is always more
		return nullishExpr
	} else {
		callX, isCallX := expr.X.(*js.CallExpr)
		callY, isCallY := expr.Y.(*js.CallExpr)
		if isCallX && isCallY && len(callX.Args.List) == 1 && len(callY.Args.List) == 1 && !callX.Args.List[0].Rest && !callY.Args.List[0].Rest && isEqualExpr(callX.X, callY.X) {
			expr.X = callX.Args.List[0].Value
			expr.Y = callY.Args.List[0].Value
			return &js.CallExpr{callX.X, js.Args{[]js.Arg{{expr, false}}}, false} // recompress the conditional expression inside
		}

		// shorten when true and false bodies are true and false
		trueX, falseX := isTrue(expr.X), isFalse(expr.X)
		trueY, falseY := isTrue(expr.Y), isFalse(expr.Y)
		if trueX && falseY || falseX && trueY {
			return optimizeBooleanExpr(expr.Cond, falseX, prec)
		} else if trueX || trueY {
			// trueX != trueY
			cond := optimizeBooleanExpr(expr.Cond, trueY, binaryLeftPrecMap[js.OrToken])
			if trueY {
				return &js.BinaryExpr{js.OrToken, cond, groupExpr(expr.X, binaryRightPrecMap[js.OrToken])}
			} else {
				return &js.BinaryExpr{js.OrToken, cond, groupExpr(expr.Y, binaryRightPrecMap[js.OrToken])}
			}
		} else if falseX || falseY {
			// falseX != falseY
			cond := optimizeBooleanExpr(expr.Cond, falseX, binaryLeftPrecMap[js.AndToken])
			if falseX {
				return &js.BinaryExpr{js.AndToken, cond, groupExpr(expr.Y, binaryRightPrecMap[js.AndToken])}
			} else {
				return &js.BinaryExpr{js.AndToken, cond, groupExpr(expr.X, binaryRightPrecMap[js.AndToken])}
			}
		} else if condExpr, ok := expr.X.(*js.CondExpr); ok && isEqualExpr(expr.Y, condExpr.Y) {
			// nested conditional expression with same false bodies
			return &js.CondExpr{&js.BinaryExpr{js.AndToken, groupExpr(expr.Cond, binaryLeftPrecMap[js.AndToken]), groupExpr(condExpr.Cond, binaryRightPrecMap[js.AndToken])}, condExpr.X, expr.Y}
		} else if prec <= js.OpExpr {
			// regular conditional expression
			// convert  (a,b)?c:d  =>  a,b?c:d
			if group, ok := expr.Cond.(*js.GroupExpr); ok {
				if comma, ok := group.X.(*js.CommaExpr); ok && js.OpCoalesce <= exprPrec(comma.List[len(comma.List)-1]) {
					expr.Cond = comma.List[len(comma.List)-1]
					comma.List[len(comma.List)-1] = expr
					return comma // recompress the conditional expression inside
				}
			}
		}
	}
	return expr
}

func isHexDigit(b byte) bool {
	return '0' <= b && b <= '9' || 'a' <= b && b <= 'f' || 'A' <= b && b <= 'F'
}

func mergeBinaryExpr(expr *js.BinaryExpr) {
	// merge string concatenations which may be intertwined with other additions
	var ok bool
	for expr.Op == js.AddToken {
		if lit, ok := expr.Y.(*js.LiteralExpr); ok && lit.TokenType == js.StringToken {
			left := expr
			strings := []*js.LiteralExpr{lit}
			n := len(lit.Data) - 2
			for left.Op == js.AddToken {
				if 50 < len(strings) {
					return // limit recursion
				}
				if lit, ok := left.X.(*js.LiteralExpr); ok && lit.TokenType == js.StringToken {
					strings = append(strings, lit)
					n += len(lit.Data) - 2
					left.X = nil
				} else if newLeft, ok := left.X.(*js.BinaryExpr); ok {
					if lit, ok := newLeft.Y.(*js.LiteralExpr); ok && lit.TokenType == js.StringToken {
						strings = append(strings, lit)
						n += len(lit.Data) - 2
						left = newLeft
						continue
					}
				}
				break
			}

			if 1 < len(strings) {
				// unescaped quotes will be repaired in minifyString later on
				b := make([]byte, 0, n+2)
				b = append(b, strings[len(strings)-1].Data[:len(strings[len(strings)-1].Data)-1]...)
				for i := len(strings) - 2; 0 < i; i-- {
					b = append(b, strings[i].Data[1:len(strings[i].Data)-1]...)
				}
				b = append(b, strings[0].Data[1:]...)
				b[len(b)-1] = b[0]

				expr.X = left.X
				expr.Y.(*js.LiteralExpr).Data = b
			}
		}
		if expr, ok = expr.X.(*js.BinaryExpr); !ok {
			break
		}
	}
}

func minifyString(b []byte, allowTemplate bool) []byte {
	if len(b) < 3 {
		return []byte("\"\"")
	}

	// switch quotes if more optimal
	singleQuotes := 0
	doubleQuotes := 0
	backtickQuotes := 0
	newlines := 0
	dollarSigns := 0
	notEscapes := false
	for i := 1; i < len(b)-1; i++ {
		if b[i] == '\'' {
			singleQuotes++
		} else if b[i] == '"' {
			doubleQuotes++
		} else if b[i] == '`' {
			backtickQuotes++
		} else if b[i] == '$' {
			dollarSigns++
		} else if b[i] == '\\' && i+1 < len(b) {
			if b[i+1] == 'n' || b[i+1] == 'r' {
				newlines++
			} else if '1' <= b[i+1] && b[i+1] <= '9' || b[i+1] == '0' && i+2 < len(b) && '0' <= b[i+2] && b[i+2] <= '9' {
				notEscapes = true
			}
		}
	}
	quote := byte('"') // default to " for better GZIP compression
	quotes := singleQuotes
	if doubleQuotes < singleQuotes {
		quote = byte('"')
		quotes = doubleQuotes
	} else if singleQuotes < doubleQuotes {
		quote = byte('\'')
	}
	if allowTemplate && !notEscapes && backtickQuotes+dollarSigns < quotes+newlines {
		quote = byte('`')
	}
	b[0] = quote
	b[len(b)-1] = quote

	// strip unnecessary escapes
	return replaceEscapes(b, quote, 1, 1)
}

func replaceEscapes(b []byte, quote byte, prefix, suffix int) []byte {
	// strip unnecessary escapes
	j := 0
	start := 0
	for i := prefix; i < len(b)-suffix; i++ {
		if c := b[i]; c == '\\' {
			c = b[i+1]
			if c == quote || c == '\\' || c == 'u' || c == '0' && (i+2 == len(b)-1 || b[i+2] < '0' || '7' < b[i+2]) || quote != '`' && (c == 'n' || c == 'r') {
				// keep escape sequence
				i++
				continue
			}
			n := 1
			if c == '\n' || c == '\r' || c == 0xE2 && i+3 < len(b)-1 && b[i+2] == 0x80 && (b[i+3] == 0xA8 || b[i+3] == 0xA9) {
				// line continuations
				if c == 0xE2 {
					n = 4
				} else if c == '\r' && i+2 < len(b)-1 && b[i+2] == '\n' {
					n = 3
				} else {
					n = 2
				}
			} else if c == 'x' {
				if i+3 < len(b)-1 && isHexDigit(b[i+2]) && b[i+2] < '8' && isHexDigit(b[i+3]) {
					// hexadecimal escapes
					_, _ = hex.Decode(b[i+3:i+4:i+4], b[i+2:i+4])
					n = 3
					if b[i+3] == 0 || b[i+3] == '\\' || b[i+3] == quote || b[i+3] == '\n' || b[i+3] == '\r' {
						if b[i+3] == 0 {
							b[i+3] = '0'
						} else if b[i+3] == '\n' {
							b[i+3] = 'n'
						} else if b[i+3] == '\r' {
							b[i+3] = 'r'
						}
						n--
						b[i+2] = '\\'
					}
				} else {
					i++
					continue
				}
			} else if '0' <= c && c <= '7' {
				// octal escapes (legacy), \0 already handled
				num := c - '0'
				if i+2 < len(b)-1 && '0' <= b[i+2] && b[i+2] <= '7' {
					num = num*8 + b[i+2] - '0'
					n++
					if num < 32 && i+3 < len(b)-1 && '0' <= b[i+3] && b[i+3] <= '7' {
						num = num*8 + b[i+3] - '0'
						n++
					}
				}
				b[i+n] = num
				if num == 0 || num == '\\' || num == quote || num == '\n' || num == '\r' {
					if num == 0 {
						b[i+n] = '0'
					} else if num == '\n' {
						b[i+n] = 'n'
					} else if num == '\r' {
						b[i+n] = 'r'
					}
					n--
					b[i+n] = '\\'
				}
			} else if c == 'n' {
				b[i+1] = '\n' // only for template literals
			} else if c == 'r' {
				b[i+1] = '\r' // only for template literals
			} else if c == 't' {
				b[i+1] = '\t'
			} else if c == 'f' {
				b[i+1] = '\f'
			} else if c == 'v' {
				b[i+1] = '\v'
			} else if c == 'b' {
				b[i+1] = '\b'
			}
			// remove unnecessary escape character, anything but 0x00, 0x0A, 0x0D, \, ' or "
			if start != 0 {
				j += copy(b[j:], b[start:i])
			} else {
				j = i
			}
			start = i + n
			i += n - 1
		} else if c == quote || c == '$' && quote == '`' && (i+1 < len(b) && b[i+1] == '{' || i+2 < len(b) && b[i+1] == '\\' && b[i+2] == '{') {
			// may not be escaped properly when changing quotes
			if j < start {
				// avoid append
				j += copy(b[j:], b[start:i])
				b[j] = '\\'
				j++
				start = i
			} else {
				b = append(append(b[:i], '\\'), b[i:]...)
				i++
				b[i] = c // was overwritten above
			}
		} else if c == '<' && 9 <= len(b)-1-i {
			if b[i+1] == '\\' && 10 <= len(b)-1-i && bytes.Equal(b[i+2:i+10], []byte("/script>")) {
				i += 9
			} else if bytes.Equal(b[i+1:i+9], []byte("/script>")) {
				i++
				if j < start {
					// avoid append
					j += copy(b[j:], b[start:i])
					b[j] = '\\'
					j++
					start = i
				} else {
					b = append(append(b[:i], '\\'), b[i:]...)
					i++
					b[i] = '/' // was overwritten above
				}
			}
		}
	}
	if start != 0 {
		j += copy(b[j:], b[start:])
		return b[:j]
	}
	return b
}

var regexpEscapeTable = [256]bool{
	// ASCII
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, true, false, false, false, // $
	true, true, true, true, false, false, true, true, // (, ), *, +, ., /
	true, true, true, true, true, true, true, true, // 0, 1, 2, 3, 4, 5, 6, 7
	true, true, false, false, false, false, false, true, // 8, 9, ?

	false, false, true, false, true, false, false, false, // B, D
	false, false, false, false, false, false, false, false,
	true, false, false, true, false, false, false, true, // P, S, W
	false, false, false, true, true, true, true, false, // [, \, ], ^

	false, false, true, true, true, false, true, false, // b, c, d, f
	false, false, false, true, false, false, true, false, // k, n
	true, false, true, true, true, true, true, true, // p, r, s, t, u, v, w
	true, false, false, true, true, true, false, false, // x, {, |, }

	// non-ASCII
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
}

var regexpClassEscapeTable = [256]bool{
	// ASCII
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	true, true, true, true, true, true, true, true, // 0, 1, 2, 3, 4, 5, 6, 7
	true, true, false, false, false, false, false, false, // 8, 9

	false, false, false, false, true, false, false, false, // D
	false, false, false, false, false, false, false, false,
	true, false, false, true, false, false, false, true, // P, S, W
	false, false, false, false, true, true, false, false, // \, ]

	false, false, true, true, true, false, true, false, // b, c, d, f
	false, false, false, false, false, false, true, false, // n
	true, false, true, true, true, true, true, true, // p, r, s, t, u, v, w
	true, false, false, false, false, false, false, false, // x

	// non-ASCII
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,

	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false,
}

func minifyRegExp(b []byte) []byte {
	inClass := false
	afterDash := 0
	iClass := 0
	for i := 1; i < len(b)-1; i++ {
		if inClass {
			afterDash++
		}
		if b[i] == '\\' {
			c := b[i+1]
			escape := true
			if inClass {
				escape = regexpClassEscapeTable[c] || c == '-' && 2 < afterDash && i+2 < len(b) && b[i+2] != ']' || c == '^' && i == iClass+1
			} else {
				escape = regexpEscapeTable[c]
			}
			if !escape {
				b = append(b[:i], b[i+1:]...)
				if inClass && 2 < afterDash && c == '-' {
					afterDash = 0
				} else if inClass && c == '^' {
					afterDash = 1
				}
			} else {
				i++
			}
		} else if b[i] == '[' {
			if b[i+1] == '^' {
				i++
			}
			afterDash = 1
			inClass = true
			iClass = i
		} else if inClass && b[i] == ']' {
			inClass = false
		} else if b[i] == '/' {
			break
		} else if inClass && 2 < afterDash && b[i] == '-' {
			afterDash = 0
		}
	}
	return b
}

func removeUnderscores(b []byte) []byte {
	for i := 0; i < len(b); i++ {
		if b[i] == '_' {
			b = append(b[:i], b[i+1:]...)
			i--
		}
	}
	return b
}

func decimalNumber(b []byte, prec int) []byte {
	b = removeUnderscores(b)
	return minify.Number(b, prec)
}

func binaryNumber(b []byte, prec int) []byte {
	b = removeUnderscores(b)
	if len(b) <= 2 || 65 < len(b) {
		return b
	}
	var n int64
	for _, c := range b[2:] {
		n *= 2
		n += int64(c - '0')
	}
	i := strconv.LenInt(n) - 1
	b = b[:i+1]
	for 0 <= i {
		b[i] = byte('0' + n%10)
		n /= 10
		i--
	}
	return minify.Number(b, prec)
}

func octalNumber(b []byte, prec int) []byte {
	b = removeUnderscores(b)
	if len(b) <= 2 || 23 < len(b) {
		return b
	}
	var n int64
	for _, c := range b[2:] {
		n *= 8
		n += int64(c - '0')
	}
	i := strconv.LenInt(n) - 1
	b = b[:i+1]
	for 0 <= i {
		b[i] = byte('0' + n%10)
		n /= 10
		i--
	}
	return minify.Number(b, prec)
}

func hexadecimalNumber(b []byte, prec int) []byte {
	b = removeUnderscores(b)
	if len(b) <= 2 || 12 < len(b) || len(b) == 12 && ('D' < b[2] && b[2] <= 'F' || 'd' < b[2]) {
		return b
	}
	var n int64
	for _, c := range b[2:] {
		n *= 16
		if c <= '9' {
			n += int64(c - '0')
		} else if c <= 'F' {
			n += 10 + int64(c-'A')
		} else {
			n += 10 + int64(c-'a')
		}
	}
	i := strconv.LenInt(n) - 1
	b = b[:i+1]
	for 0 <= i {
		b[i] = byte('0' + n%10)
		n /= 10
		i--
	}
	return minify.Number(b, prec)
}
