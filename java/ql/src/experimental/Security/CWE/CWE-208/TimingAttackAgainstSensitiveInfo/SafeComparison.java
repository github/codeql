private boolean safeComparison(String pwd, HttpServletRequest request) {
      String password = request.getParameter("password");
      return MessageDigest.isEqual(password.getBytes(StandardCharsets.UTF_8), pwd.getBytes(StandardCharsets.UTF_8));
}

