package com.example.JwtTest;

import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.util.Optional;
import javax.crypto.KeyGenerator;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;

@WebServlet(name = "Jwt", value = "/Auth")
public class auth0 extends HttpServlet {

  public void doPost(HttpServletRequest request, HttpServletResponse response) {}

  final String JWT_KEY = "KEY";

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

    // OK
    String JwtToken1 = request.getParameter("JWT1");
    decodeToken(JwtToken1);
    try {
      verifyToken(JwtToken1, getSecureRandomKey());
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException(e);
    }

    // only decode, no verification
    String JwtToken2 = request.getParameter("JWT2");
    decodeToken(JwtToken2);


    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    out.println("<html><body>heyyy</body></html>");
  }

  public static boolean verifyToken(final String token, final String key) {
    try {
      JWTVerifier verifier = JWT.require(Algorithm.HMAC256(key)).build();
      verifier.verify(token);
      return true;
    } catch (JWTVerificationException e) {
      System.out.printf("jwt decode fail, token: %s", e);
    }
    return false;
  }

  public static String decodeToken(final String token) {
    DecodedJWT jwt = JWT.decode(token);
    return Optional.of(jwt).map(item -> item.getClaim("userName").asString()).orElse("");
  }
}
