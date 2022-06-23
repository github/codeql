package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"go/scanner"
	"go/token"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

func main() {
	flag.Parse()

	fs := token.NewFileSet()
	csv := csv.NewWriter(os.Stdout)
	defer csv.Flush()

	for _, fileName := range flag.Args() {
		src, err := ioutil.ReadFile(fileName)
		if err != nil {
			log.Fatalf("Unable to read file %s.", fileName)
		}
		f := fs.AddFile(fileName, -1, len(src))

		var s scanner.Scanner
		s.Init(f, src, nil, 0)
		for {
			beginPos, tok, text := s.Scan()

			if strings.TrimSpace(text) != "" {
				var fuzzyText string
				if tok.IsLiteral() {
					fuzzyText = tok.String()
				} else {
					fuzzyText = text
				}

				endPos := f.Pos(f.Offset(beginPos) + len(text))
				beginLine := fmt.Sprintf("%d", f.Position(beginPos).Line)
				beginColumn := fmt.Sprintf("%d", f.Position(beginPos).Column)
				endLine := fmt.Sprintf("%d", f.Position(endPos).Line)
				endColumn := fmt.Sprintf("%d", f.Position(endPos).Column)
				err = csv.Write([]string{text, fuzzyText, beginLine, beginColumn, endLine, endColumn})
				if err != nil {
					log.Fatalf("Unable to write CSV data: %v", err)
				}
			}
			if tok == token.EOF {
				break
			}
		}
	}
}
