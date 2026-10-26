String PROTECTED_PATTERN = "/protected/.*";
String CONSTRAINT_PATTERN = "/protected/xyz\\.xml";

// BAD: A string with line return e.g. `/protected/%0dxyz` can bypass the path check
Pattern p = Pattern.compile(PROTECTED_PATTERN);
Matcher m = p.matcher(path);

// GOOD: A string with line return e.g. `/protected/%0dxyz` cannot bypass the path check
Pattern p = Pattern.compile(PROTECTED_PATTERN, Pattern.DOTALL);
Matcher m = p.matcher(path);

// GOOD: Only a specific path can pass the validation
Pattern p = Pattern.compile(CONSTRAINT_PATTERN);
Matcher m = p.matcher(path);

if (m.matches()) {
    // Protected page - check access token and redirect to login page
} else {
    // Not protected page - render content
}

// BAD: A string with line return e.g. `/protected/%0axyz` can bypass the path check
boolean matches = path.matches(PROTECTED_PATTERN);

// BAD: A string with line return e.g. `/protected/%0axyz` can bypass the path check
boolean matches = Pattern.matches(PROTECTED_PATTERN, path);

if (matches) {
    // Protected page - check access token and redirect to login page
} else {
    // Not protected page - render content
}
