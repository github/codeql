# raymond [![Build Status](https://secure.travis-ci.org/aymerick/raymond.svg?branch=master)](http://travis-ci.org/aymerick/raymond) [![GoDoc](https://godoc.org/github.com/aymerick/raymond?status.svg)](http://godoc.org/github.com/aymerick/raymond)

Handlebars for [golang](https://golang.org) with the same features as [handlebars.js](http://handlebarsjs.com) `3.0`.

The full API documentation is available here: <http://godoc.org/github.com/aymerick/raymond>.

![Raymond Logo](https://github.com/aymerick/raymond/blob/master/raymond.png?raw=true "Raymond")


# Table of Contents

- [Quick Start](#quick-start)
- [Correct Usage](#correct-usage)
- [Context](#context)
- [HTML Escaping](#html-escaping)
- [Helpers](#helpers)
  - [Template Helpers](#template-helpers)
  - [Built-In Helpers](#built-in-helpers)
    - [The `if` block helper](#the-if-block-helper)
    - [The `unless` block helper](#the-unless-block-helper)
    - [The `each` block helper](#the-each-block-helper)
    - [The `with` block helper](#the-with-block-helper)
    - [The `lookup` helper](#the-lookup-helper)
    - [The `log` helper](#the-log-helper)
    - [The `equal` helper](#the-equal-helper)
  - [Block Helpers](#block-helpers)
    - [Block Evaluation](#block-evaluation)
    - [Conditional](#conditional)
    - [Else Block Evaluation](#else-block-evaluation)
    - [Block Parameters](#block-parameters)
  - [Helper Parameters](#helper-parameters)
    - [Automatic conversion](#automatic-conversion)
  - [Options Argument](#options-argument)
    - [Context Values](#context-values)
    - [Helper Hash Arguments](#helper-hash-arguments)
    - [Private Data](#private-data)
  - [Utilites](#utilites)
    - [`Str()`](#str)
    - [`IsTrue()`](#istrue)
- [Context Functions](#context-functions)
- [Partials](#partials)
  - [Template Partials](#template-partials)
  - [Global Partials](#global-partials)
  - [Dynamic Partials](#dynamic-partials)
  - [Partial Contexts](#partial-contexts)
  - [Partial Parameters](#partial-parameters)
- [Utility Functions](#utility-functions)
- [Mustache](#mustache)
- [Limitations](#limitations)
- [Handlebars Lexer](#handlebars-lexer)
- [Handlebars Parser](#handlebars-parser)
- [Test](#test)
- [References](#references)
- [Others Implementations](#others-implementations)


## Quick Start

    $ go get github.com/aymerick/raymond

The quick and dirty way of rendering a handlebars template:

```go
package main

import (
    "fmt"

    "github.com/mailgun/raymond/v2"
)

func main() {
    tpl := `<div class="entry">
  <h1>{{title}}</h1>
  <div class="body">
    {{body}}
  </div>
</div>
`

    ctx := map[string]string{
        "title": "My New Post",
        "body":  "This is my first post!",
    }

    result, err := raymond.Render(tpl, ctx)
    if err != nil {
        panic("Please report a bug :)")
    }

    fmt.Print(result)
}
```

Displays:

```html
<div class="entry">
  <h1>My New Post</h1>
  <div class="body">
    This is my first post!
  </div>
</div>
```

Please note that the template will be parsed everytime you call `Render()` function. So you probably want to read the next section.


## Correct Usage

To avoid parsing a template several times, use the `Parse()` and `Exec()` functions:

```go
package main

import (
    "fmt"

    "github.com/mailgun/raymond/v2"
)

func main() {
    source := `<div class="entry">
  <h1>{{title}}</h1>
  <div class="body">
    {{body}}
  </div>
</div>
`

    ctxList := []map[string]string{
        {
            "title": "My New Post",
            "body":  "This is my first post!",
        },
        {
            "title": "Here is another post",
            "body":  "This is my second post!",
        },
    }

    // parse template
    tpl, err := raymond.Parse(source)
    if err != nil {
        panic(err)
    }

    for _, ctx := range ctxList {
        // render template
        result, err := tpl.Exec(ctx)
        if err != nil {
            panic(err)
        }

        fmt.Print(result)
    }
}

```

Displays:

```html
<div class="entry">
  <h1>My New Post</h1>
  <div class="body">
    This is my first post!
  </div>
</div>
<div class="entry">
  <h1>Here is another post</h1>
  <div class="body">
    This is my second post!
  </div>
</div>
```

You can use `MustParse()` and `MustExec()` functions if you don't want to deal with errors:

```go
// parse template
tpl := raymond.MustParse(source)

// render template
result := tpl.MustExec(ctx)
```


## Context

The rendering context can contain any type of values, including `array`, `slice`, `map`, `struct` and `func`.

When using structs, be warned that only exported fields are accessible. However you can access exported fields in template with their lowercase names. For example, both `{{author.firstName}}` and `{{Author.FirstName}}` references give the same result, as long as `Author` and `FirstName` are exported struct fields.

More, you can use the `handlebars` struct tag to specify a template variable name different from the struct field name.

```go
package main

import (
  "fmt"

  "github.com/mailgun/raymond/v2"
)

func main() {
    source := `<div class="post">
  <h1>By {{author.firstName}} {{author.lastName}}</h1>
  <div class="body">{{body}}</div>

  <h1>Comments</h1>

  {{#each comments}}
  <h2>By {{author.firstName}} {{author.lastName}}</h2>
  <div class="body">{{content}}</div>
  {{/each}}
</div>`

    type Person struct {
        FirstName string
        LastName  string
    }

    type Comment struct {
        Author Person
        Body   string `handlebars:"content"`
    }

    type Post struct {
        Author   Person
        Body     string
        Comments []Comment
    }

    ctx := Post{
        Person{"Jean", "Valjean"},
        "Life is difficult",
        []Comment{
            Comment{
                Person{"Marcel", "Beliveau"},
                "LOL!",
            },
        },
    }

    output := raymond.MustRender(source, ctx)

    fmt.Print(output)
}
```

Output:

```html
<div class="post">
  <h1>By Jean Valjean</h1>
  <div class="body">Life is difficult</div>

  <h1>Comments</h1>

  <h2>By Marcel Beliveau</h2>
  <div class="body">LOL!</div>
</div>
```

## HTML Escaping

By default, the result of a mustache expression is HTML escaped. Use the triple mustache `{{{` to output unescaped values.

```go
source := `<div class="entry">
  <h1>{{title}}</h1>
  <div class="body">
    {{{body}}}
  </div>
</div>
`

ctx := map[string]string{
    "title": "All about <p> Tags",
    "body":  "<p>This is a post about &lt;p&gt; tags</p>",
}

tpl := raymond.MustParse(source)
result := tpl.MustExec(ctx)

fmt.Print(result)
```

Output:

```html
<div class="entry">
  <h1>All about &lt;p&gt; Tags</h1>
  <div class="body">
    <p>This is a post about &lt;p&gt; tags</p>
  </div>
</div>
```

When returning HTML from a helper, you should return a `SafeString` if you don't want it to be escaped by default. When using `SafeString` all unknown or unsafe data should be manually escaped with the `Escape` method.

```go
raymond.RegisterHelper("link", func(url, text string) raymond.SafeString {
    return raymond.SafeString("<a href='" + raymond.Escape(url) + "'>" + raymond.Escape(text) + "</a>")
})

tpl := raymond.MustParse("{{link url text}}")

ctx := map[string]string{
    "url":  "http://www.aymerick.com/",
    "text": "This is a <em>cool</em> website",
}

result := tpl.MustExec(ctx)
fmt.Print(result)
```

Output:

```html
<a href='http://www.aymerick.com/'>This is a &lt;em&gt;cool&lt;/em&gt; website</a>
```


## Helpers

Helpers can be accessed from any context in a template. You can register a helper with the `RegisterHelper` function.

For example:

```html
<div class="post">
  <h1>By {{fullName author}}</h1>
  <div class="body">{{body}}</div>

  <h1>Comments</h1>

  {{#each comments}}
  <h2>By {{fullName author}}</h2>
  <div class="body">{{body}}</div>
  {{/each}}
</div>
```

With this context and helper:

```go
ctx := map[string]interface{}{
    "author": map[string]string{"firstName": "Jean", "lastName": "Valjean"},
    "body":   "Life is difficult",
    "comments": []map[string]interface{}{{
        "author": map[string]string{"firstName": "Marcel", "lastName": "Beliveau"},
        "body":   "LOL!",
    }},
}

raymond.RegisterHelper("fullName", func(person map[string]string) string {
    return person["firstName"] + " " + person["lastName"]
})
```

Outputs:

```html
<div class="post">
  <h1>By Jean Valjean</h1>
  <div class="body">Life is difficult</div>

  <h1>Comments</h1>

  <h2>By Marcel Beliveau</h2>
  <div class="body">LOL!</div>
</div>
```

Helper arguments can be any type.

The following example uses structs instead of maps and produces the same output as the previous one:

```html
<div class="post">
  <h1>By {{fullName author}}</h1>
  <div class="body">{{body}}</div>

  <h1>Comments</h1>

  {{#each comments}}
  <h2>By {{fullName author}}</h2>
  <div class="body">{{body}}</div>
  {{/each}}
</div>
```

With this context and helper:

```go
type Post struct {
    Author   Person
    Body     string
    Comments []Comment
}

type Person struct {
    FirstName string
    LastName  string
}

type Comment struct {
    Author Person
    Body   string
}

ctx := Post{
    Person{"Jean", "Valjean"},
    "Life is difficult",
    []Comment{
        Comment{
            Person{"Marcel", "Beliveau"},
            "LOL!",
        },
    },
}

raymond.RegisterHelper("fullName", func(person Person) string {
    return person.FirstName + " " + person.LastName
})
```

You can unregister global helpers with `RemoveHelper` and `RemoveAllHelpers` functions:

```go
raymond.RemoveHelper("fullname")
```

```go
raymond.RemoveAllHelpers()
```


### Template Helpers

You can register a helper on a specific template, and in that case that helper will be available to that template only:

```go
tpl := raymond.MustParse("User: {{fullName user.firstName user.lastName}}")

tpl.RegisterHelper("fullName", func(firstName, lastName string) string {
  return firstName + " " + lastName
})
```


### Built-In Helpers

Those built-in helpers are available to all templates.


#### The `if` block helper

You can use the `if` helper to conditionally render a block. If its argument returns `false`, `nil`, `0`, `""`, an empty array, an empty slice or an empty map, then raymond will not render the block.

```html
<div class="entry">
  {{#if author}}
    <h1>{{firstName}} {{lastName}}</h1>
  {{/if}}
</div>
```

When using a block expression, you can specify a template section to run if the expression returns a falsy value. That section, marked by `{{else}}` is called an "else section".

```html
<div class="entry">
  {{#if author}}
    <h1>{{firstName}} {{lastName}}</h1>
  {{else}}
    <h1>Unknown Author</h1>
  {{/if}}
</div>
```

You can chain several blocks. For example that template:

```html
{{#if isActive}}
  <img src="star.gif" alt="Active">
{{else if isInactive}}
  <img src="cry.gif" alt="Inactive">
{{else}}
  <img src="wat.gif" alt="Unknown">
{{/if}}
```

With that context:

```go
ctx := map[string]interface{}{
    "isActive":   false,
    "isInactive": false,
}
```

Outputs:

```html
 <img src="wat.gif" alt="Unknown">
```


#### The `unless` block helper

You can use the `unless` helper as the inverse of the `if` helper. Its block will be rendered if the expression returns a falsy value.

```html
<div class="entry">
  {{#unless license}}
  <h3 class="warning">WARNING: This entry does not have a license!</h3>
  {{/unless}}
</div>
```


#### The `each` block helper

You can iterate over an array, a slice, a map or a struct instance using this built-in `each` helper. Inside the block, you can use `this` to reference the element being iterated over.

For example:

```html
<ul class="people">
  {{#each people}}
    <li>{{this}}</li>
  {{/each}}
</ul>
```

With this context:

```go
map[string]interface{}{
    "people": []string{
        "Marcel", "Jean-Claude", "Yvette",
    },
}
```

Outputs:

```html
<ul class="people">
  <li>Marcel</li>
  <li>Jean-Claude</li>
  <li>Yvette</li>
</ul>
```

You can optionally provide an `{{else}}` section which will display only when the passed argument is an empty array, an empty slice or an empty map (a `struct` instance is never considered empty).

```html
{{#each paragraphs}}
  <p>{{this}}</p>
{{else}}
  <p class="empty">No content</p>
{{/each}}
```

When looping through items in `each`, you can optionally reference the current loop index via `{{@index}}`.

```html
{{#each array}}
  {{@index}}: {{this}}
{{/each}}
```

Additionally for map and struct instance iteration, `{{@key}}` references the current map key or struct field name:

```html
{{#each map}}
  {{@key}}: {{this}}
{{/each}}
```

The first and last steps of iteration are noted via the `@first` and `@last` variables.


#### The `with` block helper

You can shift the context for a section of a template by using the built-in `with` block helper.

```html
<div class="entry">
  <h1>{{title}}</h1>

  {{#with author}}
  <h2>By {{firstName}} {{lastName}}</h2>
  {{/with}}
</div>
```

With this context:

```go
map[string]interface{}{
    "title": "My first post!",
    "author": map[string]string{
        "firstName": "Jean",
        "lastName":  "Valjean",
    },
}
```

Outputs:

```html
<div class="entry">
  <h1>My first post!</h1>

  <h2>By Jean Valjean</h2>
</div>
```

You can optionally provide an `{{else}}` section which will display only when the passed argument is falsy.

```html
{{#with author}}
  <p>{{name}}</p>
{{else}}
  <p class="empty">No content</p>
{{/with}}
```


#### The `lookup` helper

The `lookup` helper allows for dynamic parameter resolution using handlebars variables.

```html
{{#each bar}}
  {{lookup ../foo @index}}
{{/each}}
```


#### The `log` helper

The `log` helper allows for logging while rendering a template.

```html
{{log "Look at me!"}}
```

Note that the handlebars.js `@level` variable is not supported.


#### The `equal` helper

The `equal` helper renders a block if the string version of both arguments are equals.

For example that template:

```html
{{#equal foo "bar"}}foo is bar{{/equal}}
{{#equal foo baz}}foo is the same as baz{{/equal}}
{{#equal nb 0}}nothing{{/equal}}
{{#equal nb 1}}there is one{{/equal}}
{{#equal nb "1"}}everything is stringified before comparison{{/equal}}
```

With that context:

```go
ctx := map[string]interface{}{
    "foo": "bar",
    "baz": "bar",
    "nb":  1,
}
```

Outputs:

```html
foo is bar
foo is the same as baz

there is one
everything is stringified before comparison
```


### Block Helpers

Block helpers make it possible to define custom iterators and other functionality that can invoke the passed block with a new context.


#### Block Evaluation

As an example, let's define a block helper that adds some markup to the wrapped text.

```html
<div class="entry">
  <h1>{{title}}</h1>
  <div class="body">
    {{#bold}}{{body}}{{/bold}}
  </div>
</div>
```

The `bold` helper will add markup to make its text bold.

```go
raymond.RegisterHelper("bold", func(options *raymond.Options) raymond.SafeString {
    return raymond.SafeString(`<div class="mybold">` + options.Fn() + "</div>")
})
```

A helper evaluates the block content with current context by calling `options.Fn()`.

If you want to evaluate the block with another context, then use `options.FnWith(ctx)`, like this french version of built-in `with` block helper:

```go
raymond.RegisterHelper("avec", func(context interface{}, options *raymond.Options) string {
    return options.FnWith(context)
})
```

With that template:

```html
{{#avec obj.text}}{{this}}{{/avec}}
```


#### Conditional

Let's write a french version of `if` block helper:

```go
source := `{{#si yep}}YEP !{{/si}}`

ctx := map[string]interface{}{"yep": true}

raymond.RegisterHelper("si", func(conditional bool, options *raymond.Options) string {
    if conditional {
        return options.Fn()
    }
    return ""
})
```

Note that as the first parameter of the helper is typed as `bool` an automatic conversion is made if corresponding context value is not a boolean. So this helper works with that context too:

```go
ctx := map[string]interface{}{"yep": "message"}
```

Here, `"message"` is converted to `true` because it is an non-empty string. See `IsTrue()` function for more informations on boolean conversion.


#### Else Block Evaluation

We can enhance the `si` block helper to evaluate the `else block` by calling `options.Inverse()` if conditional is false:

```go
source := `{{#si yep}}YEP !{{else}}NOP !{{/si}}`

ctx := map[string]interface{}{"yep": false}

raymond.RegisterHelper("si", func(conditional bool, options *raymond.Options) string {
    if conditional {
        return options.Fn()
    }
    return options.Inverse()
})
```

Outputs:
```
NOP !
```


#### Block Parameters

It's possible to receive named parameters from supporting helpers.

```html
{{#each users as |user userId|}}
  Id: {{userId}} Name: {{user.name}}
{{/each}}
```

In this particular example, `user` will have the same value as the current context and `userId` will have the index/key value for the iteration.

This allows for nested helpers to avoid name conflicts.

For example:

```html
{{#each users as |user userId|}}
  {{#each user.books as |book bookId|}}
    User: {{userId}} Book: {{bookId}}
  {{/each}}
{{/each}}
```

With this context:

```go
ctx := map[string]interface{}{
    "users": map[string]interface{}{
        "marcel": map[string]interface{}{
            "books": map[string]interface{}{
                "book1": "My first book",
                "book2": "My second book",
            },
        },
        "didier": map[string]interface{}{
            "books": map[string]interface{}{
                "bookA": "Good book",
                "bookB": "Bad book",
            },
        },
    },
}
```

Outputs:

```html
  User: marcel Book: book1
  User: marcel Book: book2
  User: didier Book: bookA
  User: didier Book: bookB
```

As you can see, the second block parameter is the map key. When using structs, it is the struct field name.

When using arrays and slices, the second parameter is element index:

```go
ctx := map[string]interface{}{
    "users": []map[string]interface{}{
        {
            "id": "marcel",
            "books": []map[string]interface{}{
                {"id": "book1", "title": "My first book"},
                {"id": "book2", "title": "My second book"},
            },
        },
        {
            "id": "didier",
            "books": []map[string]interface{}{
                {"id": "bookA", "title": "Good book"},
                {"id": "bookB", "title": "Bad book"},
            },
        },
    },
}
```

Outputs:

```html
    User: 0 Book: 0
    User: 0 Book: 1
    User: 1 Book: 0
    User: 1 Book: 1
```


### Helper Parameters

When calling a helper in a template, raymond expects the same number of arguments as the number of helper function parameters.

So this template:

```html
{{add a}}
```

With this helper:

```go
raymond.RegisterHelper("add", func(val1, val2 int) string {
    return strconv.Itoa(val1 + val2)
})
```

Will simply panics, because we call the helper with one argument whereas it expects two.


#### Automatic conversion

Let's create a `concat` helper that expects two strings and concat them:

```go
source := `{{concat a b}}`

ctx := map[string]interface{}{
    "a": "Jean",
    "b": "Valjean",
}

raymond.RegisterHelper("concat", func(val1, val2 string) string {
    return val1 + " " + val2
})
```

Everything goes well, two strings are passed as arguments to the helper that outputs:

```html
Jean VALJEAN
```

But what happens if there is another type than `string` in the context ? For example:

```go
ctx := map[string]interface{}{
    "a": 10,
    "b": "Valjean",
}
```

Actually, raymond perfoms automatic string conversion. So because the first parameter of the helper is typed as `string`, the first argument will be converted from the `10` integer to `"10"`, and the helper outputs:

```html
10 VALJEAN
```

Note that this kind of automatic conversion is done with `bool` type too, thanks to the `IsTrue()` function.


### Options Argument

If a helper needs the `Options` argument, just add it at the end of helper parameters:

```go
raymond.RegisterHelper("add", func(val1, val2 int, options *raymond.Options) string {
    return strconv.Itoa(val1 + val2) + " " + options.ValueStr("bananas")
})
```

Thanks to the `options` argument, helpers have access to the current evaluation context, to the `Hash` arguments, and they can manipulate the private data variables.

The `Options` argument is even necessary for Block Helpers to evaluate block and "else block".


#### Context Values

Helpers fetch current context values with `options.Value()` and `options.ValuesStr()`.

`Value()` returns an `interface{}` and lets the helper do the type assertions whereas `ValueStr()` automatically converts the value to a `string`.

For example:

```go
source := `{{concat a b}}`

ctx := map[string]interface{}{
    "a":      "Marcel",
    "b":      "Beliveau",
    "suffix": "FOREVER !",
}

raymond.RegisterHelper("concat", func(val1, val2 string, options *raymond.Options) string {
    return val1 + " " + val2 + " " + options.ValueStr("suffix")
})
```

Outputs:

```html
Marcel Beliveau FOREVER !
```

Helpers can get the entire current context with `options.Ctx()` that returns an `interface{}`.


#### Helper Hash Arguments

Helpers access hash arguments with `options.HashProp()` and `options.HashStr()`.

`HashProp()` returns an `interface{}` and lets the helper do the type assertions whereas `HashStr()` automatically converts the value to a `string`.

For example:

```go
source := `{{concat suffix first=a second=b}}`

ctx := map[string]interface{}{
    "a":      "Marcel",
    "b":      "Beliveau",
    "suffix": "FOREVER !",
}

raymond.RegisterHelper("concat", func(suffix string, options *raymond.Options) string {
    return options.HashStr("first") + " " + options.HashStr("second") + " " + suffix
})
```

Outputs:

```html
Marcel Beliveau FOREVER !
```

Helpers can get the full hash with `options.Hash()` that returns a `map[string]interface{}`.


#### Private Data

Helpers access private data variables with `options.Data()` and `options.DataStr()`.

`Data()` returns an `interface{}` and lets the helper do the type assertions whereas `DataStr()` automatically converts the value to a `string`.

Helpers can get the entire current data frame with `options.DataFrame()` that returns a `*DataFrame`.

For helpers that need to inject their own private data frame, use `options.NewDataFrame()` to create the frame and `options.FnData()` to evaluate the block with that frame.

For example:

```go
source := `{{#voodoo kind=a}}Voodoo is {{@magix}}{{/voodoo}}`

ctx := map[string]interface{}{
    "a": "awesome",
}

raymond.RegisterHelper("voodoo", func(options *raymond.Options) string {
    // create data frame with @magix data
    frame := options.NewDataFrame()
    frame.Set("magix", options.HashProp("kind"))

    // evaluates block with new data frame
    return options.FnData(frame)
})
```

Helpers that need to evaluate the block with a private data frame and a new context can call `options.FnCtxData()`.


### Utilites

In addition to `Escape()`, raymond provides utility functions that can be usefull for helpers.


#### `Str()`

`Str()` converts its parameter to a `string`.

Booleans:

```go
raymond.Str(3) + " foos and " + raymond.Str(-1.25) + " bars"
// Outputs: "3 foos and -1.25 bars"
```

Numbers:

``` go
"everything is " + raymond.Str(true) + " and nothing is " + raymond.Str(false)
// Outputs: "everything is true and nothing is false"
```

Maps:

```go
raymond.Str(map[string]string{"foo": "bar"})
// Outputs: "map[foo:bar]"
```

Arrays and Slices:

```go
raymond.Str([]interface{}{true, 10, "foo", 5, "bar"})
// Outputs: "true10foo5bar"
```


#### `IsTrue()`

`IsTrue()` returns the truthy version of its parameter.

It returns `false` when parameter is either:

  - an empty array
  - an empty slice
  - an empty map
  - `""`
  - `nil`
  - `0`
  - `false`

For all others values, `IsTrue()` returns `true`.


## Context Functions

In addition to helpers, lambdas found in context are evaluated.

For example, that template and context:

```go
source := "I {{feeling}} you"

ctx := map[string]interface{}{
    "feeling": func() string {
        rand.Seed(time.Now().UTC().UnixNano())

        feelings := []string{"hate", "love"}
        return feelings[rand.Intn(len(feelings))]
    },
}
```

Randomly renders `I hate you` or `I love you`.

Those context functions behave like helper functions: they can be called with parameters and they can have an `Options` argument.


## Partials

### Template Partials

You can register template partials before execution:

```go
tpl := raymond.MustParse("{{> foo}} baz")
tpl.RegisterPartial("foo", "<span>bar</span>")

result := tpl.MustExec(nil)
fmt.Print(result)
```

Output:

```html
<span>bar</span> baz
```

You can register several partials at once:

```go
tpl := raymond.MustParse("{{> foo}} and {{> baz}}")
tpl.RegisterPartials(map[string]string{
    "foo": "<span>bar</span>",
    "baz": "<span>bat</span>",
})

result := tpl.MustExec(nil)
fmt.Print(result)
```

Output:

```html
<span>bar</span> and <span>bat</span>
```


### Global Partials

You can registers global partials that will be accessible by all templates:

```go
raymond.RegisterPartial("foo", "<span>bar</span>")

tpl := raymond.MustParse("{{> foo}} baz")
result := tpl.MustExec(nil)
fmt.Print(result)
```

Or:

```go
raymond.RegisterPartials(map[string]string{
    "foo": "<span>bar</span>",
    "baz": "<span>bat</span>",
})

tpl := raymond.MustParse("{{> foo}} and {{> baz}}")
result := tpl.MustExec(nil)
fmt.Print(result)
```


### Dynamic Partials

It's possible to dynamically select the partial to be executed by using sub expression syntax.

For example, that template randomly evaluates the `foo` or `baz` partial:

```go
tpl := raymond.MustParse("{{> (whichPartial) }}")
tpl.RegisterPartials(map[string]string{
    "foo": "<span>bar</span>",
    "baz": "<span>bat</span>",
})

ctx := map[string]interface{}{
    "whichPartial": func() string {
        rand.Seed(time.Now().UTC().UnixNano())

        names := []string{"foo", "baz"}
        return names[rand.Intn(len(names))]
    },
}

result := tpl.MustExec(ctx)
fmt.Print(result)
```


### Partial Contexts

It's possible to execute partials on a custom context by passing in the context to the partial call.

For example:

```go
tpl := raymond.MustParse("User: {{> userDetails user }}")
tpl.RegisterPartial("userDetails", "{{firstname}} {{lastname}}")

ctx := map[string]interface{}{
    "user": map[string]string{
        "firstname": "Jean",
        "lastname":  "Valjean",
    },
}

result := tpl.MustExec(ctx)
fmt.Print(result)
```

Displays:

```html
User: Jean Valjean
```


### Partial Parameters

Custom data can be passed to partials through hash parameters.

For example:

```go
tpl := raymond.MustParse("{{> myPartial name=hero }}")
tpl.RegisterPartial("myPartial", "My hero is {{name}}")

ctx := map[string]interface{}{
    "hero": "Goldorak",
}

result := tpl.MustExec(ctx)
fmt.Print(result)
```

Displays:

```html
My hero is Goldorak
```


## Utility Functions

You can use following utility fuctions to parse and register partials from files:

- `ParseFile()` - reads a file and return parsed template
- `Template.RegisterPartialFile()` - reads a file and registers its content as a partial with given name
- `Template.RegisterPartialFiles()` - reads several files and registers them as partials, the filename base is used as the partial name


## Mustache

Handlebars is a superset of [mustache](https://mustache.github.io) but it differs on those points:

- Alternative delimiters are not supported
- There is no recursive lookup


## Limitations

These handlebars options are currently NOT implemented:

- `compat` - enables recursive field lookup
- `knownHelpers` - list of helpers that are known to exist (truthy) at template execution time
- `knownHelpersOnly` - allows further optimizations based on the known helpers list
- `trackIds` - include the id names used to resolve parameters for helpers
- `noEscape` - disables HTML escaping globally
- `strict` - templates will throw rather than silently ignore missing fields
- `assumeObjects` - removes object existence checks when traversing paths
- `preventIndent` - disables the auto-indententation of nested partials
- `stringParams` - resolves a parameter to it's name if the value isn't present in the context stack

These handlebars features are currently NOT implemented:

- raw block content is not passed as a parameter to helper
- `blockHelperMissing` - helper called when a helper can not be directly resolved
- `helperMissing` - helper called when a potential helper expression was not found
- `@contextPath` - value set in `trackIds` mode that records the lookup path for the current context
- `@level` - log level


## Handlebars Lexer

You should not use the lexer directly, but for your information here is an example:

```go
package main

import (
    "fmt"

    "github.com/mailgun/raymond/v2/lexer"
)

func main() {
    source := "You know {{nothing}} John Snow"

    output := ""

    lex := lexer.Scan(source)
    for {
        // consume next token
        token := lex.NextToken()

        output += fmt.Sprintf(" %s", token)

        // stops when all tokens have been consumed, or on error
        if token.Kind == lexer.TokenEOF || token.Kind == lexer.TokenError {
            break
        }
    }

    fmt.Print(output)
}
```

Outputs:

```
Content{"You know "} Open{"{{"} ID{"nothing"} Close{"}}"} Content{" John Snow"} EOF
```


## Handlebars Parser

You should not use the parser directly, but for your information here is an example:

```go
package main

import (
    "fmt"

    "github.com/mailgun/raymond/v2/ast"
    "github.com/mailgun/raymond/v2/parser"
)

fu  nc main() {
    source := "You know {{nothing}} John Snow"

    // parse template
    program, err := parser.Parse(source)
    if err != nil {
        panic(err)
    }

    // print AST
    output := ast.Print(program)

    fmt.Print(output)
}
```

Outputs:

```
CONTENT[ 'You know ' ]
{{ PATH:nothing [] }}
CONTENT[ ' John Snow' ]
```


## Test

First, fetch mustache tests:

    $ git submodule update --init

To run all tests:

    $ go test ./...

To filter tests:

    $ go test -run="Partials"

To run all test and all benchmarks:

    $ go test -bench . ./...

To test with race detection:

    $ go test -race ./...


## References

  - <http://handlebarsjs.com/>
  - <https://mustache.github.io/mustache.5.html>
  - <https://github.com/golang/go/tree/master/src/text/template>
  - <https://www.youtube.com/watch?v=HxaD_trXwRE>


## Others Implementations

- [handlebars.js](http://handlebarsjs.com) - javascript
- [handlebars.java](https://github.com/jknack/handlebars.java) - java
- [handlebars.rb](https://github.com/cowboyd/handlebars.rb) - ruby
- [handlebars.php](https://github.com/XaminProject/handlebars.php) - php
- [handlebars-objc](https://github.com/Bertrand/handlebars-objc) - Objective C
- [rumblebars](https://github.com/nicolas-cherel/rumblebars) - rust
