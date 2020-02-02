public boolean isUsernameInPassword(HttpServletRequest request) {
  String username = request.getParameter("username");
  String pasword = request.getParameter("password");

  // BAD: User provided input is being used to create regex without escaping
  Pattern p = Pattern.compile(username);
  Matcher m = p.matcher(password);
  return = m.matches();

  // GOOD: User provided input escaped before being used to create regex
  String safeUsername = Pattern.quote(username);
  Pattern p = Pattern.compile(safeUsername);
  Matcher m = p.matcher(password);
  return = m.matches();
}