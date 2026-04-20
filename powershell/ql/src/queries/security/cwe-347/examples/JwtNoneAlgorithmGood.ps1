$handler = [System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler]::new()

# GOOD: Creating a JWT token with a secure algorithm.
$token = $handler.CreateToken("HS256")
