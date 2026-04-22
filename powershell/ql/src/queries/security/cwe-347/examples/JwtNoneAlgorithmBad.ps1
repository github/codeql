$handler = [System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler]::new()

# BAD: Creating a JWT token with the "none" algorithm disables signature verification.
$token = $handler.CreateToken("none")
