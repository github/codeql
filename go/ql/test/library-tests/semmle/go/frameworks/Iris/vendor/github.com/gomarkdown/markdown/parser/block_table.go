package parser

import "github.com/gomarkdown/markdown/ast"

// check if the specified position is preceded by an odd number of backslashes
func isBackslashEscaped(data []byte, i int) bool {
	backslashes := 0
	for i-backslashes-1 >= 0 && data[i-backslashes-1] == '\\' {
		backslashes++
	}
	return backslashes&1 == 1
}

func (p *Parser) tableRow(data []byte, columns []ast.CellAlignFlags, header bool) {
	p.AddBlock(&ast.TableRow{})
	col := 0

	i := skipChar(data, 0, '|')

	n := len(data)
	colspans := 0 // keep track of total colspan in this row.
	for col = 0; col < len(columns) && i < n; col++ {
		colspan := 0
		i = skipChar(data, i, ' ')

		cellStart := i

		// If we are in a codespan we should discount any | we see, check for that here and skip ahead.
		if isCode, _ := codeSpan(p, data[i:], 0); isCode > 0 {
			i += isCode - 1
		}

		for i < n && (data[i] != '|' || isBackslashEscaped(data, i)) && data[i] != '\n' {
			i++
		}

		cellEnd := i

		// skip the end-of-cell marker, possibly taking us past end of buffer
		// each _extra_ | means a colspan
		for i < len(data) && data[i] == '|' && !isBackslashEscaped(data, i) {
			i++
			colspan++
		}
		// only colspan > 1 make sense.
		if colspan < 2 {
			colspan = 0
		}

		for cellEnd > cellStart && cellEnd-1 < n && data[cellEnd-1] == ' ' {
			cellEnd--
		}

		block := &ast.TableCell{
			IsHeader: header,
			Align:    columns[col],
			ColSpan:  colspan,
		}
		block.Content = data[cellStart:cellEnd]
		if cellStart == cellEnd && colspans > 0 {
			// an empty cell that we should ignore, it exists because of colspan
			colspans--
		} else {
			p.AddBlock(block)
		}

		if colspan > 0 {
			colspans += colspan - 1
		}
	}

	// pad it out with empty columns to get the right number
	for ; col < len(columns); col++ {
		block := &ast.TableCell{
			IsHeader: header,
			Align:    columns[col],
		}
		p.AddBlock(block)
	}

	// silently ignore rows with too many cells
}

// tableFooter parses the (optional) table footer.
func (p *Parser) tableFooter(data []byte) bool {
	colCount := 1

	// ignore up to 3 spaces
	n := len(data)
	i := skipCharN(data, 0, ' ', 3)
	for ; i < n && data[i] != '\n'; i++ {
		// If we are in a codespan we should discount any | we see, check for that here and skip ahead.
		if isCode, _ := codeSpan(p, data[i:], 0); isCode > 0 {
			i += isCode - 1
		}

		if data[i] == '|' && !isBackslashEscaped(data, i) {
			colCount++
			continue
		}
		// remaining data must be the = character
		if data[i] != '=' {
			return false
		}
	}

	// doesn't look like a table footer
	if colCount == 1 {
		return false
	}

	p.AddBlock(&ast.TableFooter{})

	return true
}

// tableHeaders parses the header. If recognized it will also add a table.
func (p *Parser) tableHeader(data []byte, doRender bool) (size int, columns []ast.CellAlignFlags, table ast.Node) {
	i := 0
	colCount := 1
	headerIsUnderline := true
	headerIsWithEmptyFields := true
	for i = 0; i < len(data) && data[i] != '\n'; i++ {
		// If we are in a codespan we should discount any | we see, check for that here and skip ahead.
		if isCode, _ := codeSpan(p, data[i:], 0); isCode > 0 {
			i += isCode - 1
		}

		if data[i] == '|' && !isBackslashEscaped(data, i) {
			colCount++
		}
		if data[i] != '-' && data[i] != ' ' && data[i] != ':' && data[i] != '|' {
			headerIsUnderline = false
		}
		if data[i] != ' ' && data[i] != '|' {
			headerIsWithEmptyFields = false
		}
	}

	// doesn't look like a table header
	if colCount == 1 {
		return
	}

	// include the newline in the data sent to tableRow
	j := skipCharN(data, i, '\n', 1)
	header := data[:j]

	// column count ignores pipes at beginning or end of line
	if data[0] == '|' {
		colCount--
	}
	{
		tmp := header
		// remove whitespace from the end
		for len(tmp) > 0 {
			lastIdx := len(tmp) - 1
			if tmp[lastIdx] == '\n' || tmp[lastIdx] == ' ' {
				tmp = tmp[:lastIdx]
			} else {
				break
			}
		}
		n := len(tmp)
		if n > 2 && tmp[n-1] == '|' && !isBackslashEscaped(tmp, n-1) {
			colCount--
		}
	}

	// if the header looks like a underline, then we omit the header
	// and parse the first line again as underline
	if headerIsUnderline && !headerIsWithEmptyFields {
		header = nil
		i = 0
	} else {
		i++ // move past newline
	}

	columns = make([]ast.CellAlignFlags, colCount)

	// move on to the header underline
	if i >= len(data) {
		return
	}

	if data[i] == '|' && !isBackslashEscaped(data, i) {
		i++
	}
	i = skipChar(data, i, ' ')

	// each column header is of form: / *:?-+:? *|/ with # dashes + # colons >= 3
	// and trailing | optional on last column
	col := 0
	n := len(data)
	for i < n && data[i] != '\n' {
		dashes := 0

		if data[i] == ':' {
			i++
			columns[col] |= ast.TableAlignmentLeft
			dashes++
		}
		for i < n && data[i] == '-' {
			i++
			dashes++
		}
		if i < n && data[i] == ':' {
			i++
			columns[col] |= ast.TableAlignmentRight
			dashes++
		}
		for i < n && data[i] == ' ' {
			i++
		}
		if i == n {
			return
		}
		// end of column test is messy
		switch {
		case dashes < 1:
			// not a valid column
			return

		case data[i] == '|' && !isBackslashEscaped(data, i):
			// marker found, now skip past trailing whitespace
			col++
			i++
			for i < n && data[i] == ' ' {
				i++
			}

			// trailing junk found after last column
			if col >= colCount && i < len(data) && data[i] != '\n' {
				return
			}

		case (data[i] != '|' || isBackslashEscaped(data, i)) && col+1 < colCount:
			// something else found where marker was required
			return

		case data[i] == '\n':
			// marker is optional for the last column
			col++

		default:
			// trailing junk found after last column
			return
		}
	}
	if col != colCount {
		return
	}

	if doRender {
		table = &ast.Table{}
		p.AddBlock(table)
		if header != nil {
			p.AddBlock(&ast.TableHeader{})
			p.tableRow(header, columns, true)
		}
	}
	size = skipCharN(data, i, '\n', 1)
	return
}

/*
Table:

Name  | Age | Phone
------|-----|---------
Bob   | 31  | 555-1234
Alice | 27  | 555-4321
*/
func (p *Parser) table(data []byte) int {
	i, columns, table := p.tableHeader(data, true)
	if i == 0 {
		return 0
	}

	p.AddBlock(&ast.TableBody{})

	for i < len(data) {
		pipes, rowStart := 0, i
		for ; i < len(data) && data[i] != '\n'; i++ {
			if data[i] == '|' {
				pipes++
			}
		}

		if pipes == 0 {
			i = rowStart
			break
		}

		// include the newline in data sent to tableRow
		i = skipCharN(data, i, '\n', 1)

		if p.tableFooter(data[rowStart:i]) {
			continue
		}

		p.tableRow(data[rowStart:i], columns, false)
	}
	if captionContent, id, consumed := p.caption(data[i:], []byte(captionTable)); consumed > 0 {
		caption := &ast.Caption{}
		p.Inline(caption, captionContent)

		// Some switcheroo to re-insert the parsed table as a child of the captionfigure.
		figure := &ast.CaptionFigure{}
		figure.HeadingID = id
		table2 := &ast.Table{}
		// Retain any block level attributes.
		table2.AsContainer().Attribute = table.AsContainer().Attribute
		children := table.GetChildren()
		ast.RemoveFromTree(table)

		table2.SetChildren(children)
		ast.AppendChild(figure, table2)
		ast.AppendChild(figure, caption)

		p.addChild(figure)
		p.Finalize(figure)

		i += consumed
	}

	return i
}
