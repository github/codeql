let unsafeQuery = "SELECT * FROM users WHERE username='\(userControlledString)'" // BAD

try db.execute(unsafeQuery)