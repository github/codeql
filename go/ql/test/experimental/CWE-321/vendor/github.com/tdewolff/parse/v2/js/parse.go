package js

import (
	"errors"
	"fmt"
	"io"

	"github.com/tdewolff/parse/v2"
	"github.com/tdewolff/parse/v2/buffer"
)

type Options struct {
	WhileToFor bool
}

// Parser is the state for the parser.
type Parser struct {
	l   *Lexer
	o   Options
	err error

	data                   []byte
	tt                     TokenType
	prevLT                 bool
	inFor                  bool
	await, yield           bool
	assumeArrowFunc        bool
	allowDirectivePrologue bool

	stmtLevel int
	exprLevel int

	scope *Scope
}

// Parse returns a JS AST tree of.
func Parse(r *parse.Input, o Options) (*AST, error) {
	ast := &AST{}
	p := &Parser{
		l:     NewLexer(r),
		o:     o,
		tt:    WhitespaceToken, // trick so that next() works
		await: true,
	}

	// process shebang
	if r.Peek(0) == '#' && r.Peek(1) == '!' {
		r.Move(2)
		p.l.consumeSingleLineComment() // consume till end-of-line
		ast.Comments = append(ast.Comments, r.Shift())
	}

	p.tt, p.data = p.l.Next()
	for p.tt == CommentToken || p.tt == CommentLineTerminatorToken {
		ast.Comments = append(ast.Comments, p.data)
		p.tt, p.data = p.l.Next()
		if p.tt == WhitespaceToken || p.tt == LineTerminatorToken {
			p.tt, p.data = p.l.Next()
		}
	}
	if p.tt == WhitespaceToken || p.tt == LineTerminatorToken {
		p.next()
	}
	// prevLT may be wrong but that is not a problem
	ast.BlockStmt = p.parseModule()

	if p.err == nil {
		p.err = p.l.Err()
	} else {
		offset := p.l.r.Offset() - len(p.data)
		p.err = parse.NewError(buffer.NewReader(p.l.r.Bytes()), offset, p.err.Error())
	}
	if p.err == io.EOF {
		p.err = nil
	}
	return ast, p.err
}

////////////////////////////////////////////////////////////////

func (p *Parser) next() {
	p.prevLT = false
	p.tt, p.data = p.l.Next()
	for p.tt == WhitespaceToken || p.tt == LineTerminatorToken || p.tt == CommentToken || p.tt == CommentLineTerminatorToken {
		if p.tt == LineTerminatorToken || p.tt == CommentLineTerminatorToken {
			p.prevLT = true
		}
		p.tt, p.data = p.l.Next()
	}
}

func (p *Parser) failMessage(msg string, args ...interface{}) {
	if p.err == nil {
		p.err = fmt.Errorf(msg, args...)
		p.tt = ErrorToken
	}
}

func (p *Parser) fail(in string, expected ...TokenType) {
	if p.err == nil {
		msg := "unexpected"
		if 0 < len(expected) {
			msg = "expected"
			for i, tt := range expected[:len(expected)-1] {
				if 0 < i {
					msg += ","
				}
				msg += " " + tt.String() + ""
			}
			if 2 < len(expected) {
				msg += ", or"
			} else if 1 < len(expected) {
				msg += " or"
			}
			msg += " " + expected[len(expected)-1].String() + " instead of"
		}

		if p.tt == ErrorToken {
			if p.l.Err() == io.EOF {
				msg += " EOF"
			} else if lexerErr, ok := p.l.Err().(*parse.Error); ok {
				msg = lexerErr.Message
			} else {
				// does not happen
			}
		} else {
			msg += " " + string(p.data) + ""
		}
		if in != "" {
			msg += " in " + in
		}

		p.err = errors.New(msg)
		p.tt = ErrorToken
	}
}

func (p *Parser) consume(in string, tt TokenType) bool {
	if p.tt != tt {
		p.fail(in, tt)
		return false
	}
	p.next()
	return true
}

// TODO: refactor
//type ScopeState struct {
//	scope           *Scope
//	async           bool
//	generator       bool
//	assumeArrowFunc bool
//}

func (p *Parser) enterScope(scope *Scope, isFunc bool) *Scope {
	// create a new scope object and add it to the parent
	parent := p.scope
	p.scope = scope
	*scope = Scope{
		Parent: parent,
	}
	if isFunc {
		scope.Func = scope
	} else if parent != nil {
		scope.Func = parent.Func
	}
	return parent
}

func (p *Parser) exitScope(parent *Scope) {
	p.scope.HoistUndeclared()
	p.scope = parent
}

func (p *Parser) parseModule() (module BlockStmt) {
	p.enterScope(&module.Scope, true)
	p.allowDirectivePrologue = true
	for {
		switch p.tt {
		case ErrorToken:
			return
		case ImportToken:
			p.next()
			if p.tt == OpenParenToken {
				// could be an import call expression
				left := &LiteralExpr{ImportToken, []byte("import")}
				p.exprLevel++
				suffix := p.parseExpressionSuffix(left, OpExpr, OpCall)
				p.exprLevel--
				module.List = append(module.List, &ExprStmt{suffix})
			} else {
				importStmt := p.parseImportStmt()
				module.List = append(module.List, &importStmt)
			}
		case ExportToken:
			exportStmt := p.parseExportStmt()
			module.List = append(module.List, &exportStmt)
		default:
			module.List = append(module.List, p.parseStmt(true))
		}
	}
}

func (p *Parser) parseStmt(allowDeclaration bool) (stmt IStmt) {
	p.stmtLevel++
	if 1000 < p.stmtLevel {
		p.failMessage("too many nested statements")
		return nil
	}

	switch tt := p.tt; tt {
	case OpenBraceToken:
		stmt = p.parseBlockStmt("block statement")
	case ConstToken, VarToken:
		if !allowDeclaration && tt == ConstToken {
			p.fail("statement")
			return
		}
		p.next()
		varDecl := p.parseVarDecl(tt, true)
		stmt = varDecl
		if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
			if tt == ConstToken {
				p.fail("const declaration")
			} else {
				p.fail("var statement")
			}
			return
		}
	case LetToken:
		let := p.data
		p.next()
		if allowDeclaration && (IsIdentifier(p.tt) || p.tt == YieldToken || p.tt == AwaitToken || p.tt == OpenBracketToken || p.tt == OpenBraceToken) {
			stmt = p.parseVarDecl(tt, false)
			if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
				p.fail("let declaration")
				return
			}
		} else {
			// expression
			stmt = &ExprStmt{p.parseIdentifierExpression(OpExpr, let)}
			if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
				p.fail("expression")
				return
			}
		}
	case IfToken:
		p.next()
		if !p.consume("if statement", OpenParenToken) {
			return
		}
		cond := p.parseExpression(OpExpr)
		if !p.consume("if statement", CloseParenToken) {
			return
		}
		body := p.parseStmt(false)

		var elseBody IStmt
		if p.tt == ElseToken {
			p.next()
			elseBody = p.parseStmt(false)
		}
		stmt = &IfStmt{cond, body, elseBody}
	case ContinueToken, BreakToken:
		tt := p.tt
		p.next()
		var label []byte
		if !p.prevLT && p.isIdentifierReference(p.tt) {
			label = p.data
			p.next()
		}
		stmt = &BranchStmt{tt, label}
	case ReturnToken:
		p.next()
		var value IExpr
		if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
			value = p.parseExpression(OpExpr)
		}
		stmt = &ReturnStmt{value}
	case WithToken:
		p.next()
		if !p.consume("with statement", OpenParenToken) {
			return
		}
		cond := p.parseExpression(OpExpr)
		if !p.consume("with statement", CloseParenToken) {
			return
		}

		p.scope.Func.HasWith = true
		stmt = &WithStmt{cond, p.parseStmt(false)}
	case DoToken:
		stmt = &DoWhileStmt{}
		p.next()
		body := p.parseStmt(false)
		if !p.consume("do-while statement", WhileToken) {
			return
		}
		if !p.consume("do-while statement", OpenParenToken) {
			return
		}
		stmt = &DoWhileStmt{p.parseExpression(OpExpr), body}
		if !p.consume("do-while statement", CloseParenToken) {
			return
		}
	case WhileToken:
		p.next()
		if !p.consume("while statement", OpenParenToken) {
			return
		}
		cond := p.parseExpression(OpExpr)
		if !p.consume("while statement", CloseParenToken) {
			return
		}
		body := p.parseStmt(false)
		if p.o.WhileToFor {
			varDecl := &VarDecl{TokenType: VarToken, Scope: p.scope, InFor: true}
			p.scope.Func.VarDecls = append(p.scope.Func.VarDecls, varDecl)

			block, ok := body.(*BlockStmt)
			if !ok {
				block = &BlockStmt{List: []IStmt{body}}
			}
			stmt = &ForStmt{varDecl, cond, nil, block}
		} else {
			stmt = &WhileStmt{cond, body}
		}
	case ForToken:
		p.next()
		await := p.await && p.tt == AwaitToken
		if await {
			p.next()
		}
		if !p.consume("for statement", OpenParenToken) {
			return
		}

		body := &BlockStmt{}
		parent := p.enterScope(&body.Scope, false)

		var init IExpr
		p.inFor = true
		if p.tt == VarToken || p.tt == LetToken || p.tt == ConstToken {
			tt := p.tt
			p.next()
			varDecl := p.parseVarDecl(tt, true)
			if p.tt != SemicolonToken && (1 < len(varDecl.List) || varDecl.List[0].Default != nil) {
				p.fail("for statement")
				return
			} else if p.tt == SemicolonToken && varDecl.List[0].Default == nil {
				// all but the first item were already verified
				if _, ok := varDecl.List[0].Binding.(*Var); !ok {
					p.fail("for statement")
					return
				}
			}
			init = varDecl
		} else if p.tt != SemicolonToken {
			init = p.parseExpression(OpExpr)
		}
		p.inFor = false

		if p.tt == SemicolonToken {
			var cond, post IExpr
			if await {
				p.fail("for statement", OfToken)
				return
			}
			p.next()
			if p.tt != SemicolonToken {
				cond = p.parseExpression(OpExpr)
			}
			if !p.consume("for statement", SemicolonToken) {
				return
			}
			if p.tt != CloseParenToken {
				post = p.parseExpression(OpExpr)
			}
			if !p.consume("for statement", CloseParenToken) {
				return
			}
			p.scope.MarkForStmt()
			if p.tt == OpenBraceToken {
				body.List = p.parseStmtList("")
			} else if p.tt != SemicolonToken {
				body.List = []IStmt{p.parseStmt(false)}
			}
			if init == nil {
				varDecl := &VarDecl{TokenType: VarToken, Scope: p.scope, InFor: true}
				p.scope.Func.VarDecls = append(p.scope.Func.VarDecls, varDecl)
				init = varDecl
			} else if varDecl, ok := init.(*VarDecl); ok {
				varDecl.InFor = true
			}
			stmt = &ForStmt{init, cond, post, body}
		} else if p.tt == InToken {
			if await {
				p.fail("for statement", OfToken)
				return
			}
			p.next()
			value := p.parseExpression(OpExpr)
			if !p.consume("for statement", CloseParenToken) {
				return
			}
			p.scope.MarkForStmt()
			if p.tt == OpenBraceToken {
				body.List = p.parseStmtList("")
			} else if p.tt != SemicolonToken {
				body.List = []IStmt{p.parseStmt(false)}
			}
			if varDecl, ok := init.(*VarDecl); ok {
				varDecl.InForInOf = true
			}
			stmt = &ForInStmt{init, value, body}
		} else if p.tt == OfToken {
			p.next()
			value := p.parseExpression(OpAssign)
			if !p.consume("for statement", CloseParenToken) {
				return
			}
			p.scope.MarkForStmt()
			if p.tt == OpenBraceToken {
				body.List = p.parseStmtList("")
			} else if p.tt != SemicolonToken {
				body.List = []IStmt{p.parseStmt(false)}
			}
			if varDecl, ok := init.(*VarDecl); ok {
				varDecl.InForInOf = true
			}
			stmt = &ForOfStmt{await, init, value, body}
		} else {
			p.fail("for statement", InToken, OfToken, SemicolonToken)
			return
		}
		p.exitScope(parent)
	case SwitchToken:
		p.next()
		if !p.consume("switch statement", OpenParenToken) {
			return
		}
		init := p.parseExpression(OpExpr)
		if !p.consume("switch statement", CloseParenToken) {
			return
		}

		// case block
		if !p.consume("switch statement", OpenBraceToken) {
			return
		}

		switchStmt := &SwitchStmt{Init: init}
		parent := p.enterScope(&switchStmt.Scope, false)
		for {
			if p.tt == ErrorToken {
				p.fail("switch statement")
				return
			} else if p.tt == CloseBraceToken {
				p.next()
				break
			}

			clause := p.tt
			var list IExpr
			if p.tt == CaseToken {
				p.next()
				list = p.parseExpression(OpExpr)
			} else if p.tt == DefaultToken {
				p.next()
			} else {
				p.fail("switch statement", CaseToken, DefaultToken)
				return
			}
			if !p.consume("switch statement", ColonToken) {
				return
			}

			var stmts []IStmt
			for p.tt != CaseToken && p.tt != DefaultToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
				stmts = append(stmts, p.parseStmt(true))
			}
			switchStmt.List = append(switchStmt.List, CaseClause{clause, list, stmts})
		}
		p.exitScope(parent)
		stmt = switchStmt
	case FunctionToken:
		if !allowDeclaration {
			p.fail("statement")
			return
		}
		stmt = p.parseFuncDecl()
	case AsyncToken: // async function
		if !allowDeclaration {
			p.fail("statement")
			return
		}
		async := p.data
		p.next()
		if p.tt == FunctionToken && !p.prevLT {
			stmt = p.parseAsyncFuncDecl()
		} else {
			// expression
			stmt = &ExprStmt{p.parseAsyncExpression(OpExpr, async)}
			if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
				p.fail("expression")
				return
			}
		}
	case ClassToken:
		if !allowDeclaration {
			p.fail("statement")
			return
		}
		stmt = p.parseClassDecl()
	case ThrowToken:
		p.next()
		var value IExpr
		if !p.prevLT {
			value = p.parseExpression(OpExpr)
		}
		stmt = &ThrowStmt{value}
	case TryToken:
		p.next()
		body := p.parseBlockStmt("try statement")
		var binding IBinding
		var catch, finally *BlockStmt
		if p.tt == CatchToken {
			p.next()
			catch = &BlockStmt{}
			parent := p.enterScope(&catch.Scope, false)
			if p.tt == OpenParenToken {
				p.next()
				binding = p.parseBinding(CatchDecl) // local to block scope of catch
				if !p.consume("try-catch statement", CloseParenToken) {
					return
				}
			}
			catch.List = p.parseStmtList("try-catch statement")
			p.exitScope(parent)
		} else if p.tt != FinallyToken {
			p.fail("try statement", CatchToken, FinallyToken)
			return
		}
		if p.tt == FinallyToken {
			p.next()
			finally = p.parseBlockStmt("try-finally statement")
		}
		stmt = &TryStmt{body, binding, catch, finally}
	case DebuggerToken:
		p.next()
		stmt = &DebuggerStmt{}
	case SemicolonToken, ErrorToken:
		stmt = &EmptyStmt{}
	default:
		if p.isIdentifierReference(p.tt) {
			// labelled statement or expression
			label := p.data
			p.next()
			if p.tt == ColonToken {
				p.next()
				stmt = &LabelledStmt{label, p.parseStmt(true)} // allows illegal async function, generator function, let, const, or class declarations
			} else {
				// expression
				stmt = &ExprStmt{p.parseIdentifierExpression(OpExpr, label)}
				if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
					p.fail("expression")
					return
				}
			}
		} else {
			// expression
			stmt = &ExprStmt{p.parseExpression(OpExpr)}
			if !p.prevLT && p.tt != SemicolonToken && p.tt != CloseBraceToken && p.tt != ErrorToken {
				p.fail("expression")
				return
			}
			if p.allowDirectivePrologue {
				if lit, ok := stmt.(*ExprStmt).Value.(*LiteralExpr); ok && lit.TokenType == StringToken {
					stmt = &DirectivePrologueStmt{lit.Data}
				} else {
					p.allowDirectivePrologue = false
				}
			}
		}
	}
	if p.tt == SemicolonToken {
		p.next()
	}
	p.stmtLevel--
	return
}

func (p *Parser) parseStmtList(in string) (list []IStmt) {
	if !p.consume(in, OpenBraceToken) {
		return
	}
	for {
		if p.tt == ErrorToken {
			p.fail("")
			return
		} else if p.tt == CloseBraceToken {
			p.next()
			break
		}
		list = append(list, p.parseStmt(true))
	}
	return
}

func (p *Parser) parseBlockStmt(in string) (blockStmt *BlockStmt) {
	blockStmt = &BlockStmt{}
	parent := p.enterScope(&blockStmt.Scope, false)
	blockStmt.List = p.parseStmtList(in)
	p.exitScope(parent)
	return
}

func (p *Parser) parseImportStmt() (importStmt ImportStmt) {
	// assume we're passed import
	if p.tt == StringToken {
		importStmt.Module = p.data
		p.next()
	} else {
		if IsIdentifier(p.tt) || p.tt == YieldToken {
			importStmt.Default = p.data
			p.next()
			if p.tt == CommaToken {
				p.next()
			}
		}
		if p.tt == MulToken {
			star := p.data
			p.next()
			if !p.consume("import statement", AsToken) {
				return
			}
			if !IsIdentifier(p.tt) && p.tt != YieldToken {
				p.fail("import statement", IdentifierToken)
				return
			}
			importStmt.List = []Alias{Alias{star, p.data}}
			p.next()
		} else if p.tt == OpenBraceToken {
			p.next()
			for IsIdentifierName(p.tt) || p.tt == StringToken {
				tt := p.tt
				var name, binding []byte = nil, p.data
				p.next()
				if p.tt == AsToken {
					p.next()
					if !IsIdentifier(p.tt) && p.tt != YieldToken {
						p.fail("import statement", IdentifierToken)
						return
					}
					name = binding
					binding = p.data
					p.next()
				} else if !IsIdentifier(tt) && tt != YieldToken || tt == StringToken {
					p.fail("import statement", IdentifierToken, StringToken)
					return
				}
				importStmt.List = append(importStmt.List, Alias{name, binding})
				if p.tt == CommaToken {
					p.next()
					if p.tt == CloseBraceToken {
						importStmt.List = append(importStmt.List, Alias{})
						break
					}
				}
			}
			if !p.consume("import statement", CloseBraceToken) {
				return
			}
		}
		if importStmt.Default == nil && len(importStmt.List) == 0 {
			p.fail("import statement", StringToken, IdentifierToken, MulToken, OpenBraceToken)
			return
		}

		if !p.consume("import statement", FromToken) {
			return
		}
		if p.tt != StringToken {
			p.fail("import statement", StringToken)
			return
		}
		importStmt.Module = p.data
		p.next()
	}
	if p.tt == SemicolonToken {
		p.next()
	}
	return
}

func (p *Parser) parseExportStmt() (exportStmt ExportStmt) {
	// assume we're at export
	p.next()
	if p.tt == MulToken || p.tt == OpenBraceToken {
		if p.tt == MulToken {
			star := p.data
			p.next()
			if p.tt == AsToken {
				p.next()
				if !IsIdentifierName(p.tt) && p.tt != StringToken {
					p.fail("export statement", IdentifierToken, StringToken)
					return
				}
				exportStmt.List = []Alias{Alias{star, p.data}}
				p.next()
			} else {
				exportStmt.List = []Alias{Alias{nil, star}}
			}
			if p.tt != FromToken {
				p.fail("export statement", FromToken)
				return
			}
		} else {
			p.next()
			for IsIdentifierName(p.tt) || p.tt == StringToken {
				var name, binding []byte = nil, p.data
				p.next()
				if p.tt == AsToken {
					p.next()
					if !IsIdentifierName(p.tt) && p.tt != StringToken {
						p.fail("export statement", IdentifierToken, StringToken)
						return
					}
					name = binding
					binding = p.data
					p.next()
				}
				exportStmt.List = append(exportStmt.List, Alias{name, binding})
				if p.tt == CommaToken {
					p.next()
					if p.tt == CloseBraceToken {
						exportStmt.List = append(exportStmt.List, Alias{})
						break
					}
				}
			}
			if !p.consume("export statement", CloseBraceToken) {
				return
			}
		}
		if p.tt == FromToken {
			p.next()
			if p.tt != StringToken {
				p.fail("export statement", StringToken)
				return
			}
			exportStmt.Module = p.data
			p.next()
		}
	} else if p.tt == VarToken || p.tt == ConstToken || p.tt == LetToken {
		tt := p.tt
		p.next()
		exportStmt.Decl = p.parseVarDecl(tt, false)
	} else if p.tt == FunctionToken {
		exportStmt.Decl = p.parseFuncDecl()
	} else if p.tt == AsyncToken { // async function
		p.next()
		if p.tt != FunctionToken || p.prevLT {
			p.fail("export statement", FunctionToken)
			return
		}
		exportStmt.Decl = p.parseAsyncFuncDecl()
	} else if p.tt == ClassToken {
		exportStmt.Decl = p.parseClassDecl()
	} else if p.tt == DefaultToken {
		exportStmt.Default = true
		p.next()
		if p.tt == FunctionToken {
			exportStmt.Decl = p.parseFuncDeclDefault()
		} else if p.tt == AsyncToken { // async function or async arrow function
			async := p.data
			p.next()
			if p.tt == FunctionToken && !p.prevLT {
				exportStmt.Decl = p.parseAsyncFuncDeclDefault()
			} else {
				// expression
				exportStmt.Decl = p.parseAsyncExpression(OpExpr, async)
			}
		} else if p.tt == ClassToken {
			exportStmt.Decl = p.parseClassDeclDefault()
		} else {
			exportStmt.Decl = p.parseExpression(OpAssign)
		}
	} else {
		p.fail("export statement", MulToken, OpenBraceToken, VarToken, LetToken, ConstToken, FunctionToken, AsyncToken, ClassToken, DefaultToken)
		return
	}
	if p.tt == SemicolonToken {
		p.next()
	}
	return
}

func (p *Parser) parseVarDecl(tt TokenType, canBeHoisted bool) (varDecl *VarDecl) {
	// assume we're past var, let or const
	varDecl = &VarDecl{
		TokenType: tt,
		Scope:     p.scope,
	}
	declType := LexicalDecl
	if tt == VarToken {
		declType = VariableDecl
		if canBeHoisted {
			p.scope.Func.VarDecls = append(p.scope.Func.VarDecls, varDecl)
		}
	}
	for {
		// binding element, var declaration in for-in or for-of can never have a default
		var bindingElement BindingElement
		parentInFor := p.inFor
		p.inFor = false
		bindingElement.Binding = p.parseBinding(declType)
		p.inFor = parentInFor
		if p.tt == EqToken {
			p.next()
			bindingElement.Default = p.parseExpression(OpAssign)
		} else if _, ok := bindingElement.Binding.(*Var); !ok && (!p.inFor || 0 < len(varDecl.List)) {
			p.fail("var statement", EqToken)
			return
		} else if tt == ConstToken && (!p.inFor || p.inFor && p.tt != OfToken && p.tt != InToken) {
			p.fail("const statement", EqToken)
		}

		varDecl.List = append(varDecl.List, bindingElement)
		if p.tt == CommaToken {
			p.next()
		} else {
			break
		}
	}
	return
}

func (p *Parser) parseFuncParams(in string) (params Params) {
	if !p.consume(in, OpenParenToken) {
		return
	}

	for p.tt != CloseParenToken && p.tt != ErrorToken {
		if p.tt == EllipsisToken {
			// binding rest element
			p.next()
			params.Rest = p.parseBinding(ArgumentDecl)
			p.consume(in, CloseParenToken)
			return
		}
		params.List = append(params.List, p.parseBindingElement(ArgumentDecl))
		if p.tt != CommaToken {
			break
		}
		p.next()
	}
	if p.tt != CloseParenToken {
		p.fail(in)
		return
	}
	p.next()

	// mark undeclared vars as arguments in `function f(a=b){var b}` where the b's are different vars
	p.scope.MarkFuncArgs()
	return
}

func (p *Parser) parseFuncDecl() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(false, false, false)
}

func (p *Parser) parseFuncDeclDefault() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(false, true, false)
}

func (p *Parser) parseAsyncFuncDecl() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(true, false, false)
}

func (p *Parser) parseAsyncFuncDeclDefault() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(true, true, false)
}

func (p *Parser) parseFuncExpr() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(false, false, true)
}

func (p *Parser) parseAsyncFuncExpr() (funcDecl *FuncDecl) {
	return p.parseAnyFunc(true, false, true)
}

func (p *Parser) parseAnyFunc(async, exportDefault, expr bool) (funcDecl *FuncDecl) {
	// assume we're at function
	p.next()
	funcDecl = &FuncDecl{}
	funcDecl.Async = async
	funcDecl.Generator = p.tt == MulToken
	if funcDecl.Generator {
		p.next()
	}
	var ok bool
	var name []byte
	if expr && (IsIdentifier(p.tt) || p.tt == YieldToken || p.tt == AwaitToken) || !expr && p.isIdentifierReference(p.tt) {
		name = p.data
		if !expr {
			funcDecl.Name, ok = p.scope.Declare(FunctionDecl, p.data)
			if !ok {
				p.failMessage("identifier %s has already been declared", string(p.data))
				return
			}
		}
		p.next()
	} else if !expr && !exportDefault {
		p.fail("function declaration", IdentifierToken)
		return
	} else if p.tt != OpenParenToken {
		p.fail("function declaration", IdentifierToken, OpenParenToken)
		return
	}
	parent := p.enterScope(&funcDecl.Body.Scope, true)
	parentAwait, parentYield := p.await, p.yield
	p.await, p.yield = funcDecl.Async, funcDecl.Generator

	if expr && name != nil {
		funcDecl.Name, _ = p.scope.Declare(ExprDecl, name) // cannot fail
	}
	funcDecl.Params = p.parseFuncParams("function declaration")
	p.allowDirectivePrologue = true
	funcDecl.Body.List = p.parseStmtList("function declaration")

	p.await, p.yield = parentAwait, parentYield
	p.exitScope(parent)
	return
}

func (p *Parser) parseClassDecl() (classDecl *ClassDecl) {
	return p.parseAnyClass(false, false)
}

func (p *Parser) parseClassDeclDefault() (classDecl *ClassDecl) {
	return p.parseAnyClass(true, false)
}

func (p *Parser) parseClassExpr() (classDecl *ClassDecl) {
	return p.parseAnyClass(false, true)
}

func (p *Parser) parseAnyClass(exportDefault, expr bool) (classDecl *ClassDecl) {
	// assume we're at class
	p.next()
	classDecl = &ClassDecl{}
	if IsIdentifier(p.tt) || p.tt == YieldToken || p.tt == AwaitToken {
		if !expr {
			var ok bool
			classDecl.Name, ok = p.scope.Declare(LexicalDecl, p.data)
			if !ok {
				p.failMessage("identifier %s has already been declared", string(p.data))
				return
			}
		} else {
			//classDecl.Name, ok = p.scope.Declare(ExprDecl, p.data) // classes do not register vars
			classDecl.Name = &Var{p.data, nil, 1, ExprDecl}
		}
		p.next()
	} else if !expr && !exportDefault {
		p.fail("class declaration", IdentifierToken)
		return
	}
	if p.tt == ExtendsToken {
		p.next()
		classDecl.Extends = p.parseExpression(OpLHS)
	}

	if !p.consume("class declaration", OpenBraceToken) {
		return
	}
	for {
		if p.tt == ErrorToken {
			p.fail("class declaration")
			return
		} else if p.tt == SemicolonToken {
			p.next()
			continue
		} else if p.tt == CloseBraceToken {
			p.next()
			break
		}

		classDecl.List = append(classDecl.List, p.parseClassElement())
	}
	return
}

func (p *Parser) parseClassElement() ClassElement {
	method := &MethodDecl{}
	var data []byte // either static, async, get, or set
	if p.tt == StaticToken {
		method.Static = true
		data = p.data
		p.next()
		if p.tt == OpenBraceToken {
			return ClassElement{StaticBlock: p.parseBlockStmt("class static block")}
		}
	}
	if p.tt == MulToken {
		method.Generator = true
		p.next()
	} else if p.tt == AsyncToken {
		data = p.data
		p.next()
		if !p.prevLT {
			method.Async = true
			if p.tt == MulToken {
				method.Generator = true
				data = nil
				p.next()
			}
		}
	} else if p.tt == GetToken {
		method.Get = true
		data = p.data
		p.next()
	} else if p.tt == SetToken {
		method.Set = true
		data = p.data
		p.next()
	}

	isField := false
	if data != nil && p.tt == OpenParenToken {
		// (static) method name is: static, async, get, or set
		method.Name.Literal = LiteralExpr{IdentifierToken, data}
		if method.Async || method.Get || method.Set {
			method.Async = false
			method.Get = false
			method.Set = false
		} else {
			method.Static = false
		}
	} else if data != nil && (p.tt == EqToken || p.tt == SemicolonToken || p.tt == CloseBraceToken) {
		// (static) field name is: static, async, get, or set
		method.Name.Literal = LiteralExpr{IdentifierToken, data}
		if !method.Async && !method.Get && !method.Set {
			method.Static = false
		}
		isField = true
	} else {
		if p.tt == PrivateIdentifierToken {
			method.Name.Literal = LiteralExpr{p.tt, p.data}
			p.next()
		} else {
			method.Name = p.parsePropertyName("method or field definition")
		}
		if (data == nil || method.Static) && p.tt != OpenParenToken {
			isField = true
		}
	}

	if isField {
		var init IExpr
		if p.tt == EqToken {
			p.next()
			init = p.parseExpression(OpAssign)
		}
		return ClassElement{Field: Field{Static: method.Static, Name: method.Name, Init: init}}
	}

	parent := p.enterScope(&method.Body.Scope, true)
	parentAwait, parentYield := p.await, p.yield
	p.await, p.yield = method.Async, method.Generator

	method.Params = p.parseFuncParams("method definition")
	p.allowDirectivePrologue = true
	method.Body.List = p.parseStmtList("method definition")

	p.await, p.yield = parentAwait, parentYield
	p.exitScope(parent)
	return ClassElement{Method: method}
}

func (p *Parser) parsePropertyName(in string) (propertyName PropertyName) {
	if IsIdentifierName(p.tt) {
		propertyName.Literal = LiteralExpr{IdentifierToken, p.data}
		p.next()
	} else if p.tt == StringToken {
		// reinterpret string as identifier or number if we can, except for empty strings
		if isIdent := AsIdentifierName(p.data[1 : len(p.data)-1]); isIdent {
			propertyName.Literal = LiteralExpr{IdentifierToken, p.data[1 : len(p.data)-1]}
		} else if isNum := AsDecimalLiteral(p.data[1 : len(p.data)-1]); isNum {
			propertyName.Literal = LiteralExpr{DecimalToken, p.data[1 : len(p.data)-1]}
		} else {
			propertyName.Literal = LiteralExpr{p.tt, p.data}
		}
		p.next()
	} else if IsNumeric(p.tt) {
		propertyName.Literal = LiteralExpr{p.tt, p.data}
		p.next()
	} else if p.tt == OpenBracketToken {
		p.next()
		propertyName.Computed = p.parseExpression(OpAssign)
		if !p.consume(in, CloseBracketToken) {
			return
		}
	} else {
		p.fail(in, IdentifierToken, StringToken, NumericToken, OpenBracketToken)
		return
	}
	return
}

func (p *Parser) parseBindingElement(decl DeclType) (bindingElement BindingElement) {
	// binding element
	bindingElement.Binding = p.parseBinding(decl)
	if p.tt == EqToken {
		p.next()
		bindingElement.Default = p.parseExpression(OpAssign)
	}
	return
}

func (p *Parser) parseBinding(decl DeclType) (binding IBinding) {
	// binding identifier or binding pattern
	if p.isIdentifierReference(p.tt) {
		var ok bool
		binding, ok = p.scope.Declare(decl, p.data)
		if !ok {
			p.failMessage("identifier %s has already been declared", string(p.data))
			return
		}
		p.next()
	} else if p.tt == OpenBracketToken {
		p.next()
		array := BindingArray{}
		if p.tt == CommaToken {
			array.List = append(array.List, BindingElement{})
		}
		last := 0
		for p.tt != CloseBracketToken {
			// elision
			for p.tt == CommaToken {
				p.next()
				if p.tt == CommaToken {
					array.List = append(array.List, BindingElement{})
				}
			}
			// binding rest element
			if p.tt == EllipsisToken {
				p.next()
				array.Rest = p.parseBinding(decl)
				if p.tt != CloseBracketToken {
					p.fail("array binding pattern", CloseBracketToken)
					return
				}
				break
			} else if p.tt == CloseBracketToken {
				array.List = array.List[:last]
				break
			}

			array.List = append(array.List, p.parseBindingElement(decl))
			last = len(array.List)

			if p.tt != CommaToken && p.tt != CloseBracketToken {
				p.fail("array binding pattern", CommaToken, CloseBracketToken)
				return
			}
		}
		p.next() // always CloseBracketToken
		binding = &array
	} else if p.tt == OpenBraceToken {
		p.next()
		object := BindingObject{}
		for p.tt != CloseBraceToken {
			// binding rest property
			if p.tt == EllipsisToken {
				p.next()
				if !p.isIdentifierReference(p.tt) {
					p.fail("object binding pattern", IdentifierToken)
					return
				}
				var ok bool
				object.Rest, ok = p.scope.Declare(decl, p.data)
				if !ok {
					p.failMessage("identifier %s has already been declared", string(p.data))
					return
				}
				p.next()
				if p.tt != CloseBraceToken {
					p.fail("object binding pattern", CloseBraceToken)
					return
				}
				break
			}

			item := BindingObjectItem{}
			if p.isIdentifierReference(p.tt) {
				name := p.data
				item.Key = &PropertyName{LiteralExpr{IdentifierToken, p.data}, nil}
				p.next()
				if p.tt == ColonToken {
					// property name + : + binding element
					p.next()
					item.Value = p.parseBindingElement(decl)
				} else {
					// single name binding
					var ok bool
					item.Key.Literal.Data = parse.Copy(item.Key.Literal.Data) // copy so that renaming doesn't rename the key
					item.Value.Binding, ok = p.scope.Declare(decl, name)
					if !ok {
						p.failMessage("identifier %s has already been declared", string(name))
						return
					}
					if p.tt == EqToken {
						p.next()
						item.Value.Default = p.parseExpression(OpAssign)
					}
				}
			} else {
				propertyName := p.parsePropertyName("object binding pattern")
				item.Key = &propertyName
				if !p.consume("object binding pattern", ColonToken) {
					return
				}
				item.Value = p.parseBindingElement(decl)
			}
			object.List = append(object.List, item)

			if p.tt == CommaToken {
				p.next()
			} else if p.tt != CloseBraceToken {
				p.fail("object binding pattern", CommaToken, CloseBraceToken)
				return
			}
		}
		p.next() // always CloseBracketToken
		binding = &object
	} else {
		p.fail("binding")
		return
	}
	return
}

func (p *Parser) parseArrayLiteral() (array ArrayExpr) {
	// assume we're on [
	p.next()
	prevComma := true
	for {
		if p.tt == ErrorToken {
			p.fail("expression")
			return
		} else if p.tt == CloseBracketToken {
			p.next()
			break
		} else if p.tt == CommaToken {
			if prevComma {
				array.List = append(array.List, Element{})
			}
			prevComma = true
			p.next()
		} else {
			spread := p.tt == EllipsisToken
			if spread {
				p.next()
			}
			array.List = append(array.List, Element{p.parseAssignmentExpression(), spread})
			prevComma = false
			if spread && p.tt != CloseBracketToken {
				p.assumeArrowFunc = false
			}
		}
	}
	return
}

func (p *Parser) parseObjectLiteral() (object ObjectExpr) {
	// assume we're on {
	p.next()
	for {
		if p.tt == ErrorToken {
			p.fail("object literal", CloseBraceToken)
			return
		} else if p.tt == CloseBraceToken {
			p.next()
			break
		}

		property := Property{}
		if p.tt == EllipsisToken {
			p.next()
			property.Spread = true
			property.Value = p.parseAssignmentExpression()
			if _, isIdent := property.Value.(*Var); !isIdent || p.tt != CloseBraceToken {
				p.assumeArrowFunc = false
			}
		} else {
			// try to parse as MethodDefinition, otherwise fall back to PropertyName:AssignExpr or IdentifierReference
			var data []byte
			method := MethodDecl{}
			if p.tt == MulToken {
				p.next()
				method.Generator = true
			} else if p.tt == AsyncToken {
				data = p.data
				p.next()
				if !p.prevLT {
					method.Async = true
					if p.tt == MulToken {
						p.next()
						method.Generator = true
						data = nil
					}
				} else {
					method.Name.Literal = LiteralExpr{IdentifierToken, data}
					data = nil
				}
			} else if p.tt == GetToken {
				data = p.data
				p.next()
				method.Get = true
			} else if p.tt == SetToken {
				data = p.data
				p.next()
				method.Set = true
			}

			// PropertyName
			if data != nil && !method.Generator && (p.tt == EqToken || p.tt == CommaToken || p.tt == CloseBraceToken || p.tt == ColonToken || p.tt == OpenParenToken) {
				method.Name.Literal = LiteralExpr{IdentifierToken, data}
				method.Async = false
				method.Get = false
				method.Set = false
			} else if !method.Name.IsSet() { // did not parse async [LT]
				method.Name = p.parsePropertyName("object literal")
				if !method.Name.IsSet() {
					return
				}
			}

			if p.tt == OpenParenToken {
				// MethodDefinition
				parent := p.enterScope(&method.Body.Scope, true)
				parentAwait, parentYield := p.await, p.yield
				p.await, p.yield = method.Async, method.Generator

				method.Params = p.parseFuncParams("method definition")
				method.Body.List = p.parseStmtList("method definition")

				p.await, p.yield = parentAwait, parentYield
				p.exitScope(parent)
				property.Value = &method
				p.assumeArrowFunc = false
			} else if p.tt == ColonToken {
				// PropertyName : AssignmentExpression
				p.next()
				property.Name = &method.Name
				property.Value = p.parseAssignmentExpression()
			} else if method.Name.IsComputed() || !p.isIdentifierReference(method.Name.Literal.TokenType) {
				p.fail("object literal", ColonToken, OpenParenToken)
				return
			} else {
				// IdentifierReference (= AssignmentExpression)?
				name := method.Name.Literal.Data
				method.Name.Literal.Data = parse.Copy(method.Name.Literal.Data) // copy so that renaming doesn't rename the key
				property.Name = &method.Name                                    // set key explicitly so after renaming the original is still known
				if p.assumeArrowFunc {
					var ok bool
					property.Value, ok = p.scope.Declare(ArgumentDecl, name)
					if !ok {
						property.Value = p.scope.Use(name)
						p.assumeArrowFunc = false
					}
				} else {
					property.Value = p.scope.Use(name)
				}
				if p.tt == EqToken {
					p.next()
					parentAssumeArrowFunc := p.assumeArrowFunc
					p.assumeArrowFunc = false
					property.Init = p.parseExpression(OpAssign)
					p.assumeArrowFunc = parentAssumeArrowFunc
				}
			}
		}
		object.List = append(object.List, property)
		if p.tt == CommaToken {
			p.next()
		} else if p.tt != CloseBraceToken {
			p.fail("object literal")
			return
		}
	}
	return
}

func (p *Parser) parseTemplateLiteral(precLeft OpPrec) (template TemplateExpr) {
	// assume we're on 'Template' or 'TemplateStart'
	template.Prec = OpMember
	if precLeft < OpMember {
		template.Prec = OpCall
	}
	for p.tt == TemplateStartToken || p.tt == TemplateMiddleToken {
		tpl := p.data
		p.next()
		template.List = append(template.List, TemplatePart{tpl, p.parseExpression(OpExpr)})
	}
	if p.tt != TemplateToken && p.tt != TemplateEndToken {
		p.fail("template literal", TemplateToken)
		return
	}
	template.Tail = p.data
	p.next() // TemplateEndToken
	return
}

func (p *Parser) parseArguments() (args Args) {
	// assume we're on (
	p.next()
	args.List = make([]Arg, 0, 4)
	for {
		rest := p.tt == EllipsisToken
		if rest {
			p.next()
		}

		if p.tt == CloseParenToken || p.tt == ErrorToken {
			break
		}
		args.List = append(args.List, Arg{
			Value: p.parseExpression(OpAssign),
			Rest:  rest,
		})
		if p.tt == CommaToken {
			p.next()
		}
	}
	p.consume("arguments", CloseParenToken)
	return
}

func (p *Parser) parseAsyncArrowFunc() (arrowFunc *ArrowFunc) {
	// expect we're at Identifier or Yield or (
	arrowFunc = &ArrowFunc{}
	parent := p.enterScope(&arrowFunc.Body.Scope, true)
	parentAwait, parentYield := p.await, p.yield
	p.await, p.yield = true, false

	if IsIdentifier(p.tt) || !p.yield && p.tt == YieldToken {
		ref, _ := p.scope.Declare(ArgumentDecl, p.data) // cannot fail
		p.next()
		arrowFunc.Params.List = []BindingElement{{Binding: ref}}
	} else {
		arrowFunc.Params = p.parseFuncParams("arrow function")

		// could be CallExpression of: async(params)
		if p.tt != ArrowToken {
			// TODO?
		}
	}

	p.await, p.yield = true, parentYield
	arrowFunc.Async = true
	arrowFunc.Body.List = p.parseArrowFuncBody()

	p.await, p.yield = parentAwait, parentYield
	p.exitScope(parent)
	return
}

func (p *Parser) parseIdentifierArrowFunc(v *Var) (arrowFunc *ArrowFunc) {
	// expect we're at =>
	arrowFunc = &ArrowFunc{}
	parent := p.enterScope(&arrowFunc.Body.Scope, true)
	parentAwait, parentYield := p.await, p.yield

	if 1 < v.Uses {
		v.Uses--
		v, _ = p.scope.Declare(ArgumentDecl, parse.Copy(v.Data)) // cannot fail
	} else {
		// if v.Uses==1 it must be undeclared and be the last added
		p.scope.Parent.Undeclared = p.scope.Parent.Undeclared[:len(p.scope.Parent.Undeclared)-1]
		v.Decl = ArgumentDecl
		p.scope.Declared = append(p.scope.Declared, v)
	}

	p.await = false
	arrowFunc.Params.List = []BindingElement{{v, nil}}
	arrowFunc.Body.List = p.parseArrowFuncBody()

	p.await, p.yield = parentAwait, parentYield
	p.exitScope(parent)
	return
}

func (p *Parser) parseArrowFuncBody() (list []IStmt) {
	// expect we're at arrow
	if p.tt != ArrowToken {
		p.fail("arrow function", ArrowToken)
		return
	} else if p.prevLT {
		p.fail("expression")
		return
	}
	p.next()

	// mark undeclared vars as arguments in `function f(a=b){var b}` where the b's are different vars
	p.scope.MarkFuncArgs()

	if p.tt == OpenBraceToken {
		parentInFor := p.inFor
		p.inFor = false
		p.yield = false
		p.allowDirectivePrologue = true
		list = p.parseStmtList("arrow function")
		p.inFor = parentInFor
	} else {
		list = []IStmt{&ReturnStmt{p.parseExpression(OpAssign)}}
	}
	return
}

func (p *Parser) parseIdentifierExpression(prec OpPrec, ident []byte) IExpr {
	var left IExpr
	left = p.scope.Use(ident)
	return p.parseExpressionSuffix(left, prec, OpPrimary)
}

func (p *Parser) parseAsyncExpression(prec OpPrec, async []byte) IExpr {
	// assume we're at a token after async
	var left IExpr
	precLeft := OpPrimary
	if !p.prevLT && p.tt == FunctionToken {
		// primary expression
		left = p.parseAsyncFuncExpr()
	} else if !p.prevLT && prec <= OpAssign && (p.tt == OpenParenToken || IsIdentifier(p.tt) || !p.yield && p.tt == YieldToken || p.tt == AwaitToken) {
		// async arrow function expression
		if p.tt == AwaitToken {
			p.fail("arrow function")
			return nil
		} else if p.tt == OpenParenToken {
			return p.parseParenthesizedExpressionOrArrowFunc(prec, async)
		}
		left = p.parseAsyncArrowFunc()
		precLeft = OpAssign
	} else {
		left = p.scope.Use(async)
	}
	return p.parseExpressionSuffix(left, prec, precLeft)
}

// parseExpression parses an expression that has a precedence of prec or higher.
func (p *Parser) parseExpression(prec OpPrec) IExpr {
	p.exprLevel++
	if 1000 < p.exprLevel {
		p.failMessage("too many nested expressions")
		return nil
	}

	// reparse input if we have / or /= as the beginning of a new expression, this should be a regular expression!
	if p.tt == DivToken || p.tt == DivEqToken {
		p.tt, p.data = p.l.RegExp()
		if p.tt == ErrorToken {
			p.fail("regular expression")
			return nil
		}
	}

	var left IExpr
	precLeft := OpPrimary

	if IsIdentifier(p.tt) && p.tt != AsyncToken {
		left = p.scope.Use(p.data)
		p.next()
		suffix := p.parseExpressionSuffix(left, prec, precLeft)
		p.exprLevel--
		return suffix
	} else if IsNumeric(p.tt) {
		left = &LiteralExpr{p.tt, p.data}
		p.next()
		suffix := p.parseExpressionSuffix(left, prec, precLeft)
		p.exprLevel--
		return suffix
	}

	switch tt := p.tt; tt {
	case StringToken, ThisToken, NullToken, TrueToken, FalseToken, RegExpToken:
		left = &LiteralExpr{p.tt, p.data}
		p.next()
	case OpenBracketToken:
		parentInFor := p.inFor
		p.inFor = false
		array := p.parseArrayLiteral()
		left = &array
		p.inFor = parentInFor
	case OpenBraceToken:
		parentInFor := p.inFor
		p.inFor = false
		object := p.parseObjectLiteral()
		left = &object
		p.inFor = parentInFor
	case OpenParenToken:
		// parenthesized expression or arrow parameter list
		if OpAssign < prec {
			// must be a parenthesized expression
			p.next()
			parentInFor := p.inFor
			p.inFor = false
			left = &GroupExpr{p.parseExpression(OpExpr)}
			p.inFor = parentInFor
			if !p.consume("expression", CloseParenToken) {
				return nil
			}
			break
		}
		suffix := p.parseParenthesizedExpressionOrArrowFunc(prec, nil)
		p.exprLevel--
		return suffix
	case NotToken, BitNotToken, TypeofToken, VoidToken, DeleteToken:
		if OpUnary < prec {
			p.fail("expression")
			return nil
		}
		p.next()
		left = &UnaryExpr{tt, p.parseExpression(OpUnary)}
		precLeft = OpUnary
	case AddToken:
		if OpUnary < prec {
			p.fail("expression")
			return nil
		}
		p.next()
		left = &UnaryExpr{PosToken, p.parseExpression(OpUnary)}
		precLeft = OpUnary
	case SubToken:
		if OpUnary < prec {
			p.fail("expression")
			return nil
		}
		p.next()
		left = &UnaryExpr{NegToken, p.parseExpression(OpUnary)}
		precLeft = OpUnary
	case IncrToken:
		if OpUpdate < prec {
			p.fail("expression")
			return nil
		}
		p.next()
		left = &UnaryExpr{PreIncrToken, p.parseExpression(OpUnary)}
		precLeft = OpUnary
	case DecrToken:
		if OpUpdate < prec {
			p.fail("expression")
			return nil
		}
		p.next()
		left = &UnaryExpr{PreDecrToken, p.parseExpression(OpUnary)}
		precLeft = OpUnary
	case AwaitToken:
		// either accepted as IdentifierReference or as AwaitExpression
		if p.await && prec <= OpUnary {
			p.next()
			left = &UnaryExpr{tt, p.parseExpression(OpUnary)}
			precLeft = OpUnary
		} else if p.await {
			p.fail("expression")
			return nil
		} else {
			left = p.scope.Use(p.data)
			p.next()
		}
	case NewToken:
		p.next()
		if p.tt == DotToken {
			p.next()
			if !p.consume("new.target expression", TargetToken) {
				return nil
			}
			left = &NewTargetExpr{}
			precLeft = OpMember
		} else {
			newExpr := &NewExpr{p.parseExpression(OpNew), nil}
			if p.tt == OpenParenToken {
				args := p.parseArguments()
				if len(args.List) != 0 {
					newExpr.Args = &args
				}
				precLeft = OpMember
			} else {
				precLeft = OpNew
			}
			left = newExpr
		}
	case ImportToken:
		// OpMember < prec does never happen
		left = &LiteralExpr{p.tt, p.data}
		p.next()
		if p.tt == DotToken {
			p.next()
			if !p.consume("import.meta expression", MetaToken) {
				return nil
			}
			left = &ImportMetaExpr{}
			precLeft = OpMember
		} else if p.tt != OpenParenToken {
			p.fail("import expression", OpenParenToken)
			return nil
		} else if OpCall < prec {
			p.fail("expression")
			return nil
		} else {
			precLeft = OpCall
		}
	case SuperToken:
		// OpMember < prec does never happen
		left = &LiteralExpr{p.tt, p.data}
		p.next()
		if OpCall < prec && p.tt != DotToken && p.tt != OpenBracketToken {
			p.fail("super expression", OpenBracketToken, DotToken)
			return nil
		} else if p.tt != DotToken && p.tt != OpenBracketToken && p.tt != OpenParenToken {
			p.fail("super expression", OpenBracketToken, OpenParenToken, DotToken)
			return nil
		}
		if OpCall < prec {
			precLeft = OpMember
		} else {
			precLeft = OpCall
		}
	case YieldToken:
		// either accepted as IdentifierReference or as YieldExpression
		if p.yield && prec <= OpAssign {
			// YieldExpression
			p.next()
			yieldExpr := YieldExpr{}
			if !p.prevLT {
				yieldExpr.Generator = p.tt == MulToken
				if yieldExpr.Generator {
					p.next()
					yieldExpr.X = p.parseExpression(OpAssign)
				} else if p.tt != CloseBraceToken && p.tt != CloseBracketToken && p.tt != CloseParenToken && p.tt != ColonToken && p.tt != CommaToken && p.tt != SemicolonToken {
					yieldExpr.X = p.parseExpression(OpAssign)
				}
			}
			left = &yieldExpr
			precLeft = OpAssign
		} else if p.yield {
			p.fail("expression")
			return nil
		} else {
			left = p.scope.Use(p.data)
			p.next()
		}
	case AsyncToken:
		async := p.data
		p.next()
		left = p.parseAsyncExpression(prec, async)
	case ClassToken:
		parentInFor := p.inFor
		p.inFor = false
		left = p.parseClassExpr()
		p.inFor = parentInFor
	case FunctionToken:
		parentInFor := p.inFor
		p.inFor = false
		left = p.parseFuncExpr()
		p.inFor = parentInFor
	case TemplateToken, TemplateStartToken:
		parentInFor := p.inFor
		p.inFor = false
		template := p.parseTemplateLiteral(precLeft)
		left = &template
		p.inFor = parentInFor
	default:
		p.fail("expression")
		return nil
	}
	suffix := p.parseExpressionSuffix(left, prec, precLeft)
	p.exprLevel--
	return suffix
}

func (p *Parser) parseExpressionSuffix(left IExpr, prec, precLeft OpPrec) IExpr {
	for i := 0; ; i++ {
		if 1000 < p.exprLevel+i {
			p.failMessage("too many nested expressions")
			return nil
		}

		switch tt := p.tt; tt {
		case EqToken, MulEqToken, DivEqToken, ModEqToken, ExpEqToken, AddEqToken, SubEqToken, LtLtEqToken, GtGtEqToken, GtGtGtEqToken, BitAndEqToken, BitXorEqToken, BitOrEqToken, AndEqToken, OrEqToken, NullishEqToken:
			if OpAssign < prec {
				return left
			} else if precLeft < OpLHS {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpAssign)}
			precLeft = OpAssign
		case LtToken, LtEqToken, GtToken, GtEqToken, InToken, InstanceofToken:
			if OpCompare < prec || p.inFor && tt == InToken {
				return left
			} else if precLeft < OpCompare {
				// can only fail after a yield or arrow function expression
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpShift)}
			precLeft = OpCompare
		case EqEqToken, NotEqToken, EqEqEqToken, NotEqEqToken:
			if OpEquals < prec {
				return left
			} else if precLeft < OpEquals {
				// can only fail after a yield or arrow function expression
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpCompare)}
			precLeft = OpEquals
		case AndToken:
			if OpAnd < prec {
				return left
			} else if precLeft < OpAnd {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpBitOr)}
			precLeft = OpAnd
		case OrToken:
			if OpOr < prec {
				return left
			} else if precLeft < OpOr {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpAnd)}
			precLeft = OpOr
		case NullishToken:
			if OpCoalesce < prec {
				return left
			} else if precLeft < OpBitOr && precLeft != OpCoalesce {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpBitOr)}
			precLeft = OpCoalesce
		case DotToken:
			// OpMember < prec does never happen
			if precLeft < OpCall {
				p.fail("expression")
				return nil
			}
			p.next()
			if !IsIdentifierName(p.tt) && p.tt != PrivateIdentifierToken {
				p.fail("dot expression", IdentifierToken)
				return nil
			}
			exprPrec := OpMember
			if precLeft < OpMember {
				exprPrec = OpCall
			}
			if p.tt != PrivateIdentifierToken {
				p.tt = IdentifierToken
			}
			left = &DotExpr{left, LiteralExpr{p.tt, p.data}, exprPrec, false}
			p.next()
			if precLeft < OpMember {
				precLeft = OpCall
			} else {
				precLeft = OpMember
			}
		case OpenBracketToken:
			// OpMember < prec does never happen
			if precLeft < OpCall {
				p.fail("expression")
				return nil
			}
			p.next()
			exprPrec := OpMember
			if precLeft < OpMember {
				exprPrec = OpCall
			}
			parentInFor := p.inFor
			p.inFor = false
			left = &IndexExpr{left, p.parseExpression(OpExpr), exprPrec, false}
			p.inFor = parentInFor
			if !p.consume("index expression", CloseBracketToken) {
				return nil
			}
			if precLeft < OpMember {
				precLeft = OpCall
			} else {
				precLeft = OpMember
			}
		case OpenParenToken:
			if OpCall < prec {
				return left
			} else if precLeft < OpCall {
				p.fail("expression")
				return nil
			}
			parentInFor := p.inFor
			p.inFor = false
			left = &CallExpr{left, p.parseArguments(), false}
			precLeft = OpCall
			p.inFor = parentInFor
		case TemplateToken, TemplateStartToken:
			// OpMember < prec does never happen
			if precLeft < OpCall {
				p.fail("expression")
				return nil
			}
			parentInFor := p.inFor
			p.inFor = false
			template := p.parseTemplateLiteral(precLeft)
			template.Tag = left
			left = &template
			if precLeft < OpMember {
				precLeft = OpCall
			} else {
				precLeft = OpMember
			}
			p.inFor = parentInFor
		case OptChainToken:
			if OpCall < prec {
				return left
			}
			p.next()
			if p.tt == OpenParenToken {
				left = &CallExpr{left, p.parseArguments(), true}
			} else if p.tt == OpenBracketToken {
				p.next()
				left = &IndexExpr{left, p.parseExpression(OpExpr), OpCall, true}
				if !p.consume("optional chaining expression", CloseBracketToken) {
					return nil
				}
			} else if p.tt == TemplateToken || p.tt == TemplateStartToken {
				template := p.parseTemplateLiteral(precLeft)
				template.Prec = OpCall
				template.Tag = left
				template.Optional = true
				left = &template
			} else if IsIdentifierName(p.tt) {
				left = &DotExpr{left, LiteralExpr{IdentifierToken, p.data}, OpCall, true}
				p.next()
			} else if p.tt == PrivateIdentifierToken {
				left = &DotExpr{left, LiteralExpr{p.tt, p.data}, OpCall, true}
				p.next()
			} else {
				p.fail("optional chaining expression", IdentifierToken, OpenParenToken, OpenBracketToken, TemplateToken)
				return nil
			}
			precLeft = OpCall
		case IncrToken:
			if p.prevLT || OpUpdate < prec {
				return left
			} else if precLeft < OpLHS {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &UnaryExpr{PostIncrToken, left}
			precLeft = OpUpdate
		case DecrToken:
			if p.prevLT || OpUpdate < prec {
				return left
			} else if precLeft < OpLHS {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &UnaryExpr{PostDecrToken, left}
			precLeft = OpUpdate
		case ExpToken:
			if OpExp < prec {
				return left
			} else if precLeft < OpUpdate {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpExp)}
			precLeft = OpExp
		case MulToken, DivToken, ModToken:
			if OpMul < prec {
				return left
			} else if precLeft < OpMul {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpExp)}
			precLeft = OpMul
		case AddToken, SubToken:
			if OpAdd < prec {
				return left
			} else if precLeft < OpAdd {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpMul)}
			precLeft = OpAdd
		case LtLtToken, GtGtToken, GtGtGtToken:
			if OpShift < prec {
				return left
			} else if precLeft < OpShift {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpAdd)}
			precLeft = OpShift
		case BitAndToken:
			if OpBitAnd < prec {
				return left
			} else if precLeft < OpBitAnd {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpEquals)}
			precLeft = OpBitAnd
		case BitXorToken:
			if OpBitXor < prec {
				return left
			} else if precLeft < OpBitXor {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpBitAnd)}
			precLeft = OpBitXor
		case BitOrToken:
			if OpBitOr < prec {
				return left
			} else if precLeft < OpBitOr {
				p.fail("expression")
				return nil
			}
			p.next()
			left = &BinaryExpr{tt, left, p.parseExpression(OpBitXor)}
			precLeft = OpBitOr
		case QuestionToken:
			if OpAssign < prec {
				return left
			} else if precLeft < OpCoalesce {
				p.fail("expression")
				return nil
			}
			p.next()
			ifExpr := p.parseExpression(OpAssign)
			if !p.consume("conditional expression", ColonToken) {
				return nil
			}
			elseExpr := p.parseExpression(OpAssign)
			left = &CondExpr{left, ifExpr, elseExpr}
			precLeft = OpAssign
		case CommaToken:
			if OpExpr < prec {
				return left
			}
			p.next()
			if commaExpr, ok := left.(*CommaExpr); ok {
				commaExpr.List = append(commaExpr.List, p.parseExpression(OpAssign))
				i-- // adjust expression nesting limit
			} else {
				left = &CommaExpr{[]IExpr{left, p.parseExpression(OpAssign)}}
			}
			precLeft = OpExpr
		case ArrowToken:
			// handle identifier => ..., where identifier could also be yield or await
			if OpAssign < prec {
				return left
			} else if precLeft < OpPrimary {
				p.fail("expression")
				return nil
			}

			v, ok := left.(*Var)
			if !ok {
				p.fail("expression")
				return nil
			}

			left = p.parseIdentifierArrowFunc(v)
			precLeft = OpAssign
		default:
			return left
		}
	}
}

func (p *Parser) parseAssignmentExpression() IExpr {
	// this could be a BindingElement or an AssignmentExpression. Here we handle BindingIdentifier with a possible Initializer, BindingPattern will be handled by parseArrayLiteral or parseObjectLiteral
	if p.assumeArrowFunc && p.isIdentifierReference(p.tt) {
		tt := p.tt
		data := p.data
		p.next()
		if p.tt == EqToken || p.tt == CommaToken || p.tt == CloseParenToken || p.tt == CloseBraceToken || p.tt == CloseBracketToken {
			var ok bool
			var left IExpr
			left, ok = p.scope.Declare(ArgumentDecl, data)
			if ok {
				p.assumeArrowFunc = false
				left = p.parseExpressionSuffix(left, OpAssign, OpPrimary)
				p.assumeArrowFunc = true
				return left
			}
		}
		p.assumeArrowFunc = false
		if tt == AsyncToken {
			return p.parseAsyncExpression(OpAssign, data)
		}
		return p.parseIdentifierExpression(OpAssign, data)
	} else if p.tt != OpenBracketToken && p.tt != OpenBraceToken {
		p.assumeArrowFunc = false
	}
	return p.parseExpression(OpAssign)
}

func (p *Parser) parseParenthesizedExpressionOrArrowFunc(prec OpPrec, async []byte) IExpr {
	var left IExpr
	precLeft := OpPrimary

	// expect to be at (
	p.next()

	isAsync := async != nil
	arrowFunc := &ArrowFunc{}
	parent := p.enterScope(&arrowFunc.Body.Scope, true)
	parentAssumeArrowFunc, parentInFor := p.assumeArrowFunc, p.inFor
	p.assumeArrowFunc, p.inFor = true, false

	// parse a parenthesized expression but assume we might be parsing an (async) arrow function. If this is really an arrow function, parsing as a parenthesized expression cannot fail as AssignmentExpression, ArrayLiteral, and ObjectLiteral are supersets of SingleNameBinding, ArrayBindingPattern, and ObjectBindingPattern respectively. Any identifier that would be a BindingIdentifier in case of an arrow function, will be added as such. If finally this is not an arrow function, we will demote those variables an undeclared and merge them with the parent scope.

	var list []IExpr
	var rest IExpr
	for p.tt != CloseParenToken && p.tt != ErrorToken {
		if p.tt == EllipsisToken && p.assumeArrowFunc {
			p.next()
			if isAsync {
				rest = p.parseAssignmentExpression()
				if p.tt == CommaToken {
					p.next()
				}
			} else if p.isIdentifierReference(p.tt) {
				var ok bool
				rest, ok = p.scope.Declare(ArgumentDecl, p.data)
				if !ok {
					p.failMessage("identifier %s has already been declared", string(p.data))
					return nil
				}
				p.next()
			} else if p.tt == OpenBracketToken {
				array := p.parseArrayLiteral()
				rest = &array
			} else if p.tt == OpenBraceToken {
				object := p.parseObjectLiteral()
				rest = &object
			} else {
				p.fail("arrow function")
				return nil
			}
			break
		}

		list = append(list, p.parseAssignmentExpression())
		if p.tt != CommaToken {
			break
		}
		p.next()
	}
	if p.tt != CloseParenToken {
		p.fail("expression")
		return nil
	}
	p.next()
	isArrowFunc := p.tt == ArrowToken && p.assumeArrowFunc
	p.assumeArrowFunc, p.inFor = parentAssumeArrowFunc, parentInFor

	if isArrowFunc {
		parentAwait, parentYield := p.await, p.yield
		p.await = isAsync

		// arrow function
		arrowFunc.Params = Params{List: make([]BindingElement, len(list))}
		for i, item := range list {
			arrowFunc.Params.List[i] = p.exprToBindingElement(item) // can not fail when assumArrowFunc is set
		}
		arrowFunc.Async = isAsync
		arrowFunc.Params.Rest = p.exprToBinding(rest)
		arrowFunc.Body.List = p.parseArrowFuncBody()

		p.await, p.yield = parentAwait, parentYield
		p.exitScope(parent)

		left = arrowFunc
		precLeft = OpAssign
	} else if len(list) == 0 || !isAsync && rest != nil || isAsync && OpCall < prec {
		p.fail("arrow function", ArrowToken)
		return nil
	} else {
		p.exitScope(parent)

		// for any nested FuncExpr/ArrowFunc scope, Parent will point to the temporary scope created in case this was an arrow function instead of a parenthesized expression. This is not a problem as Parent is only used for defining new variables, and we already parsed all the nested scopes so that Parent (not Func) are not relevant anymore. Anyways, the Parent will just point to an empty scope, whose Parent/Func will point to valid scopes. This should not be a big deal.
		// Here we move all declared ArgumentDecls (in case of an arrow function) to its parent scope as undeclared variables (identifiers used in a parenthesized expression).
		arrowFunc.Body.Scope.UndeclareScope()

		if isAsync {
			// call expression
			args := Args{}
			for _, item := range list {
				args.List = append(args.List, Arg{Value: item, Rest: false})
			}
			if rest != nil {
				args.List = append(args.List, Arg{Value: rest, Rest: true})
			}
			left = p.scope.Use(async)
			left = &CallExpr{left, args, false}
			precLeft = OpCall
		} else {
			// parenthesized expression
			if 1 < len(list) {
				left = &GroupExpr{&CommaExpr{list}}
			} else {
				left = &GroupExpr{list[0]}
			}
		}
	}
	return p.parseExpressionSuffix(left, prec, precLeft)
}

// exprToBinding converts a CoverParenthesizedExpressionAndArrowParameterList into FormalParameters
// Any unbound variables of the parameters (Initializer, ComputedPropertyName) are kept in the parent scope
func (p *Parser) exprToBinding(expr IExpr) (binding IBinding) {
	if v, ok := expr.(*Var); ok {
		binding = v
	} else if array, ok := expr.(*ArrayExpr); ok {
		bindingArray := BindingArray{}
		for _, item := range array.List {
			if item.Spread {
				// can only BindingIdentifier or BindingPattern
				bindingArray.Rest = p.exprToBinding(item.Value)
				break
			}
			var bindingElement BindingElement
			bindingElement = p.exprToBindingElement(item.Value)
			bindingArray.List = append(bindingArray.List, bindingElement)
		}
		binding = &bindingArray
	} else if object, ok := expr.(*ObjectExpr); ok {
		bindingObject := BindingObject{}
		for _, item := range object.List {
			if item.Spread {
				// can only be BindingIdentifier
				bindingObject.Rest = item.Value.(*Var)
				break
			}
			var bindingElement BindingElement
			bindingElement.Binding = p.exprToBinding(item.Value)
			if bindingElement.Binding == nil {
				bindingElement = p.exprToBindingElement(item.Value)
			} else if item.Init != nil {
				bindingElement.Default = item.Init
			}
			bindingObject.List = append(bindingObject.List, BindingObjectItem{Key: item.Name, Value: bindingElement})
		}
		binding = &bindingObject
	}
	return
}

func (p *Parser) exprToBindingElement(expr IExpr) (bindingElement BindingElement) {
	if assign, ok := expr.(*BinaryExpr); ok && assign.Op == EqToken {
		bindingElement.Binding = p.exprToBinding(assign.X)
		bindingElement.Default = assign.Y
	} else {
		bindingElement.Binding = p.exprToBinding(expr)
	}
	return
}

func (p *Parser) isIdentifierReference(tt TokenType) bool {
	return IsIdentifier(tt) || tt == YieldToken && !p.yield || tt == AwaitToken && !p.await
}
