package auth

import (
	"context"
	"time"

	"go-micro.dev/v4/logger"
)

func NewOptions(opts ...Option) Options {
	options := Options{
		Logger: logger.DefaultLogger,
	}

	for _, o := range opts {
		o(&options)
	}

	return options
}

type Options struct {
	// Logger is the underline logger
	Logger logger.Logger
	// Token is the services token used to authenticate itself
	Token *Token
	// Namespace the service belongs to
	Namespace string
	// ID is the services auth ID
	ID string
	// Secret is used to authenticate the service
	Secret string
	// PublicKey for decoding JWTs
	PublicKey string
	// PrivateKey for encoding JWTs
	PrivateKey string
	// Addrs sets the addresses of auth
	Addrs []string
}

type Option func(o *Options)

// Addrs is the auth addresses to use.
func Addrs(addrs ...string) Option {
	return func(o *Options) {
		o.Addrs = addrs
	}
}

// Namespace the service belongs to.
func Namespace(n string) Option {
	return func(o *Options) {
		o.Namespace = n
	}
}

// PublicKey is the JWT public key.
func PublicKey(key string) Option {
	return func(o *Options) {
		o.PublicKey = key
	}
}

// PrivateKey is the JWT private key.
func PrivateKey(key string) Option {
	return func(o *Options) {
		o.PrivateKey = key
	}
}

// WithLogger sets the underline logger.
func WithLogger(l logger.Logger) Option {
	return func(o *Options) {
		o.Logger = l
	}
}

// Credentials sets the auth credentials.
func Credentials(id, secret string) Option {
	return func(o *Options) {
		o.ID = id
		o.Secret = secret
	}
}

// ClientToken sets the auth token to use when making requests.
func ClientToken(token *Token) Option {
	return func(o *Options) {
		o.Token = token
	}
}

type GenerateOptions struct {
	// Metadata associated with the account
	Metadata map[string]string
	// Provider of the account, e.g. oauth
	Provider string
	// Type of the account, e.g. user
	Type string
	// Secret used to authenticate the account
	Secret string
	// Scopes the account has access too
	Scopes []string
}

type GenerateOption func(o *GenerateOptions)

// WithSecret for the generated account.
func WithSecret(s string) GenerateOption {
	return func(o *GenerateOptions) {
		o.Secret = s
	}
}

// WithType for the generated account.
func WithType(t string) GenerateOption {
	return func(o *GenerateOptions) {
		o.Type = t
	}
}

// WithMetadata for the generated account.
func WithMetadata(md map[string]string) GenerateOption {
	return func(o *GenerateOptions) {
		o.Metadata = md
	}
}

// WithProvider for the generated account.
func WithProvider(p string) GenerateOption {
	return func(o *GenerateOptions) {
		o.Provider = p
	}
}

// WithScopes for the generated account.
func WithScopes(s ...string) GenerateOption {
	return func(o *GenerateOptions) {
		o.Scopes = s
	}
}

// NewGenerateOptions from a slice of options.
func NewGenerateOptions(opts ...GenerateOption) GenerateOptions {
	var options GenerateOptions
	for _, o := range opts {
		o(&options)
	}
	return options
}

type TokenOptions struct {
	// ID for the account
	ID string
	// Secret for the account
	Secret string
	// RefreshToken is used to refesh a token
	RefreshToken string
	// Expiry is the time the token should live for
	Expiry time.Duration
}

type TokenOption func(o *TokenOptions)

// WithExpiry for the token.
func WithExpiry(ex time.Duration) TokenOption {
	return func(o *TokenOptions) {
		o.Expiry = ex
	}
}

func WithCredentials(id, secret string) TokenOption {
	return func(o *TokenOptions) {
		o.ID = id
		o.Secret = secret
	}
}

func WithToken(rt string) TokenOption {
	return func(o *TokenOptions) {
		o.RefreshToken = rt
	}
}

// NewTokenOptions from a slice of options.
func NewTokenOptions(opts ...TokenOption) TokenOptions {
	var options TokenOptions
	for _, o := range opts {
		o(&options)
	}

	// set default expiry of token
	if options.Expiry == 0 {
		options.Expiry = time.Minute
	}

	return options
}

type VerifyOptions struct {
	Context context.Context
}

type VerifyOption func(o *VerifyOptions)

func VerifyContext(ctx context.Context) VerifyOption {
	return func(o *VerifyOptions) {
		o.Context = ctx
	}
}

type ListOptions struct {
	Context context.Context
}

type ListOption func(o *ListOptions)

func RulesContext(ctx context.Context) ListOption {
	return func(o *ListOptions) {
		o.Context = ctx
	}
}
