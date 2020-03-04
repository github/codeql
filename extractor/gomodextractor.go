package extractor

import (
	"fmt"
	"golang.org/x/mod/modfile"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/github/codeql-go/extractor/dbscheme"
	"github.com/github/codeql-go/extractor/srcarchive"
	"github.com/github/codeql-go/extractor/trap"
)

func extractGoMod(path string) error {

	if normPath, err := filepath.EvalSymlinks(path); err == nil {
		path = normPath
	}

	tw, err := trap.NewWriter(path, nil)
	if err != nil {
		return err
	}
	defer tw.Close()

	err = srcarchive.Add(path)
	if err != nil {
		return err
	}

	extractFileInfo(tw, path)

	file, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("failed to open go.mod file %s: %s", path, err.Error())
	}
	data, err := ioutil.ReadAll(file)
	if err != nil {
		return fmt.Errorf("failed to read go.mod file %s: %s", path, err.Error())
	}

	modfile, err := modfile.Parse(path, data, nil)
	if err != nil {
		return fmt.Errorf("failed to parse go.mod file %s: %s", path, err.Error())
	}

	extractGoModFile(tw, modfile.Syntax)

	return nil
}

func extractGoModFile(tw *trap.Writer, file *modfile.FileSyntax) {
	for idx, stmt := range file.Stmt {
		extractGoModExpr(tw, stmt, tw.Labeler.FileLabel(), idx)
	}

	extractGoModComments(tw, file, tw.Labeler.FileLabel())
}

func extractGoModExpr(tw *trap.Writer, expr modfile.Expr, parent trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(expr)

	var kind int
	switch expr := expr.(type) {
	case *modfile.CommentBlock:
		kind = dbscheme.ModCommentBlockType.Index()
	case *modfile.LParen:
		kind = dbscheme.ModLParenType.Index()
	case *modfile.RParen:
		kind = dbscheme.ModRParenType.Index()
	case *modfile.Line:
		kind = dbscheme.ModLineType.Index()
		for idx, tok := range expr.Token {
			dbscheme.ModTokensTable.Emit(tw, tok, lbl, idx)
		}
	case *modfile.LineBlock:
		kind = dbscheme.ModLineBlockType.Index()
		for idx, tok := range expr.Token {
			dbscheme.ModTokensTable.Emit(tw, tok, lbl, idx)
		}
		extractGoModExpr(tw, &expr.LParen, lbl, 0)
		for idx, line := range expr.Line {
			extractGoModExpr(tw, line, lbl, idx+1)
		}
		extractGoModExpr(tw, &expr.RParen, lbl, len(expr.Line)+1)
	default:
		log.Fatalf("unknown go.mod expression of type %T", expr)
	}

	dbscheme.ModExprsTable.Emit(tw, lbl, kind, parent, idx)

	extractGoModComments(tw, expr, lbl)

	start, end := expr.Span()
	extractLocation(tw, lbl, start.Line, start.LineRune, end.Line, end.LineRune)
}

type GoModExprCommentWrapper struct {
	expr modfile.Expr
}

func extractGoModComments(tw *trap.Writer, expr modfile.Expr, exprlbl trap.Label) {
	// extract a pseudo `@commentgroup` for each expr that contains their associated comments
	grouplbl := tw.Labeler.LocalID(GoModExprCommentWrapper{expr})
	dbscheme.CommentGroupsTable.Emit(tw, grouplbl)
	dbscheme.DocCommentsTable.Emit(tw, exprlbl, grouplbl)

	comments := expr.Comment()

	idx := 0
	for _, comment := range comments.Before {
		extractGoModComment(tw, comment, grouplbl, idx)
		idx++
	}
	for _, comment := range comments.Suffix {
		extractGoModComment(tw, comment, grouplbl, idx)
		idx++
	}
	for _, comment := range comments.After {
		extractGoModComment(tw, comment, grouplbl, idx)
		idx++
	}
}

func extractGoModComment(tw *trap.Writer, comment modfile.Comment, grouplbl trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(comment)
	dbscheme.CommentsTable.Emit(tw, lbl, dbscheme.SlashSlashComment.Index(), grouplbl, idx, comment.Token)

	extractLocation(tw, lbl, comment.Start.Line, comment.Start.LineRune, comment.Start.Line, comment.Start.LineRune+len(comment.Token))
}
