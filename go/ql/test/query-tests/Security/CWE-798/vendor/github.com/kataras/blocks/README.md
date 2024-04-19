# Blocks

[![build status](https://img.shields.io/github/workflow/status/kataras/blocks/CI/main?style=for-the-badge)](https://github.com/kataras/blocks/actions) [![report card](https://img.shields.io/badge/report%20card-a%2B-ff3333.svg?style=for-the-badge)](https://goreportcard.com/report/github.com/kataras/blocks) [![godocs](https://img.shields.io/badge/go-%20docs-488AC7.svg?style=for-the-badge)](https://pkg.go.dev/github.com/kataras/blocks)

Blocks is a, simple, Go-idiomatic view engine based on [html/template](https://pkg.go.dev/html/template?tab=doc#Template), plus the following features:

- Compatible with the [fs.FS](https://pkg.go.dev/io/fs#FS), [embed.FS](https://pkg.go.dev/embed#FS) and [http.FileSystem](https://pkg.go.dev/net/http#FileSystem) interface
- Embedded templates through [embed.FS](https://pkg.go.dev/embed#FS) or [go-bindata](https://github.com/go-bindata/go-bindata)
- Load with optional context for cancelation
- Reload templates on development stage
- Full Layouts and Blocks support
- Markdown Content
- Global [FuncMap](https://pkg.go.dev/html/template?tab=doc#FuncMap)

## Installation

The only requirement is the [Go Programming Language](https://golang.org/dl).

```sh
$ go get github.com/kataras/blocks
```

## Getting Started

Create a folder named **./views** and put some HTML template files.

```
│   main.go
└───views
    |   index.html
    ├───layouts
    │       main.html
    ├───partials
    │       footer.html
```

Now, open the **./views/layouts/main.html** file and paste the following:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ if .Title }}{{ .Title }}{{ else }}Default Main Title{{ end }}</title>
</head>
<body>
    {{ template "content" . }}

<footer>{{ partial "partials/footer" .}}</footer>
</body>
</html>
```

The `template "content" .` is a Blocks builtin template function which renders the **main** content of your page that should be rendered under this layout. The block name should always be `"content"`.

The `partial` is a Blocks builtin template function which renders a template inside other template.

The `.` (dot) passes the template's root binding data to the included templates.

Continue by creating the **./views/index.html** file, copy-paste the following markup:

```html
<h1>Index Body</h1>
```

In order to render `index` on the `main` layout, create the `./main.go` file by following the below.

Import the package:

```go
import "github.com/kataras/blocks"
```

The `blocks` package is fully compatible with the standard library. Use the [New(directory string)](https://pkg.go.dev/github.com/kataras/blocks?tab=doc#New) function to return a fresh Blcoks view engine that renders templates. 

This directory can be used to locate system template files or to select the wanted template files across a range of embedded data (or empty if templates are not prefixed with a root directory).

```go
views := blocks.New("./views")
```

The default layouts directory is `$dir/layouts`, you can change it by `blocks.New(...).LayoutDir("otherLayouts")`.

To parse files that are translated as Go code, inside the executable program itself, pass the [go-bindata's generated](https://github.com/go-bindata/go-bindata) latest version's `AssetFile` method to the `New` function:

```sh
$ go get -u github.com/go-bindata/go-bindata
```

```go
views := blocks.New(AssetFile())
```

After the initialization and engine's customizations the user SHOULD call its [Load() error](https://pkg.go.dev/github.com/kataras/blocks?tab=doc#Blocks.Load) or [LoadWithContext(context.Context) error](https://pkg.go.dev/github.com/kataras/blocks?tab=doc#Blocks.LoadWithContext) method once in order to parse the files into templates.

```go
err := views.Load()
```

To render a template through a compatible [io.Writer](https://golang.org/pkg/io/#Writer) use the [ExecuteTemplate(w io.Writer, tmplName, layoutName string, data interface{})](https://pkg.go.dev/github.com/kataras/blocks?tab=doc#Blocks.ExecuteTemplate) method.

```go
func handler(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{
		"Title": "Index Title",
	}

	err := views.ExecuteTemplate(w, "index", "main", data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
```

There are several methods to customize the engine, **before `Load`**, including `Delims`, `Option`, `Funcs`, `Extension`, `RootDir`, `LayoutDir`, `LayoutFuncs`, `DefaultLayout` and `Extensions`. You can learn more about those in our [godocs](https://pkg.go.dev/github.com/kataras/blocks?tab=Blocks).

Please navigate through [_examples](_examples) directory for more.

## License

This software is licensed under the [MIT License](LICENSE).
