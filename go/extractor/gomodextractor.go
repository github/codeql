package extractor

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/mod/modfile"

	"github.com/github/codeql-go/extractor/dbscheme"
	"github.com/github/codeql-go/extractor/srcarchive"
	"github.com/github/codeql-go/extractor/trap"
)

func (extraction *Extraction) extractGoMod(path string) error {
	if normPath, err := filepath.EvalSymlinks(path); err == nil {
		path = normPath
	}

	extraction.Lock.Lock()
	if extraction.SeenGoMods[path] {
		extraction.Lock.Unlock()
		return nil
	}

	extraction.SeenGoMods[path] = true
	extraction.Lock.Unlock()

	tw, err := trap.NewWriter(path, nil)
	if err != nil {
		return err
	}
	defer tw.Close()

	err = srcarchive.Add(path)
	if err != nil {
		return err
	}

	extraction.extractFileInfo(tw, path, false)

	file, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("failed to open go.mod file %s: %s", path, err.Error())
	}
	data, err := io.ReadAll(file)
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

type commentGroupIdxAllocator struct {
	nextIdx int
}

func (cgIdxAlloc *commentGroupIdxAllocator) nextCgIdx() int {
	ret := cgIdxAlloc.nextIdx
	cgIdxAlloc.nextIdx++
	return ret
}

func extractGoModFile(tw *trap.Writer, file *modfile.FileSyntax) {
	cgIdxAlloc := commentGroupIdxAllocator{0}

	for idx, stmt := range file.Stmt {
		extractGoModExpr(tw, stmt, tw.Labeler.FileLabel(), idx, &cgIdxAlloc)
	}

	extractGoModComments(tw, file, tw.Labeler.FileLabel(), &cgIdxAlloc)
}

func extractGoModExpr(tw *trap.Writer, expr modfile.Expr, parent trap.Label, idx int, cgIdxAlloc *commentGroupIdxAllocator) {
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
		extractGoModExpr(tw, &expr.LParen, lbl, 0, cgIdxAlloc)
		for idx, line := range expr.Line {
			extractGoModExpr(tw, line, lbl, idx+1, cgIdxAlloc)
		}
		extractGoModExpr(tw, &expr.RParen, lbl, len(expr.Line)+1, cgIdxAlloc)
	default:
		log.Fatalf("unknown go.mod expression of type %T", expr)
	}

	dbscheme.ModExprsTable.Emit(tw, lbl, kind, parent, idx)

	extractGoModComments(tw, expr, lbl, cgIdxAlloc)

	start, end := expr.Span()
	extractLocation(tw, lbl, start.Line, start.LineRune, end.Line, end.LineRune)
}

type GoModExprCommentWrapper struct {
	expr modfile.Expr
}

func minInt(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

func maxInt(a int, b int) int {
	if a > b {
		return a
	}
	return b
}

func lexMin(a1 int, a2 int, b1 int, b2 int) (int, int) {
	if a1 < b1 {
		return a1, a2
	} else if a1 > b1 {
		return b1, b2
	} else {
		return a1, minInt(b1, b2)
	}
}

func lexMax(a1 int, a2 int, b1 int, b2 int) (int, int) {
	if a1 < b1 {
		return b1, b2
	} else if a1 > b1 {
		return a1, a2
	} else {
		return a1, maxInt(b1, b2)
	}
}

func extractGoModComments(tw *trap.Writer, expr modfile.Expr, exprlbl trap.Label, cgIdxAlloc *commentGroupIdxAllocator) {
	comments := expr.Comment()

	if len(comments.Before) == 0 && len(comments.Suffix) == 0 && len(comments.After) == 0 {
		return
	}

	// extract a pseudo `@commentgroup` for each expr that contains their associated comments
	grouplbl := tw.Labeler.LocalID(GoModExprCommentWrapper{expr})
	dbscheme.CommentGroupsTable.Emit(tw, grouplbl, tw.Labeler.FileLabel(), cgIdxAlloc.nextCgIdx())
	dbscheme.DocCommentsTable.Emit(tw, exprlbl, grouplbl)

	var allComments []modfile.Comment
	allComments = append(allComments, comments.Before...)
	allComments = append(allComments, comments.Suffix...)
	allComments = append(allComments, comments.After...)

	var startLine, startCol, endLine, endCol int = 0, 0, 0, 0
	var first bool = true
	idx := 0
	for _, comment := range allComments {
		commentToken := strings.TrimSuffix(strings.TrimSuffix(comment.Token, "\n"), "\r")
		extractGoModComment(tw, comment, commentToken, grouplbl, idx)
		idx++
		commentEndCol := comment.Start.LineRune + (len(commentToken) - 1)
		if first {
			startLine, startCol, endLine, endCol = comment.Start.Line, comment.Start.LineRune, comment.Start.Line, commentEndCol
			first = false
		} else {
			startLine, startCol = lexMin(comment.Start.Line, comment.Start.LineRune, startLine, startCol)
			endLine, endCol = lexMax(comment.Start.Line, commentEndCol, endLine, endCol)
		}
	}

	extractLocation(tw, grouplbl, startLine, startCol, endLine, endCol)
}

func extractGoModComment(tw *trap.Writer, comment modfile.Comment, commentToken string, grouplbl trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(comment)
	dbscheme.CommentsTable.Emit(tw, lbl, dbscheme.SlashSlashComment.Index(), grouplbl, idx, commentToken)

	extractLocation(tw, lbl, comment.Start.Line, comment.Start.LineRune, comment.Start.Line, comment.Start.LineRune+(len(commentToken)-1))
}
