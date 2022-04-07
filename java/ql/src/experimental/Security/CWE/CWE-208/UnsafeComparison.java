private boolean UnsafeComparison(String pwd, HttpServletRequest request) {
    String password = request.getParameter("password");
    return password.equals(pwd);        
}

