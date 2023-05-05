package jwt

import (
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/kataras/iris/v12"
	"github.com/kataras/iris/v12/context"

	"github.com/golang-jwt/jwt/v4"
)

func init() {
	context.SetHandlerName("github.com/iris-contrib/middleware/jwt.*", "iris-contrib.jwt")
}

type (
	// Token for JWT. Different fields will be used depending on whether you're
	// creating or parsing/verifying a token.
	//
	// A type alias for jwt.Token.
	Token = jwt.Token
	// MapClaims type that uses the map[string]interface{} for JSON decoding
	// This is the default claims type if you don't supply one
	//
	// A type alias for jwt.MapClaims.
	MapClaims = jwt.MapClaims
	// Claims must just have a Valid method that determines
	// if the token is invalid for any supported reason.
	//
	// A type alias for jwt.Claims.
	Claims = jwt.Claims
)

// Shortcuts to create a new Token.
var (
	NewToken           = jwt.New
	NewTokenWithClaims = jwt.NewWithClaims
)

// HS256 and company.
var (
	SigningMethodHS256 = jwt.SigningMethodHS256
	SigningMethodHS384 = jwt.SigningMethodHS384
	SigningMethodHS512 = jwt.SigningMethodHS512
)

// ECDSA - EC256 and company.
var (
	SigningMethodES256 = jwt.SigningMethodES256
	SigningMethodES384 = jwt.SigningMethodES384
	SigningMethodES512 = jwt.SigningMethodES512
)

// A function called whenever an error is encountered
type errorHandler func(iris.Context, error)

// TokenExtractor is a function that takes a context as input and returns
// either a token or an error.  An error should only be returned if an attempt
// to specify a token was found, but the information was somehow incorrectly
// formed.  In the case where a token is simply not present, this should not
// be treated as an error.  An empty string should be returned in that case.
type TokenExtractor func(iris.Context) (string, error)

// Middleware the middleware for JSON Web tokens authentication method
type Middleware struct {
	Config Config
}

// OnError is the default error handler.
// Use it to change the behavior for each error.
// See `Config.ErrorHandler`.
func OnError(ctx iris.Context, err error) {
	if err == nil {
		return
	}

	ctx.StopExecution()
	ctx.StatusCode(iris.StatusUnauthorized)
	ctx.WriteString(err.Error())
}

// New constructs a new Secure instance with supplied options.
func New(cfg ...Config) *Middleware {
	var c Config
	if len(cfg) == 0 {
		c = Config{}
	} else {
		c = cfg[0]
	}

	if c.ContextKey == "" {
		c.ContextKey = DefaultContextKey
	}

	if c.ErrorHandler == nil {
		c.ErrorHandler = OnError
	}

	if c.Extractor == nil {
		c.Extractor = FromAuthHeader
	}

	return &Middleware{Config: c}
}

func logf(ctx iris.Context, format string, args ...interface{}) {
	ctx.Application().Logger().Debugf(format, args...)
}

// Get returns the user (&token) information for this client/request
func (m *Middleware) Get(ctx iris.Context) *jwt.Token {
	v := ctx.Values().Get(m.Config.ContextKey)
	if v == nil {
		return nil
	}
	return v.(*jwt.Token)
}

// Serve the middleware's action
func (m *Middleware) Serve(ctx iris.Context) {
	if err := m.CheckJWT(ctx); err != nil {
		m.Config.ErrorHandler(ctx, err)
		return
	}
	// If everything ok then call next.
	ctx.Next()
}

// FromAuthHeader is a "TokenExtractor" that takes a give context and extracts
// the JWT token from the Authorization header.
func FromAuthHeader(ctx iris.Context) (string, error) {
	authHeader := ctx.GetHeader("Authorization")
	if authHeader == "" {
		return "", nil // No error, just no token
	}

	// TODO: Make this a bit more robust, parsing-wise
	authHeaderParts := strings.Split(authHeader, " ")
	if len(authHeaderParts) != 2 || strings.ToLower(authHeaderParts[0]) != "bearer" {
		return "", fmt.Errorf("authorization header format must be Bearer {token}")
	}

	return authHeaderParts[1], nil
}

// FromParameter returns a function that extracts the token from the specified
// query string parameter
func FromParameter(param string) TokenExtractor {
	return func(ctx iris.Context) (string, error) {
		return ctx.URLParam(param), nil
	}
}

// FromFirst returns a function that runs multiple token extractors and takes the
// first token it finds
func FromFirst(extractors ...TokenExtractor) TokenExtractor {
	return func(ctx iris.Context) (string, error) {
		for _, ex := range extractors {
			token, err := ex(ctx)
			if err != nil {
				return "", err
			}
			if token != "" {
				return token, nil
			}
		}
		return "", nil
	}
}

var (
	// ErrTokenMissing is the error value that it's returned when
	// a token is not found based on the token extractor.
	ErrTokenMissing = errors.New("required authorization token not found")

	// ErrTokenInvalid is the error value that it's returned when
	// a token is not valid.
	ErrTokenInvalid = errors.New("token is invalid")

	// ErrTokenExpired is the error value that it's returned when
	// a token value is found and it's valid but it's expired.
	ErrTokenExpired = errors.New("token is expired")
)

var jwtParser = new(jwt.Parser)

// CheckJWT the main functionality, checks for token
func (m *Middleware) CheckJWT(ctx iris.Context) error {
	if !m.Config.EnableAuthOnOptions {
		if ctx.Method() == iris.MethodOptions {
			return nil
		}
	}

	// Use the specified token extractor to extract a token from the request
	token, err := m.Config.Extractor(ctx)
	// If debugging is turned on, log the outcome
	if err != nil {
		logf(ctx, "Error extracting JWT: %v", err)
		return err
	}

	logf(ctx, "Token extracted: %s", token)

	// If the token is empty...
	if token == "" {
		// Check if it was required
		if m.Config.CredentialsOptional {
			logf(ctx, "No credentials found (CredentialsOptional=true)")
			// No error, just no token (and that is ok given that CredentialsOptional is true)
			return nil
		}

		// If we get here, the required token is missing
		logf(ctx, "Error: No credentials found (CredentialsOptional=false)")
		return ErrTokenMissing
	}

	// Now parse the token

	parsedToken, err := jwtParser.Parse(token, m.Config.ValidationKeyGetter)
	// Check if there was an error in parsing...
	if err != nil {
		logf(ctx, "Error parsing token: %v", err)
		return err
	}

	if m.Config.SigningMethod != nil && m.Config.SigningMethod.Alg() != parsedToken.Header["alg"] {
		err := fmt.Errorf("expected %s signing method but token specified %s",
			m.Config.SigningMethod.Alg(),
			parsedToken.Header["alg"])
		logf(ctx, "Error validating token algorithm: %v", err)
		return err
	}

	// Check if the parsed token is valid...
	if !parsedToken.Valid {
		logf(ctx, "Token is invalid")
		// m.Config.ErrorHandler(ctx, ErrTokenInvalid)
		return ErrTokenInvalid
	}

	if m.Config.Expiration {
		if claims, ok := parsedToken.Claims.(jwt.MapClaims); ok {
			if expired := claims.VerifyExpiresAt(time.Now().Unix(), true); !expired {
				logf(ctx, "Token is expired")
				return ErrTokenExpired
			}
		}
	}

	logf(ctx, "JWT: %v", parsedToken)

	// If we get here, everything worked and we can set the
	// user property in context.
	ctx.Values().Set(m.Config.ContextKey, parsedToken)

	return nil
}
