# [pongo](https://en.wikipedia.org/wiki/Pongo_%28genus%29)2

[![PkgGoDev](https://pkg.go.dev/badge/github.com/flosch/pongo2)](https://pkg.go.dev/github.com/flosch/pongo2)
[![Build Status](https://travis-ci.org/flosch/pongo2.svg?branch=master)](https://travis-ci.org/flosch/pongo2)

pongo2 is a Django-syntax like templating-language ([official website](https://www.schlachter.tech/solutions/pongo2-template-engine/)).

Install/update using `go get` (no dependencies required by pongo2):

```sh
go get -u github.com/flosch/pongo2/v4
```

Please use the [issue tracker](https://github.com/flosch/pongo2/issues) if you're encountering any problems with pongo2 or if you need help with implementing tags or filters ([create a ticket!](https://github.com/flosch/pongo2/issues/new)).

## First impression of a template

```django
<html>
  <head>
    <title>Our admins and users</title>
  </head>
  {# This is a short example to give you a quick overview of pongo2's syntax. #}
  {% macro user_details(user, is_admin=false) %}
  <div class="user_item">
    <!-- Let's indicate a user's good karma -->
    <h2 {% if (user.karma>
      = 40) || (user.karma > calc_avg_karma(userlist)+5) %} class="karma-good"{%
      endif %}>

      <!-- This will call user.String() automatically if available: -->
      {{ user }}
    </h2>

    <!-- Will print a human-readable time duration like "3 weeks ago" -->
    <p>This user registered {{ user.register_date|naturaltime }}.</p>

    <!-- Let's allow the users to write down their biography using markdown;
             we will only show the first 15 words as a preview -->
    <p>The user's biography:</p>
    <p>
      {{ user.biography|markdown|truncatewords_html:15 }}
      <a href="/user/{{ user.id }}/">read more</a>
    </p>

    {% if is_admin %}
    <p>This user is an admin!</p>
    {% endif %}
  </div>
  {% endmacro %}

  <body>
    <!-- Make use of the macro defined above to avoid repetitive HTML code
         since we want to use the same code for admins AND members -->

    <h1>Our admins</h1>
    {% for admin in adminlist %} {{ user_details(admin, true) }} {% endfor %}

    <h1>Our members</h1>
    {% for user in userlist %} {{ user_details(user) }} {% endfor %}
  </body>
</html>
```

## Features

- Syntax- and feature-set-compatible with [Django 1.7](https://django.readthedocs.io/en/1.7.x/topics/templates.html)
- [Advanced C-like expressions](https://github.com/flosch/pongo2/blob/master/template_tests/expressions.tpl).
- [Complex function calls within expressions](https://github.com/flosch/pongo2/blob/master/template_tests/function_calls_wrapper.tpl).
- [Easy API to create new filters and tags](http://godoc.org/github.com/flosch/pongo2#RegisterFilter) ([including parsing arguments](http://godoc.org/github.com/flosch/pongo2#Parser))
- Additional features:
  - Macros including importing macros from other files (see [template_tests/macro.tpl](https://github.com/flosch/pongo2/blob/master/template_tests/macro.tpl))
  - [Template sandboxing](https://godoc.org/github.com/flosch/pongo2#TemplateSet) ([directory patterns](http://golang.org/pkg/path/filepath/#Match), banned tags/filters)

## Caveats

### Filters

- **date** / **time**: The `date` and `time` filter are taking the Golang specific time- and date-format (not Django's one) currently. [Take a look on the format here](http://golang.org/pkg/time/#Time.Format).
- **stringformat**: `stringformat` does **not** take Python's string format syntax as a parameter, instead it takes Go's. Essentially `{{ 3.14|stringformat:"pi is %.2f" }}` is `fmt.Sprintf("pi is %.2f", 3.14)`.
- **escape** / **force_escape**: Unlike Django's behaviour, the `escape`-filter is applied immediately. Therefore there is no need for a `force_escape`-filter yet.

### Tags

- **for**: All the `forloop` fields (like `forloop.counter`) are written with a capital letter at the beginning. For example, the `counter` can be accessed by `forloop.Counter` and the parentloop by `forloop.Parentloop`.
- **now**: takes Go's time format (see **date** and **time**-filter).

### Misc

- **not in-operator**: You can check whether a map/struct/string contains a key/field/substring by using the in-operator (or the negation of it):
  `{% if key in map %}Key is in map{% else %}Key not in map{% endif %}` or `{% if !(key in map) %}Key is NOT in map{% else %}Key is in map{% endif %}`.

## Add-ons, libraries and helpers

### Official

- [pongo2-addons](https://github.com/flosch/pongo2-addons) - Official additional filters/tags for pongo2 (for example a **markdown**-filter). They are in their own repository because they're relying on 3rd-party-libraries.

### 3rd-party

- [beego-pongo2](https://github.com/oal/beego-pongo2) - A tiny little helper for using Pongo2 with [Beego](https://github.com/astaxie/beego).
- [beego-pongo2.v2](https://github.com/ipfans/beego-pongo2.v2) - Same as `beego-pongo2`, but for pongo2 v2.
- [macaron-pongo2](https://github.com/macaron-contrib/pongo2) - pongo2 support for [Macaron](https://github.com/Unknwon/macaron), a modular web framework.
- [ginpongo2](https://github.com/ngerakines/ginpongo2) - middleware for [gin](github.com/gin-gonic/gin) to use pongo2 templates
- [Build'n support for Iris' template engine](https://github.com/kataras/iris)
- [pongo2gin](https://gitlab.com/go-box/pongo2gin) - alternative renderer for [gin](github.com/gin-gonic/gin) to use pongo2 templates
- [pongo2-trans](https://github.com/digitalcrab/pongo2trans) - `trans`-tag implementation for internationalization
- [tpongo2](https://github.com/tango-contrib/tpongo2) - pongo2 support for [Tango](https://github.com/lunny/tango), a micro-kernel & pluggable web framework.
- [p2cli](https://github.com/wrouesnel/p2cli) - command line templating utility based on pongo2
- [Pongo2echo](https://github.com/stnc/pongo2echo) - pongo2 echo framework stability renderer [stnc]
- [Pongo2gin](https://github.com/stnc/pongo2gin) - pongo2 gin minimal framework stability renderer [stnc]


Please add your project to this list and send me a pull request when you've developed something nice for pongo2.

## Who's using pongo2

[I'm compiling a list of pongo2 users](https://github.com/flosch/pongo2/issues/241). Add your project or company!

## API-usage examples

Please see the documentation for a full list of provided API methods.

### A tiny example (template string)

```go
// Compile the template first (i. e. creating the AST)
tpl, err := pongo2.FromString("Hello {{ name|capfirst }}!")
if err != nil {
    panic(err)
}
// Now you can render the template with the given
// pongo2.Context how often you want to.
out, err := tpl.Execute(pongo2.Context{"name": "florian"})
if err != nil {
    panic(err)
}
fmt.Println(out) // Output: Hello Florian!
```

## Example server-usage (template file)

```go
package main

import (
    "github.com/flosch/pongo2/v4"
    "net/http"
)

// Pre-compiling the templates at application startup using the
// little Must()-helper function (Must() will panic if FromFile()
// or FromString() will return with an error - that's it).
// It's faster to pre-compile it anywhere at startup and only
// execute the template later.
var tplExample = pongo2.Must(pongo2.FromFile("example.html"))

func examplePage(w http.ResponseWriter, r *http.Request) {
    // Execute the template per HTTP request
    err := tplExample.ExecuteWriter(pongo2.Context{"query": r.FormValue("query")}, w)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
    }
}

func main() {
    http.HandleFunc("/", examplePage)
    http.ListenAndServe(":8080", nil)
}
```
