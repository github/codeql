package jwt

import (
	"context"
	"crypto/rsa"
	"github.com/gogf/gf/v2/crypto/gmd5"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gcache"
	"io/ioutil"
	"net/http"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

// MapClaims type that uses the map[string]interface{} for JSON decoding
// This is the default claims type if you don't supply one
type MapClaims map[string]interface{}

// GfJWTMiddleware provides a Json-Web-Token authentication implementation. On failure, a 401 HTTP response
// is returned. On success, the wrapped middleware is called, and the userID is made available as
// c.Get("userID").(string).
// Users can get a token by posting a json request to LoginHandler. The token then needs to be passed in
// the Authentication header. Example: Authorization:Bearer XXX_TOKEN_XXX
type GfJWTMiddleware struct {
	// Realm name to display to the user. Required.
	Realm string

	// signing algorithm - possible values are HS256, HS384, HS512, RS256, RS384 or RS512
	// Optional, default is HS256.
	SigningAlgorithm string

	// Secret key used for signing. Required.
	Key []byte

	// Callback to retrieve key used for signing. Setting KeyFunc will bypass
	// all other key settings
	KeyFunc func(token *jwt.Token) (interface{}, error)

	// Duration that a jwt token is valid. Optional, defaults to one hour.
	Timeout time.Duration

	// This field allows clients to refresh their token until MaxRefresh has passed.
	// Note that clients can refresh their token in the last moment of MaxRefresh.
	// This means that the maximum validity timespan for a token is TokenTime + MaxRefresh.
	// Optional, defaults to 0 meaning not refreshable.
	MaxRefresh time.Duration

	// Callback function that should perform the authentication of the user based on login info.
	// Must return user data as user identifier, it will be stored in Claim Array. Required.
	// Check error (e) to determine the appropriate error message.
	Authenticator func(ctx context.Context) (interface{}, error)

	// Callback function that should perform the authorization of the authenticated user. Called
	// only after an authentication success. Must return true on success, false on failure.
	// Optional, default to success.
	Authorizator func(data interface{}, ctx context.Context) bool

	// Callback function that will be called during login.
	// Using this function it is possible to add additional payload data to the web token.
	// The data is then made available during requests via c.Get(jwt.PayloadKey).
	// Note that the payload is not encrypted.
	// The attributes mentioned on jwt.io can't be used as keys for the map.
	// Optional, by default no additional data will be set.
	PayloadFunc func(data interface{}) MapClaims

	// User can define own Unauthorized func.
	Unauthorized func(ctx context.Context, code int, message string)

	// Set the identity handler function
	IdentityHandler func(ctx context.Context) interface{}

	// Set the identity key
	IdentityKey string

	// TokenLookup is a string in the form of "<source>:<name>" that is used
	// to extract token from the request.
	// Optional. Default value "header:Authorization".
	// Possible values:
	// - "header:<name>"
	// - "query:<name>"
	// - "cookie:<name>"
	TokenLookup string

	// TokenHeadName is a string in the header. Default value is "Bearer"
	TokenHeadName string

	// TimeFunc provides the current time. You can override it to use another time value. This is useful for testing or if your server uses a different time zone than your tokens.
	TimeFunc func() time.Time

	// HTTP Status messages for when something in the JWT middleware fails.
	// Check error (e) to determine the appropriate error message.
	HTTPStatusMessageFunc func(e error, ctx context.Context) string

	// Private key file for asymmetric algorithms
	PrivKeyFile string

	// Private Key bytes for asymmetric algorithms
	//
	// Note: PrivKeyFile takes precedence over PrivKeyBytes if both are set
	PrivKeyBytes []byte

	// Public key file for asymmetric algorithms
	PubKeyFile string

	// Private key passphrase
	PrivateKeyPassphrase string

	// Public key bytes for asymmetric algorithms.
	//
	// Note: PubKeyFile takes precedence over PubKeyBytes if both are set
	PubKeyBytes []byte

	// Private key
	privKey *rsa.PrivateKey

	// Public key
	pubKey *rsa.PublicKey

	// Optionally return the token as a cookie
	SendCookie bool

	// Duration that a cookie is valid. Optional, by default equals to Timeout value.
	CookieMaxAge time.Duration

	// Allow insecure cookies for development over http
	SecureCookie bool

	// Allow cookies to be accessed client side for development
	CookieHTTPOnly bool

	// Allow cookie domain change for development
	CookieDomain string

	// SendAuthorization allow return authorization header for every request
	SendAuthorization bool

	// Disable abort() of context.
	DisabledAbort bool

	// CookieName allow cookie name change for development
	CookieName string

	// CacheAdapter
	CacheAdapter gcache.Adapter
}

var (
	// TokenKey default jwt token key in params
	TokenKey = "JWT_TOKEN"
	// PayloadKey default jwt payload key in params
	PayloadKey = "JWT_PAYLOAD"
	// IdentityKey default identity key
	IdentityKey = "identity"
	// The blacklist stores tokens that have not expired but have been deactivated.
	blacklist = gcache.New()
)

// New for check error with GfJWTMiddleware
func New(mw *GfJWTMiddleware) *GfJWTMiddleware {
	if mw.TokenLookup == "" {
		mw.TokenLookup = "header:Authorization"
	}

	if mw.SigningAlgorithm == "" {
		mw.SigningAlgorithm = "HS256"
	}

	if mw.Timeout == 0 {
		mw.Timeout = time.Hour
	}

	if mw.TimeFunc == nil {
		mw.TimeFunc = time.Now
	}

	mw.TokenHeadName = strings.TrimSpace(mw.TokenHeadName)
	if len(mw.TokenHeadName) == 0 {
		mw.TokenHeadName = "Bearer"
	}

	if mw.Authorizator == nil {
		mw.Authorizator = func(data interface{}, ctx context.Context) bool {
			return true
		}
	}

	if mw.Unauthorized == nil {
		mw.Unauthorized = func(ctx context.Context, code int, message string) {
			r := g.RequestFromCtx(ctx)
			r.Response.WriteJson(g.Map{
				"code":    code,
				"message": message,
			})
		}
	}

	if mw.IdentityKey == "" {
		mw.IdentityKey = IdentityKey
	}

	if mw.IdentityHandler == nil {
		mw.IdentityHandler = func(ctx context.Context) interface{} {
			claims := ExtractClaims(ctx)
			return claims[mw.IdentityKey]
		}
	}

	if mw.HTTPStatusMessageFunc == nil {
		mw.HTTPStatusMessageFunc = func(e error, ctx context.Context) string {
			return e.Error()
		}
	}

	if mw.Realm == "" {
		mw.Realm = "gf jwt"
	}

	if mw.CookieMaxAge == 0 {
		mw.CookieMaxAge = mw.Timeout
	}

	if mw.CookieName == "" {
		mw.CookieName = "jwt"
	}

	// bypass other key settings if KeyFunc is set
	if mw.KeyFunc != nil {
		return nil
	}

	if mw.usingPublicKeyAlgo() {
		if err := mw.readKeys(); err != nil {
			panic(err)
		}
	}

	if mw.Key == nil {
		panic(ErrMissingSecretKey)
	}

	if mw.CacheAdapter != nil {
		blacklist.SetAdapter(mw.CacheAdapter)
	}

	return mw
}

// MiddlewareFunc makes GfJWTMiddleware implement the Middleware interface.
func (mw *GfJWTMiddleware) MiddlewareFunc() ghttp.HandlerFunc {
	return func(r *ghttp.Request) {
		mw.middlewareImpl(r.GetCtx())
	}
}

// GetClaimsFromJWT get claims from JWT token
func (mw *GfJWTMiddleware) GetClaimsFromJWT(ctx context.Context) (MapClaims, string, error) {
	r := g.RequestFromCtx(ctx)

	token, err := mw.parseToken(r)
	if err != nil {
		return nil, "", err
	}

	if mw.SendAuthorization {
		token := r.Get(TokenKey).String()
		if len(token) > 0 {
			r.Header.Set("Authorization", mw.TokenHeadName+" "+token)
		}
	}

	claims := MapClaims{}
	for key, value := range token.Claims.(jwt.MapClaims) {
		claims[key] = value
	}

	return claims, token.Raw, nil
}

// LoginHandler can be used by clients to get a jwt token.
// Payload needs to be json in the form of {"username": "USERNAME", "password": "PASSWORD"}.
// Reply will be of the form {"token": "TOKEN"}.
func (mw *GfJWTMiddleware) LoginHandler(ctx context.Context) (tokenString string, expire time.Time) {
	if mw.Authenticator == nil {
		mw.unauthorized(ctx, http.StatusInternalServerError, mw.HTTPStatusMessageFunc(ErrMissingAuthenticatorFunc, ctx))
		return
	}

	data, err := mw.Authenticator(ctx)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	r := g.RequestFromCtx(ctx)
	// Create the token
	token := jwt.New(jwt.GetSigningMethod(mw.SigningAlgorithm))
	claims := token.Claims.(jwt.MapClaims)

	if mw.PayloadFunc != nil {
		for key, value := range mw.PayloadFunc(data) {
			claims[key] = value
		}
	}

	if _, ok := claims[mw.IdentityKey]; !ok {
		mw.unauthorized(ctx, http.StatusInternalServerError, mw.HTTPStatusMessageFunc(ErrMissingIdentity, ctx))
		return
	}

	expire = mw.TimeFunc().Add(mw.Timeout)
	claims["exp"] = expire.Unix()
	claims["orig_iat"] = mw.TimeFunc().Unix()

	tokenString, err = mw.signedString(token)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(ErrFailedTokenCreation, ctx))
		return
	}

	// set cookie
	if mw.SendCookie {
		expireCookie := mw.TimeFunc().Add(mw.CookieMaxAge)
		maxAge := int(expireCookie.Unix() - mw.TimeFunc().Unix())
		r.Cookie.SetCookie(mw.CookieName, tokenString, mw.CookieDomain, "/", time.Duration(maxAge)*time.Second)
	}

	return
}

// LogoutHandler can be used by clients to remove the jwt cookie (if set)
func (mw *GfJWTMiddleware) LogoutHandler(ctx context.Context) {
	r := g.RequestFromCtx(ctx)

	// delete auth cookie
	if mw.SendCookie {
		r.Cookie.SetCookie(mw.CookieName, "", mw.CookieDomain, "/", -1)
	}

	claims, token, err := mw.CheckIfTokenExpire(ctx)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	err = mw.setBlacklist(ctx, token, claims)

	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	return
}

// RefreshHandler can be used to refresh a token. The token still needs to be valid on refresh.
// Shall be put under an endpoint that is using the GfJWTMiddleware.
// Reply will be of the form {"token": "TOKEN"}.
func (mw *GfJWTMiddleware) RefreshHandler(ctx context.Context) (tokenString string, expire time.Time) {
	tokenString, expire, err := mw.RefreshToken(ctx)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	return
}

// RefreshToken refresh token and check if token is expired
func (mw *GfJWTMiddleware) RefreshToken(ctx context.Context) (string, time.Time, error) {
	claims, token, err := mw.CheckIfTokenExpire(ctx)
	if err != nil {
		return "", time.Now(), err
	}

	r := g.RequestFromCtx(ctx)
	// Create the token
	newToken := jwt.New(jwt.GetSigningMethod(mw.SigningAlgorithm))
	newClaims := newToken.Claims.(jwt.MapClaims)

	for key := range claims {
		newClaims[key] = claims[key]
	}

	expire := mw.TimeFunc().Add(mw.Timeout)
	newClaims["exp"] = expire.Unix()
	newClaims["orig_iat"] = mw.TimeFunc().Unix()
	tokenString, err := mw.signedString(newToken)
	if err != nil {
		return "", time.Now(), err
	}

	// set cookie
	if mw.SendCookie {
		expireCookie := mw.TimeFunc().Add(mw.CookieMaxAge)
		maxAge := int(expireCookie.Unix() - time.Now().Unix())
		r.Cookie.SetCookie(mw.CookieName, tokenString, mw.CookieDomain, "/", time.Duration(maxAge)*time.Second)
	}

	// set old token in blacklist
	err = mw.setBlacklist(ctx, token, claims)
	if err != nil {
		return "", time.Now(), err
	}

	return tokenString, expire, nil
}

// CheckIfTokenExpire check if token expire
func (mw *GfJWTMiddleware) CheckIfTokenExpire(ctx context.Context) (jwt.MapClaims, string, error) {
	r := g.RequestFromCtx(ctx)

	token, err := mw.parseToken(r)
	if err != nil {
		// If we receive an error, and the error is anything other than a single
		// ValidationErrorExpired, we want to return the error.
		// If the error is just ValidationErrorExpired, we want to continue, as we can still
		// refresh the token if it's within the MaxRefresh time.
		// (see https://github.com/appleboy/gin-jwt/issues/176)
		validationErr, ok := err.(*jwt.ValidationError)
		if !ok || validationErr.Errors != jwt.ValidationErrorExpired {
			return nil, "", err
		}
	}

	in, err := mw.inBlacklist(ctx, token.Raw)
	if err != nil {
		return nil, "", err
	}
	if in {
		return nil, "", ErrInvalidToken
	}

	claims := token.Claims.(jwt.MapClaims)

	origIat := int64(claims["orig_iat"].(float64))

	if origIat < mw.TimeFunc().Add(-mw.MaxRefresh).Unix() {
		return nil, "", ErrExpiredToken
	}

	return claims, token.Raw, nil
}

// TokenGenerator method that clients can use to get a jwt token.
func (mw *GfJWTMiddleware) TokenGenerator(data interface{}) (string, time.Time, error) {
	token := jwt.New(jwt.GetSigningMethod(mw.SigningAlgorithm))
	claims := token.Claims.(jwt.MapClaims)

	if mw.PayloadFunc != nil {
		for key, value := range mw.PayloadFunc(data) {
			claims[key] = value
		}
	}

	expire := mw.TimeFunc().UTC().Add(mw.Timeout)
	claims["exp"] = expire.Unix()
	claims["orig_iat"] = mw.TimeFunc().Unix()
	tokenString, err := mw.signedString(token)
	if err != nil {
		return "", time.Time{}, err
	}

	return tokenString, expire, nil
}

// GetToken help to get the JWT token string
func (mw *GfJWTMiddleware) GetToken(ctx context.Context) string {
	r := g.RequestFromCtx(ctx)
	token := r.Get(TokenKey).String()
	if len(token) == 0 {
		return ""
	}
	return token
}

// GetPayload help to get the payload map
func (mw *GfJWTMiddleware) GetPayload(ctx context.Context) string {
	r := g.RequestFromCtx(ctx)
	token := r.Get(PayloadKey).String()
	if len(token) == 0 {
		return ""
	}
	return token
}

// GetIdentity help to get the identity
func (mw *GfJWTMiddleware) GetIdentity(ctx context.Context) interface{} {
	r := g.RequestFromCtx(ctx)
	return r.Get(mw.IdentityKey)
}

// ExtractClaims help to extract the JWT claims
func ExtractClaims(ctx context.Context) MapClaims {
	r := g.RequestFromCtx(ctx)
	claims := r.GetParam(PayloadKey).Interface()
	return claims.(MapClaims)
}

// ExtractClaimsFromToken help to extract the JWT claims from token
func ExtractClaimsFromToken(token *jwt.Token) MapClaims {
	if token == nil {
		return make(MapClaims)
	}

	claims := MapClaims{}
	for key, value := range token.Claims.(jwt.MapClaims) {
		claims[key] = value
	}

	return claims
}

// ================= private func =================
func (mw *GfJWTMiddleware) readKeys() error {
	err := mw.privateKey()
	if err != nil {
		return err
	}
	err = mw.publicKey()
	if err != nil {
		return err
	}
	return nil
}

func (mw *GfJWTMiddleware) privateKey() error {
	var keyData []byte
	if mw.PrivKeyFile == "" {
		keyData = mw.PrivKeyBytes
	} else {
		fileContent, err := ioutil.ReadFile(mw.PrivKeyFile)
		if err != nil {
			return ErrNoPrivKeyFile
		}
		keyData = fileContent
	}

	if mw.PrivateKeyPassphrase != "" {
		//nolint:static check
		key, err := jwt.ParseRSAPrivateKeyFromPEMWithPassword(keyData, mw.PrivateKeyPassphrase)
		if err != nil {
			return ErrInvalidPrivKey
		}
		mw.privKey = key
		return nil
	}

	key, err := jwt.ParseRSAPrivateKeyFromPEM(keyData)
	if err != nil {
		return ErrInvalidPrivKey
	}
	mw.privKey = key
	return nil
}

func (mw *GfJWTMiddleware) publicKey() error {
	var keyData []byte
	if mw.PubKeyFile == "" {
		keyData = mw.PubKeyBytes
	} else {
		fileContent, err := ioutil.ReadFile(mw.PubKeyFile)
		if err != nil {
			return ErrNoPubKeyFile
		}
		keyData = fileContent
	}

	key, err := jwt.ParseRSAPublicKeyFromPEM(keyData)
	if err != nil {
		return ErrInvalidPubKey
	}
	mw.pubKey = key
	return nil
}

func (mw *GfJWTMiddleware) usingPublicKeyAlgo() bool {
	switch mw.SigningAlgorithm {
	case "RS256", "RS512", "RS384":
		return true
	}
	return false
}

func (mw *GfJWTMiddleware) signedString(token *jwt.Token) (string, error) {
	var tokenString string
	var err error
	if mw.usingPublicKeyAlgo() {
		tokenString, err = token.SignedString(mw.privKey)
	} else {
		tokenString, err = token.SignedString(mw.Key)
	}
	return tokenString, err
}

func (mw *GfJWTMiddleware) jwtFromHeader(r *ghttp.Request, key string) (string, error) {
	authHeader := r.Header.Get(key)

	if authHeader == "" {
		return "", ErrEmptyAuthHeader
	}

	parts := strings.SplitN(authHeader, " ", 2)
	if !(len(parts) == 2 && parts[0] == mw.TokenHeadName) {
		return "", ErrInvalidAuthHeader
	}

	return parts[1], nil
}

func (mw *GfJWTMiddleware) jwtFromQuery(r *ghttp.Request, key string) (string, error) {
	token := r.Get(key).String()

	if token == "" {
		return "", ErrEmptyQueryToken
	}

	return token, nil
}

func (mw *GfJWTMiddleware) jwtFromCookie(r *ghttp.Request, key string) (string, error) {
	cookie := r.Cookie.Get(key).String()

	if cookie == "" {
		return "", ErrEmptyCookieToken
	}

	return cookie, nil
}

func (mw *GfJWTMiddleware) jwtFromParam(r *ghttp.Request, key string) (string, error) {
	token := r.Get(key).String()

	if token == "" {
		return "", ErrEmptyParamToken
	}

	return token, nil
}

func (mw *GfJWTMiddleware) parseToken(r *ghttp.Request) (*jwt.Token, error) {
	var token string
	var err error

	methods := strings.Split(mw.TokenLookup, ",")
	for _, method := range methods {
		if len(token) > 0 {
			break
		}
		parts := strings.Split(strings.TrimSpace(method), ":")
		k := strings.TrimSpace(parts[0])
		v := strings.TrimSpace(parts[1])
		switch k {
		case "header":
			token, err = mw.jwtFromHeader(r, v)
		case "query":
			token, err = mw.jwtFromQuery(r, v)
		case "cookie":
			token, err = mw.jwtFromCookie(r, v)
		case "param":
			token, err = mw.jwtFromParam(r, v)
		}
	}

	if err != nil {
		return nil, err
	}

	if mw.KeyFunc != nil {
		return jwt.Parse(token, mw.KeyFunc)
	}

	return jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if jwt.GetSigningMethod(mw.SigningAlgorithm) != t.Method {
			return nil, ErrInvalidSigningAlgorithm
		}
		if mw.usingPublicKeyAlgo() {
			return mw.pubKey, nil
		}

		// save token string if valid
		r.SetParam(TokenKey, token)

		return mw.Key, nil
	})
}

func (mw *GfJWTMiddleware) parseTokenString(token string) (*jwt.Token, error) {
	if mw.KeyFunc != nil {
		return jwt.Parse(token, mw.KeyFunc)
	}

	return jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if jwt.GetSigningMethod(mw.SigningAlgorithm) != t.Method {
			return nil, ErrInvalidSigningAlgorithm
		}
		if mw.usingPublicKeyAlgo() {
			return mw.pubKey, nil
		}

		return mw.Key, nil
	})
}

func (mw *GfJWTMiddleware) unauthorized(ctx context.Context, code int, message string) {
	r := g.RequestFromCtx(ctx)
	r.Header.Set("WWW-Authenticate", "JWT realm="+mw.Realm)
	mw.Unauthorized(ctx, code, message)
	if !mw.DisabledAbort {
		r.ExitAll()
	}
}

func (mw *GfJWTMiddleware) middlewareImpl(ctx context.Context) {
	r := g.RequestFromCtx(ctx)

	claims, token, err := mw.GetClaimsFromJWT(ctx)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	if claims["exp"] == nil {
		mw.unauthorized(ctx, http.StatusBadRequest, mw.HTTPStatusMessageFunc(ErrMissingExpField, ctx))
		return
	}

	if _, ok := claims["exp"].(float64); !ok {
		mw.unauthorized(ctx, http.StatusBadRequest, mw.HTTPStatusMessageFunc(ErrWrongFormatOfExp, ctx))
		return
	}

	if int64(claims["exp"].(float64)) < mw.TimeFunc().Unix() {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(ErrExpiredToken, ctx))
		return
	}

	in, err := mw.inBlacklist(ctx, token)
	if err != nil {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(err, ctx))
		return
	}

	if in {
		mw.unauthorized(ctx, http.StatusUnauthorized, mw.HTTPStatusMessageFunc(ErrInvalidToken, ctx))
		return
	}

	r.SetParam(PayloadKey, claims)

	identity := mw.IdentityHandler(ctx)
	if identity != nil {
		r.SetParam(mw.IdentityKey, identity)
	}

	if !mw.Authorizator(identity, ctx) {
		mw.unauthorized(ctx, http.StatusForbidden, mw.HTTPStatusMessageFunc(ErrForbidden, ctx))
		return
	}

	//c.Next() todo
}

func (mw *GfJWTMiddleware) setBlacklist(ctx context.Context, token string, claims jwt.MapClaims) error {
	// The goal of MD5 is to reduce the key length.
	token, err := gmd5.EncryptString(token)

	if err != nil {
		return err
	}

	exp := int64(claims["exp"].(float64))

	// save duration time = (exp + max_refresh) - now
	duration := time.Unix(exp, 0).Add(mw.MaxRefresh).Sub(mw.TimeFunc()).Truncate(time.Second)

	// global gcache
	err = blacklist.Set(ctx, token, true, duration)

	if err != nil {
		return err
	}

	return nil
}

func (mw *GfJWTMiddleware) inBlacklist(ctx context.Context, token string) (bool, error) {
	// The goal of MD5 is to reduce the key length.
	tokenRaw, err := gmd5.EncryptString(token)

	if err != nil {
		return false, nil
	}

	// Global gcache
	if in, err := blacklist.Contains(ctx, tokenRaw); err != nil {
		return false, nil
	} else {
		return in, nil
	}
}
