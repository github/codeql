package jwt

import (
	"context"
	"fmt"
	"strconv"
	"time"
)

type Clock interface {
	Now() time.Time
}
type ClockFunc func() time.Time

func (f ClockFunc) Now() time.Time {
	return f()
}

func isSupportedTimeClaim(c string) error {
	switch c {
	case ExpirationKey, IssuedAtKey, NotBeforeKey:
		return nil
	}
	return NewValidationError(fmt.Errorf(`unsupported time claim %s`, strconv.Quote(c)))
}

func timeClaim(t Token, clock Clock, c string) time.Time {
	switch c {
	case ExpirationKey:
		return t.Expiration()
	case IssuedAtKey:
		return t.IssuedAt()
	case NotBeforeKey:
		return t.NotBefore()
	case "":
		return clock.Now()
	}
	return time.Time{} // should *NEVER* reach here, but...
}

// Validate makes sure that the essential claims stand.
//
// See the various `WithXXX` functions for optional parameters
// that can control the behavior of this method.
func Validate(t Token, options ...ValidateOption) error {
	ctx := context.Background()
	trunc := time.Second

	var clock Clock = ClockFunc(time.Now)
	var skew time.Duration
	var validators = []Validator{
		IsIssuedAtValid(),
		IsExpirationValid(),
		IsNbfValid(),
	}
	for _, o := range options {
		//nolint:forcetypeassert
		switch o.Ident() {
		case identClock{}:
			clock = o.Value().(Clock)
		case identAcceptableSkew{}:
			skew = o.Value().(time.Duration)
		case identTruncation{}:
			trunc = o.Value().(time.Duration)
		case identContext{}:
			ctx = o.Value().(context.Context)
		case identValidator{}:
			v := o.Value().(Validator)
			switch v := v.(type) {
			case *isInTimeRange:
				if v.c1 != "" {
					if err := isSupportedTimeClaim(v.c1); err != nil {
						return err
					}
					validators = append(validators, IsRequired(v.c1))
				}
				if v.c2 != "" {
					if err := isSupportedTimeClaim(v.c2); err != nil {
						return err
					}
					validators = append(validators, IsRequired(v.c2))
				}
			}
			validators = append(validators, v)
		}
	}

	ctx = SetValidationCtxSkew(ctx, skew)
	ctx = SetValidationCtxClock(ctx, clock)
	ctx = SetValidationCtxTruncation(ctx, trunc)
	for _, v := range validators {
		if err := v.Validate(ctx, t); err != nil {
			return err
		}
	}

	return nil
}

type isInTimeRange struct {
	c1   string
	c2   string
	dur  time.Duration
	less bool // if true, d =< c1 - c2. otherwise d >= c1 - c2
}

// MaxDeltaIs implements the logic behind `WithMaxDelta()` option
func MaxDeltaIs(c1, c2 string, dur time.Duration) Validator {
	return &isInTimeRange{
		c1:   c1,
		c2:   c2,
		dur:  dur,
		less: true,
	}
}

// MinDeltaIs implements the logic behind `WithMinDelta()` option
func MinDeltaIs(c1, c2 string, dur time.Duration) Validator {
	return &isInTimeRange{
		c1:   c1,
		c2:   c2,
		dur:  dur,
		less: false,
	}
}

func (iitr *isInTimeRange) Validate(ctx context.Context, t Token) ValidationError {
	clock := ValidationCtxClock(ctx) // MUST be populated
	skew := ValidationCtxSkew(ctx)   // MUST be populated
	// We don't check if the claims already exist, because we already did that
	// by piggybacking on `required` check.
	t1 := timeClaim(t, clock, iitr.c1)
	t2 := timeClaim(t, clock, iitr.c2)
	if iitr.less { // t1 - t2 <= iitr.dur
		// t1 - t2 < iitr.dur + skew
		if t1.Sub(t2) > iitr.dur+skew {
			return NewValidationError(fmt.Errorf(`iitr between %s and %s exceeds %s (skew %s)`, iitr.c1, iitr.c2, iitr.dur, skew))
		}
	} else {
		if t1.Sub(t2) < iitr.dur-skew {
			return NewValidationError(fmt.Errorf(`iitr between %s and %s is less than %s (skew %s)`, iitr.c1, iitr.c2, iitr.dur, skew))
		}
	}
	return nil
}

type ValidationError interface {
	error
	isValidationError()
	Unwrap() error
}

func NewValidationError(err error) ValidationError {
	return &validationError{error: err}
}

// This is a generic validation error.
type validationError struct {
	error
}

func (validationError) isValidationError() {}
func (err *validationError) Unwrap() error {
	return err.error
}

type missingRequiredClaimError struct {
	claim string
}

func (err *missingRequiredClaimError) Error() string {
	return fmt.Sprintf("%q not satisfied: required claim not found", err.claim)
}

func (err *missingRequiredClaimError) Is(target error) bool {
	_, ok := target.(*missingRequiredClaimError)
	return ok
}

func (err *missingRequiredClaimError) isValidationError() {}
func (*missingRequiredClaimError) Unwrap() error          { return nil }

type invalidAudienceError struct {
	error
}

func (err *invalidAudienceError) Is(target error) bool {
	_, ok := target.(*invalidAudienceError)
	return ok
}

func (err *invalidAudienceError) isValidationError() {}
func (err *invalidAudienceError) Unwrap() error {
	return err.error
}

func (err *invalidAudienceError) Error() string {
	if err.error == nil {
		return `"aud" not satisfied`
	}
	return err.error.Error()
}

type invalidIssuerError struct {
	error
}

func (err *invalidIssuerError) Is(target error) bool {
	_, ok := target.(*invalidIssuerError)
	return ok
}

func (err *invalidIssuerError) isValidationError() {}
func (err *invalidIssuerError) Unwrap() error {
	return err.error
}

func (err *invalidIssuerError) Error() string {
	if err.error == nil {
		return `"iss" not satisfied`
	}
	return err.error.Error()
}

var errTokenExpired = NewValidationError(fmt.Errorf(`"exp" not satisfied`))
var errInvalidIssuedAt = NewValidationError(fmt.Errorf(`"iat" not satisfied`))
var errTokenNotYetValid = NewValidationError(fmt.Errorf(`"nbf" not satisfied`))
var errInvalidAudience = &invalidAudienceError{}
var errInvalidIssuer = &invalidIssuerError{}
var errRequiredClaim = &missingRequiredClaimError{}

// ErrTokenExpired returns the immutable error used when `exp` claim
// is not satisfied.
//
// The return value should only be used for comparison using `errors.Is()`
func ErrTokenExpired() ValidationError {
	return errTokenExpired
}

// ErrInvalidIssuedAt returns the immutable error used when `iat` claim
// is not satisfied
//
// The return value should only be used for comparison using `errors.Is()`
func ErrInvalidIssuedAt() ValidationError {
	return errInvalidIssuedAt
}

// ErrTokenNotYetValid returns the immutable error used when `nbf` claim
// is not satisfied
//
// The return value should only be used for comparison using `errors.Is()`
func ErrTokenNotYetValid() ValidationError {
	return errTokenNotYetValid
}

// ErrInvalidAudience returns the immutable error used when `aud` claim
// is not satisfied
//
// The return value should only be used for comparison using `errors.Is()`
func ErrInvalidAudience() ValidationError {
	return errInvalidAudience
}

// ErrInvalidIssuer returns the immutable error used when `iss` claim
// is not satisfied
//
// The return value should only be used for comparison using `errors.Is()`
func ErrInvalidIssuer() ValidationError {
	return errInvalidIssuer
}

// ErrMissingRequiredClaim should not have been exported, and will be
// removed in a future release. Use `ErrRequiredClaim()` instead to get
// an error to be used in `errors.Is()`
//
// This function should not have been implemented as a constructor.
// but rather a means to retrieve an opaque and immutable error value
// that could be passed to `errors.Is()`.
func ErrMissingRequiredClaim(name string) ValidationError {
	return &missingRequiredClaimError{claim: name}
}

// ErrRequiredClaim returns the immutable error used when the claim
// specified by `jwt.IsRequired()` is not present.
//
// The return value should only be used for comparison using `errors.Is()`
func ErrRequiredClaim() ValidationError {
	return errRequiredClaim
}

// Validator describes interface to validate a Token.
type Validator interface {
	// Validate should return an error if a required conditions is not met.
	Validate(context.Context, Token) ValidationError
}

// ValidatorFunc is a type of Validator that does not have any
// state, that is implemented as a function
type ValidatorFunc func(context.Context, Token) ValidationError

func (vf ValidatorFunc) Validate(ctx context.Context, tok Token) ValidationError {
	return vf(ctx, tok)
}

type identValidationCtxClock struct{}
type identValidationCtxSkew struct{}
type identValidationCtxTruncation struct{}

func SetValidationCtxClock(ctx context.Context, cl Clock) context.Context {
	return context.WithValue(ctx, identValidationCtxClock{}, cl)
}

func SetValidationCtxTruncation(ctx context.Context, dur time.Duration) context.Context {
	return context.WithValue(ctx, identValidationCtxTruncation{}, dur)
}

func SetValidationCtxSkew(ctx context.Context, dur time.Duration) context.Context {
	return context.WithValue(ctx, identValidationCtxSkew{}, dur)
}

// ValidationCtxClock returns the Clock object associated with
// the current validation context. This value will always be available
// during validation of tokens.
func ValidationCtxClock(ctx context.Context) Clock {
	//nolint:forcetypeassert
	return ctx.Value(identValidationCtxClock{}).(Clock)
}

func ValidationCtxSkew(ctx context.Context) time.Duration {
	//nolint:forcetypeassert
	return ctx.Value(identValidationCtxSkew{}).(time.Duration)
}

func ValidationCtxTruncation(ctx context.Context) time.Duration {
	//nolint:forcetypeassert
	return ctx.Value(identValidationCtxTruncation{}).(time.Duration)
}

// IsExpirationValid is one of the default validators that will be executed.
// It does not need to be specified by users, but it exists as an
// exported field so that you can check what it does.
//
// The supplied context.Context object must have the "clock" and "skew"
// populated with appropriate values using SetValidationCtxClock() and
// SetValidationCtxSkew()
func IsExpirationValid() Validator {
	return ValidatorFunc(isExpirationValid)
}

func isExpirationValid(ctx context.Context, t Token) ValidationError {
	tv := t.Expiration()
	if tv.IsZero() || tv.Unix() == 0 {
		return nil
	}

	clock := ValidationCtxClock(ctx)      // MUST be populated
	skew := ValidationCtxSkew(ctx)        // MUST be populated
	trunc := ValidationCtxTruncation(ctx) // MUST be populated

	now := clock.Now().Truncate(trunc)
	ttv := tv.Truncate(trunc)

	// expiration date must be after NOW
	if !now.Before(ttv.Add(skew)) {
		return ErrTokenExpired()
	}
	return nil
}

// IsIssuedAtValid is one of the default validators that will be executed.
// It does not need to be specified by users, but it exists as an
// exported field so that you can check what it does.
//
// The supplied context.Context object must have the "clock" and "skew"
// populated with appropriate values using SetValidationCtxClock() and
// SetValidationCtxSkew()
func IsIssuedAtValid() Validator {
	return ValidatorFunc(isIssuedAtValid)
}

func isIssuedAtValid(ctx context.Context, t Token) ValidationError {
	tv := t.IssuedAt()
	if tv.IsZero() || tv.Unix() == 0 {
		return nil
	}

	clock := ValidationCtxClock(ctx)      // MUST be populated
	skew := ValidationCtxSkew(ctx)        // MUST be populated
	trunc := ValidationCtxTruncation(ctx) // MUST be populated

	now := clock.Now().Truncate(trunc)
	ttv := tv.Truncate(trunc)

	if now.Before(ttv.Add(-1 * skew)) {
		return ErrInvalidIssuedAt()
	}
	return nil
}

// IsNbfValid is one of the default validators that will be executed.
// It does not need to be specified by users, but it exists as an
// exported field so that you can check what it does.
//
// The supplied context.Context object must have the "clock" and "skew"
// populated with appropriate values using SetValidationCtxClock() and
// SetValidationCtxSkew()
func IsNbfValid() Validator {
	return ValidatorFunc(isNbfValid)
}

func isNbfValid(ctx context.Context, t Token) ValidationError {
	tv := t.NotBefore()
	if tv.IsZero() || tv.Unix() == 0 {
		return nil
	}

	clock := ValidationCtxClock(ctx)      // MUST be populated
	skew := ValidationCtxSkew(ctx)        // MUST be populated
	trunc := ValidationCtxTruncation(ctx) // MUST be populated

	// Truncation always happens even for trunc = 0 because
	// we also use this to strip monotonic clocks
	now := clock.Now().Truncate(trunc)
	ttv := tv.Truncate(trunc)

	// "now" cannot be before t - skew, so we check for now > t - skew
	ttv = ttv.Add(-1 * skew)
	if now.Before(ttv) {
		return ErrTokenNotYetValid()
	}
	return nil
}

type claimContainsString struct {
	name    string
	value   string
	makeErr func(error) ValidationError
}

// ClaimContainsString can be used to check if the claim called `name`, which is
// expected to be a list of strings, contains `value`. Currently because of the
// implementation this will probably only work for `aud` fields.
func ClaimContainsString(name, value string) Validator {
	return claimContainsString{
		name:    name,
		value:   value,
		makeErr: NewValidationError,
	}
}

// IsValidationError returns true if the error is a validation error
func IsValidationError(err error) bool {
	switch err {
	case errTokenExpired, errTokenNotYetValid, errInvalidIssuedAt:
		return true
	default:
		switch err.(type) {
		case *validationError, *invalidAudienceError, *invalidIssuerError, *missingRequiredClaimError:
			return true
		default:
			return false
		}
	}
}

func (ccs claimContainsString) Validate(_ context.Context, t Token) ValidationError {
	v, ok := t.Get(ccs.name)
	if !ok {
		return ccs.makeErr(fmt.Errorf(`claim %q not found`, ccs.name))
	}

	list, ok := v.([]string)
	if !ok {
		return ccs.makeErr(fmt.Errorf(`claim %q must be a []string (got %T)`, ccs.name, v))
	}

	for _, v := range list {
		if v == ccs.value {
			return nil
		}
	}
	return ccs.makeErr(fmt.Errorf(`%q not satisfied`, ccs.name))
}

func makeInvalidAudienceError(err error) ValidationError {
	return &invalidAudienceError{error: err}
}

// audienceClaimContainsString can be used to check if the audience claim, which is
// expected to be a list of strings, contains `value`.
func audienceClaimContainsString(value string) Validator {
	return claimContainsString{
		name:    AudienceKey,
		value:   value,
		makeErr: makeInvalidAudienceError,
	}
}

type claimValueIs struct {
	name    string
	value   interface{}
	makeErr func(error) ValidationError
}

// ClaimValueIs creates a Validator that checks if the value of claim `name`
// matches `value`. The comparison is done using a simple `==` comparison,
// and therefore complex comparisons may fail using this code. If you
// need to do more, use a custom Validator.
func ClaimValueIs(name string, value interface{}) Validator {
	return &claimValueIs{
		name:    name,
		value:   value,
		makeErr: NewValidationError,
	}
}

func (cv *claimValueIs) Validate(_ context.Context, t Token) ValidationError {
	v, ok := t.Get(cv.name)
	if !ok {
		return cv.makeErr(fmt.Errorf(`%q not satisfied: claim %q does not exist`, cv.name, cv.name))
	}
	if v != cv.value {
		return cv.makeErr(fmt.Errorf(`%q not satisfied: values do not match`, cv.name))
	}
	return nil
}

func makeIssuerClaimError(err error) ValidationError {
	return &invalidIssuerError{error: err}
}

// issuerClaimValueIs creates a Validator that checks if the issuer claim
// matches `value`.
func issuerClaimValueIs(value string) Validator {
	return &claimValueIs{
		name:    IssuerKey,
		value:   value,
		makeErr: makeIssuerClaimError,
	}
}

// IsRequired creates a Validator that checks if the required claim `name`
// exists in the token
func IsRequired(name string) Validator {
	return isRequired(name)
}

type isRequired string

func (ir isRequired) Validate(_ context.Context, t Token) ValidationError {
	name := string(ir)
	_, ok := t.Get(name)
	if !ok {
		return &missingRequiredClaimError{claim: name}
	}
	return nil
}
