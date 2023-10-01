# JSON Web Tokens

**Iris has its own builtin JWT middleware now** which is faster and supports payload encryption, it is compatible with the new `iris.User` interface, it can write and read Go structs or map as token claims and many **more features than the community edition one**. Please navigate to [kataras/iris/_examples/auth/jwt](https://github.com/kataras/iris/tree/master/_examples/auth/jwt) instead.

-----

Provides basic JWT functionality for your APIs.
> Example can be found at: [_example/main.go](https://github.com/iris-contrib/middleware/tree/master/jwt/_example/main.go)

**1.** Install with `go get github.com/iris-contrib/middleware/jwt@master`

**2.** Import in your code `import "github.com/iris-contrib/middleware/jwt"`

**3.** Define a HS256 secret, e.g. `const mySecret = []byte("My Secret")`. In production you usually load it from a local file or from system environment variables

**4.** Initialize the middleware:

```go
j := jwt.New(jwt.Config{
    ValidationKeyGetter: func(token *jwt.Token) (interface{}, error) {
        return mySecret, nil
    },
    SigningMethod: jwt.SigningMethodHS256,
})
```

**5.** Generate a token:

```go
token := jwt.NewTokenWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
    "foo": "bar",
})

tokenString, _ := token.SignedString(mySecret)
```

**6.** Verify a token with the `j.Serve` before the main handler, e.g.:

```go
app.Get("/protected", j.Serve, protectedHandler)
```

Or per group of routes:

```go
usersAPI := app.Party("/users", j.Serve)
usersAPI.Get(protectedHandler)
```

**7.** Get the verified claims stored in Context's key of `"jwt"`:

```go
func protectedHandler(ctx iris.Context) {
    // Get the Token verified in the previous handler (of `j.Serve`).
    user := ctx.Values().Get("jwt").(*jwt.Token)

    // A map type of our stored Claims on this verified Token.
	foobar := user.Claims.(jwt.MapClaims) 
	for key, value := range foobar {
		ctx.Writef("%s = %s", key, value)
	}
}
```

By default the token is extracted by the `Authorization: Bearer $TOKEN` header. To change this behavior, you can set custom `TokenExtractor` in the JWT middleware's configuration. A `TokenExtractor` looks like that:

```go
type TokenExtractor func(iris.Context) (string, error)
```

The middleware package contains some builtin extractors like the `FromParameter` one. For example, if you want to accept a token only by a `"token"` URL Query Parameter do that:

```go
j := jwt.New(jwt.Config{
    // [...other fields]
    Extractor: jwt.FromParameter("token"),
})
```

You can also use more token extractors by wrapping them with the `FromFirst` extractor, e.g. try to receive the token from the "Authorization" Header and the "token" URL Query Parameter:

```go
j := jwt.New(jwt.Config{
    // [...other fields]
    Extractor: jwt.FromFirst(FromAuthHeader, jwt.FromParameter("token")),
})
```