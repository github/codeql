package jwt

import (
	"context"
	"errors"
	"sync"
	"time"
)

// ErrBlocked indicates that the token has not yet expired
// but was blocked by the server's Blocklist.
var ErrBlocked = errors.New("jwt: token is blocked")

// Blocklist is an in-memory storage of tokens that should be
// immediately invalidated by the server-side.
// The most common way to invalidate a token, e.g. on user logout,
// is to make the client-side remove the token itself.
//
// The end-developer is free to design a custom database for blocked tokens (e.g. redis),
// as long as it implements the TokenValidator interface it is a valid option for the Verify function.
type Blocklist struct {
	Clock func() time.Time
	// GetKey is a function which can be used how to extract
	// the unique identifier for a token, by default
	// it checks if the "jti" is not empty, if it's then the key is the token itself.
	GetKey func(token []byte, claims Claims) string

	entries map[string]int64 // key = token or its ID | value = expiration unix seconds (to remove expired).
	// ^ we could make it a map[*VerifiedToken]struct{} too
	// but let's have a more general usage here.
	mu sync.RWMutex
}

var _ TokenValidator = (*Blocklist)(nil)

// NewBlocklist returns a new up and running in-memory Token Blocklist.
// It accepts the clear every "x" duration. Indeed, this duration
// can match the usual tokens expiration one.
//
// A blocklist implements the `TokenValidator` interface.
func NewBlocklist(gcEvery time.Duration) *Blocklist {
	return NewBlocklistContext(context.Background(), gcEvery)
}

// NewBlocklistContext same as `NewBlocklist`
// but it also accepts a standard Go Context for GC cancelation.
func NewBlocklistContext(ctx context.Context, gcEvery time.Duration) *Blocklist {
	b := &Blocklist{
		entries: make(map[string]int64),
		Clock:   Clock,
		GetKey:  defaultGetKey,
	}

	if gcEvery > 0 {
		go b.runGC(ctx, gcEvery)
	}

	return b
}

func defaultGetKey(token []byte, c Claims) string {
	if c.ID != "" {
		return c.ID
	}

	return BytesToString(token)
}

// ValidateToken completes the `TokenValidator` interface.
// Returns ErrBlocked if the "token" was blocked by this Blocklist.
func (b *Blocklist) ValidateToken(token []byte, c Claims, err error) error {
	key := b.GetKey(token, c)
	if err != nil {
		if err == ErrExpired {
			b.Del(key)
		}

		return err // respect the previous error.
	}

	if has, _ := b.Has(key); has {
		return ErrBlocked
	}

	return nil
}

// InvalidateToken invalidates a verified JWT token.
// It adds the request token, retrieved by Verify method, to this blocklist.
// Next request will be blocked, even if the token was not yet expired.
// This method can be used when the client-side does not clear the token
// on a user logout operation.
func (b *Blocklist) InvalidateToken(token []byte, c Claims) error {
	if len(token) == 0 {
		return ErrMissing
	}

	key := b.GetKey(token, c)

	b.mu.Lock()
	b.entries[key] = c.Expiry
	b.mu.Unlock()

	return nil
}

// Del removes a token based on its "key" from the blocklist.
func (b *Blocklist) Del(key string) error {
	b.mu.Lock()
	delete(b.entries, key)
	b.mu.Unlock()

	return nil
}

// Count returns the total amount of blocked tokens.
func (b *Blocklist) Count() (int64, error) {
	b.mu.RLock()
	n := len(b.entries)
	b.mu.RUnlock()

	return int64(n), nil
}

// Has reports whether the given "key" is blocked by the server.
// This method is called before the token verification,
// so even if was expired it is removed from the blocklist.
func (b *Blocklist) Has(key string) (bool, error) {
	if len(key) == 0 {
		return false, ErrMissing
	}

	b.mu.RLock()
	_, ok := b.entries[key]
	b.mu.RUnlock()

	return ok, nil
}

// GC iterates over all entries and removes expired tokens.
// This method is helpful to keep the list size small.
// Depending on the application, the GC method can be scheduled
// to called every half or a whole hour.
// A good value for a GC cron task is the Token's max age.
func (b *Blocklist) GC() int {
	now := b.Clock().Round(time.Second).Unix()
	var markedForDeletion []string

	b.mu.RLock()
	for token, expiry := range b.entries {
		if now > expiry {
			markedForDeletion = append(markedForDeletion, token)
		}
	}
	b.mu.RUnlock()

	n := len(markedForDeletion)
	if n > 0 {
		for _, token := range markedForDeletion {
			b.mu.Lock()
			delete(b.entries, token)
			b.mu.Unlock()
		}
	}

	return n
}

func (b *Blocklist) runGC(ctx context.Context, every time.Duration) {
	t := time.NewTicker(every)

	for {
		select {
		case <-ctx.Done():
			t.Stop()
			return
		case <-t.C:
			b.GC()
		}
	}
}
