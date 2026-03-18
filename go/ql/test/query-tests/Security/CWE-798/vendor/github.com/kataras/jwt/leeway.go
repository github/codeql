package jwt

import "time"

// Leeway adds validation for a leeway expiration time.
// If the token was not expired then a comparison between
// this "leeway" and the token's "exp" one is expected to pass instead (now+leeway > exp).
// Example of use case: disallow tokens that are going to be expired in 3 seconds from now,
// this is useful to make sure that the token is valid when the when the user fires a database call for example.
func Leeway(leeway time.Duration) TokenValidatorFunc {
	return func(_ []byte, standardClaims Claims, err error) error {
		if err == nil {
			if Clock().Add(leeway).Round(time.Second).Unix() > standardClaims.Expiry {
				return ErrExpired
			}
		}

		return err
	}
}
