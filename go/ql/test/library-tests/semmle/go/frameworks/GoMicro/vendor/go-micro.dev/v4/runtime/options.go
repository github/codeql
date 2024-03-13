package runtime

import (
	"context"
	"io"

	"go-micro.dev/v4/client"
	"go-micro.dev/v4/logger"
)

type Option func(o *Options)

// Options configure runtime.
type Options struct {
	// Scheduler for updates
	Scheduler Scheduler
	// Client to use when making requests
	Client client.Client
	// Logger underline logger
	Logger logger.Logger
	// Service type to manage
	Type string
	// Source of the services repository
	Source string
	// Base image to use
	Image string
}

func NewOptions(opts ...Option) *Options {
	options := &Options{
		Logger: logger.DefaultLogger,
	}

	for _, o := range opts {
		o(options)
	}

	return options
}

// WithSource sets the base image / repository.
func WithSource(src string) Option {
	return func(o *Options) {
		o.Source = src
	}
}

// WithScheduler specifies a scheduler for updates.
func WithScheduler(n Scheduler) Option {
	return func(o *Options) {
		o.Scheduler = n
	}
}

// WithType sets the service type to manage.
func WithType(t string) Option {
	return func(o *Options) {
		o.Type = t
	}
}

// WithImage sets the image to use.
func WithImage(t string) Option {
	return func(o *Options) {
		o.Image = t
	}
}

// WithClient sets the client to use.
func WithClient(c client.Client) Option {
	return func(o *Options) {
		o.Client = c
	}
}

// WithLogger sets the underline logger.
func WithLogger(l logger.Logger) Option {
	return func(o *Options) {
		o.Logger = l
	}
}

type CreateOption func(o *CreateOptions)

type ReadOption func(o *ReadOptions)

// CreateOptions configure runtime services.
type CreateOptions struct {
	// Log output
	Output io.Writer
	// Specify the context to use
	Context context.Context
	// Type of service to create
	Type string
	// Specify the image to use
	Image string
	// Namespace to create the service in
	Namespace string
	// Command to execut
	Command []string
	// Args to pass into command
	Args []string
	// Environment to configure
	Env []string
	// Retries before failing deploy
	Retries int
}

// ReadOptions queries runtime services.
type ReadOptions struct {
	// Specify the context to use
	Context context.Context
	// Service name
	Service string
	// Version queries services with given version
	Version string
	// Type of service
	Type string
	// Namespace the service is running in
	Namespace string
}

// CreateType sets the type of service to create.
func CreateType(t string) CreateOption {
	return func(o *CreateOptions) {
		o.Type = t
	}
}

// CreateImage sets the image to use.
func CreateImage(img string) CreateOption {
	return func(o *CreateOptions) {
		o.Image = img
	}
}

// CreateNamespace sets the namespace.
func CreateNamespace(ns string) CreateOption {
	return func(o *CreateOptions) {
		o.Namespace = ns
	}
}

// CreateContext sets the context.
func CreateContext(ctx context.Context) CreateOption {
	return func(o *CreateOptions) {
		o.Context = ctx
	}
}

// WithCommand specifies the command to execute.
func WithCommand(cmd ...string) CreateOption {
	return func(o *CreateOptions) {
		// set command
		o.Command = cmd
	}
}

// WithArgs specifies the command to execute.
func WithArgs(args ...string) CreateOption {
	return func(o *CreateOptions) {
		// set command
		o.Args = args
	}
}

func WithRetries(retries int) CreateOption {
	return func(o *CreateOptions) {
		o.Retries = retries
	}
}

// WithEnv sets the created service environment.
func WithEnv(env []string) CreateOption {
	return func(o *CreateOptions) {
		o.Env = env
	}
}

// WithOutput sets the arg output.
func WithOutput(out io.Writer) CreateOption {
	return func(o *CreateOptions) {
		o.Output = out
	}
}

// ReadService returns services with the given name.
func ReadService(service string) ReadOption {
	return func(o *ReadOptions) {
		o.Service = service
	}
}

// ReadVersion confifgures service version.
func ReadVersion(version string) ReadOption {
	return func(o *ReadOptions) {
		o.Version = version
	}
}

// ReadType returns services of the given type.
func ReadType(t string) ReadOption {
	return func(o *ReadOptions) {
		o.Type = t
	}
}

// ReadNamespace sets the namespace.
func ReadNamespace(ns string) ReadOption {
	return func(o *ReadOptions) {
		o.Namespace = ns
	}
}

// ReadContext sets the context.
func ReadContext(ctx context.Context) ReadOption {
	return func(o *ReadOptions) {
		o.Context = ctx
	}
}

type UpdateOption func(o *UpdateOptions)

type UpdateOptions struct {
	// Specify the context to use
	Context context.Context
	// Namespace the service is running in
	Namespace string
}

// UpdateNamespace sets the namespace.
func UpdateNamespace(ns string) UpdateOption {
	return func(o *UpdateOptions) {
		o.Namespace = ns
	}
}

// UpdateContext sets the context.
func UpdateContext(ctx context.Context) UpdateOption {
	return func(o *UpdateOptions) {
		o.Context = ctx
	}
}

type DeleteOption func(o *DeleteOptions)

type DeleteOptions struct {
	// Specify the context to use
	Context context.Context
	// Namespace the service is running in
	Namespace string
}

// DeleteNamespace sets the namespace.
func DeleteNamespace(ns string) DeleteOption {
	return func(o *DeleteOptions) {
		o.Namespace = ns
	}
}

// DeleteContext sets the context.
func DeleteContext(ctx context.Context) DeleteOption {
	return func(o *DeleteOptions) {
		o.Context = ctx
	}
}

// LogsOption configures runtime logging.
type LogsOption func(o *LogsOptions)

// LogsOptions configure runtime logging.
type LogsOptions struct {
	// Specify the context to use
	Context context.Context
	// Namespace the service is running in
	Namespace string
	// How many existing lines to show
	Count int64
	// Stream new lines?
	Stream bool
}

// LogsExistingCount confiures how many existing lines to show.
func LogsCount(count int64) LogsOption {
	return func(l *LogsOptions) {
		l.Count = count
	}
}

// LogsStream configures whether to stream new lines.
func LogsStream(stream bool) LogsOption {
	return func(l *LogsOptions) {
		l.Stream = stream
	}
}

// LogsNamespace sets the namespace.
func LogsNamespace(ns string) LogsOption {
	return func(o *LogsOptions) {
		o.Namespace = ns
	}
}

// LogsContext sets the context.
func LogsContext(ctx context.Context) LogsOption {
	return func(o *LogsOptions) {
		o.Context = ctx
	}
}
