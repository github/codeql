# Markdown Parser and HTML Renderer for Go

[![pkg.go.dev](https://pkg.go.dev/badge/github.com/gomarkdown/markdown)](https://pkg.go.dev/github.com/gomarkdown/markdown)

Package `github.com/gomarkdown/markdown` is a Go library for parsing Markdown text and rendering as HTML.

It's very fast and supports common extensions.

Tutorial: https://blog.kowalczyk.info/article/cxn3/advanced-markdown-processing-in-go.html

Code examples:
* https://onlinetool.io/goplayground/#txO7hJ-ibeU : basic markdown => HTML
* https://onlinetool.io/goplayground/#yFRIWRiu-KL : customize HTML renderer
* https://onlinetool.io/goplayground/#2yV5-HDKBUV : modify AST
* https://onlinetool.io/goplayground/#9fqKwRbuJ04 : customize parser
* https://onlinetool.io/goplayground/#Bk0zTvrzUDR : syntax highlight

Those examples are also in [examples](./examples) directory.

## API Docs:

- https://pkg.go.dev/github.com/gomarkdown/markdown : top level package
- https://pkg.go.dev/github.com/gomarkdown/markdown/ast : defines abstract syntax tree of parsed markdown document
- https://pkg.go.dev/github.com/gomarkdown/markdown/parser : parser
- https://pkg.go.dev/github.com/gomarkdown/markdown/html : html renderer

## Usage

To convert markdown text to HTML using reasonable defaults:

```go
package main

import (
	"os"

	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/ast"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"

	"fmt"
)

var mds = `# header

Sample text.

[link](http://example.com)
`

func mdToHTML(md []byte) []byte {
	// create markdown parser with extensions
	extensions := parser.CommonExtensions | parser.AutoHeadingIDs | parser.NoEmptyLineBeforeBlock
	p := parser.NewWithExtensions(extensions)
	doc := p.Parse(md)

	// create HTML renderer with extensions
	htmlFlags := html.CommonFlags | html.HrefTargetBlank
	opts := html.RendererOptions{Flags: htmlFlags}
	renderer := html.NewRenderer(opts)

	return markdown.Render(doc, renderer)
}

func main() {
	md := []byte(mds)
	html := mdToHTML(md)

	fmt.Printf("--- Markdown:\n%s\n\n--- HTML:\n%s\n", md, html)
}
```

Try it online: https://onlinetool.io/goplayground/#txO7hJ-ibeU

For more documentation read [this guide](https://blog.kowalczyk.info/article/cxn3/advanced-markdown-processing-in-go.html)

Comparing to other markdown parsers: https://babelmark.github.io/

## Sanitize untrusted content

We don't protect against malicious content. When dealing with user-provided
markdown, run renderer HTML through HTML sanitizer such as [Bluemonday](https://github.com/microcosm-cc/bluemonday).

Here's an example of simple usage with Bluemonday:

```go
import (
    "github.com/microcosm-cc/bluemonday"
    "github.com/gomarkdown/markdown"
)

// ...
maybeUnsafeHTML := markdown.ToHTML(md, nil, nil)
html := bluemonday.UGCPolicy().SanitizeBytes(maybeUnsafeHTML)
```

## mdtohtml command-line tool

https://github.com/gomarkdown/mdtohtml is a command-line markdown to html
converter built using this library.

You can also use it as an example of how to use the library.

You can install it with:

    go get -u github.com/gomarkdown/mdtohtml

To run: `mdtohtml input-file [output-file]`

## Features

- **Compatibility**. The Markdown v1.0.3 test suite passes with
  the `--tidy` option. Without `--tidy`, the differences are
  mostly in whitespace and entity escaping, where this package is
  more consistent and cleaner.

- **Common extensions**, including table support, fenced code
  blocks, autolinks, strikethroughs, non-strict emphasis, etc.

- **Safety**. Markdown is paranoid when parsing, making it safe
  to feed untrusted user input without fear of bad things
  happening. The test suite stress tests this and there are no
  known inputs that make it crash. If you find one, please let me
  know and send me the input that does it.

  NOTE: "safety" in this context means _runtime safety only_. In order to
  protect yourself against JavaScript injection in untrusted content, see
  [this example](https://github.com/gomarkdown/markdown#sanitize-untrusted-content).

- **Fast**. It is fast enough to render on-demand in
  most web applications without having to cache the output.

- **Thread safety**. You can run multiple parsers in different
  goroutines without ill effect. There is no dependence on global
  shared state.

- **Minimal dependencies**. Only depends on standard library packages in Go.

- **Standards compliant**. Output successfully validates using the
  W3C validation tool for HTML 4.01 and XHTML 1.0 Transitional.

## Extensions

In addition to the standard markdown syntax, this package
implements the following extensions:

- **Intra-word emphasis supression**. The `_` character is
  commonly used inside words when discussing code, so having
  markdown interpret it as an emphasis command is usually the
  wrong thing. We let you treat all emphasis markers as
  normal characters when they occur inside a word.

- **Tables**. Tables can be created by drawing them in the input
  using a simple syntax:

  ```
  Name    | Age
  --------|------
  Bob     | 27
  Alice   | 23
  ```

  Table footers are supported as well and can be added with equal signs (`=`):

  ```
  Name    | Age
  --------|------
  Bob     | 27
  Alice   | 23
  ========|======
  Total   | 50
  ```

  A cell spanning multiple columns (colspan) is supported, just repeat the pipe symbol:

  ```
  Name    | Age
  --------|------
  Bob     ||
  Alice   | 23
  ========|======
  Total   | 23
  ```


- **Fenced code blocks**. In addition to the normal 4-space
  indentation to mark code blocks, you can explicitly mark them
  and supply a language (to make syntax highlighting simple). Just
  mark it like this:

      ```go
      func getTrue() bool {
          return true
      }
      ```

  You can use 3 or more backticks to mark the beginning of the
  block, and the same number to mark the end of the block.

- **Definition lists**. A simple definition list is made of a single-line
  term followed by a colon and the definition for that term.

      Cat
      : Fluffy animal everyone likes

      Internet
      : Vector of transmission for pictures of cats

  Terms must be separated from the previous definition by a blank line.

- **Footnotes**. A marker in the text that will become a superscript number;
  a footnote definition that will be placed in a list of footnotes at the
  end of the document. A footnote looks like this:

      This is a footnote.[^1]

      [^1]: the footnote text.

- **Autolinking**. We can find URLs that have not been
  explicitly marked as links and turn them into links.

- **Strikethrough**. Use two tildes (`~~`) to mark text that
  should be crossed out.

- **Hard line breaks**. With this extension enabled newlines in the input
  translates into line breaks in the output. This extension is off by default.

- **Non blocking space**. With this extension enabled spaces preceeded by a backslash
  in the input translates non-blocking spaces in the output. This extension is off by default.

- **Smart quotes**. Smartypants-style punctuation substitution is
  supported, turning normal double- and single-quote marks into
  curly quotes, etc.

- **LaTeX-style dash parsing** is an additional option, where `--`
  is translated into `&ndash;`, and `---` is translated into
  `&mdash;`. This differs from most smartypants processors, which
  turn a single hyphen into an ndash and a double hyphen into an
  mdash.

- **Smart fractions**, where anything that looks like a fraction
  is translated into suitable HTML (instead of just a few special
  cases like most smartypant processors). For example, `4/5`
  becomes `<sup>4</sup>&frasl;<sub>5</sub>`, which renders as
  <sup>4</sup>&frasl;<sub>5</sub>.

- **MathJaX Support** is an additional feature which is supported by
  many markdown editor. It translates inline math equations quoted by `$`
  and displays math blocks quoted by `$$` into MathJax compatible format.
  Hyphens (`_`) won't break LaTeX render within a math element any more.

  ```
  $$
  \left[ \begin{array}{a} a^l_1 \\ ⋮ \\ a^l_{d_l} \end{array}\right]
  = \sigma(
   \left[ \begin{matrix}
   	w^l_{1,1} & ⋯  & w^l_{1,d_{l-1}} \\
   	⋮ & ⋱  & ⋮  \\
   	w^l_{d_l,1} & ⋯  & w^l_{d_l,d_{l-1}} \\
   \end{matrix}\right]  ·
   \left[ \begin{array}{x} a^{l-1}_1 \\ ⋮ \\ ⋮ \\ a^{l-1}_{d_{l-1}} \end{array}\right] +
   \left[ \begin{array}{b} b^l_1 \\ ⋮ \\ b^l_{d_l} \end{array}\right])
   $$
  ```

- **Ordered list start number**. With this extension enabled an ordered list will start with
  the number that was used to start it.

- **Super and subscript**. With this extension enabled sequences between ^ will indicate
  superscript and ~ will become a subscript. For example: H~2~O is a liquid, 2^10^ is 1024.

- **Block level attributes** allow setting attributes (ID, classes and key/value pairs) on block
  level elements. The attribute must be enclosed with braces and be put on a line before the
  element.

  ```
  {#id3 .myclass fontsize="tiny"}
  # Header 1
  ```

  Will convert into `<h1 id="id3" class="myclass" fontsize="tiny">Header 1</h1>`.

- **Mmark support**, see <https://mmark.miek.nl/post/syntax/> for all new syntax elements this adds.

## Users

Some tools using this package: https://pkg.go.dev/github.com/gomarkdown/markdown?tab=importedby

## History

markdown is a fork of v2 of https://github.com/russross/blackfriday.

I refactored the API (split into ast/parser/html sub-packages).

Blackfriday itself was based on C implementation [sundown](https://github.com/vmg/sundown) which in turn was based on [libsoldout](http://fossil.instinctive.eu/libsoldout/home).

## License

[Simplified BSD License](LICENSE.txt)
