package com.example.JwtTest;

import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;
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

@WebServlet(name = "JwtTest1", value = "/Auth")
public class auth0 extends HttpServlet {

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();

    // OK: first decode without signature verification
    // and then verify with signature verification
    String JwtToken1 = request.getParameter("JWT1");
    String userName =  decodeToken(JwtToken1);
    verifyToken(JwtToken1, "A Securely generated Key");
    if (Objects.equals(userName, "Admin")) {
      out.println("<html><body>");
      out.println("<h1>" + "heyyy Admin" + "</h1>");
      out.println("</body></html>");
    }

    out.println("<html><body>");
    out.println("<h1>" + "heyyy Nobody" + "</h1>");
    out.println("</body></html>");
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();

    // NOT OK:  only decode, no verification
    String JwtToken2 = request.getParameter("JWT2");
    String userName = decodeToken(JwtToken2);
    if (Objects.equals(userName, "Admin")) {
      out.println("<html><body>");
      out.println("<h1>" + "heyyy Admin" + "</h1>");
      out.println("</body></html>");
    }

    // OK:  no clue of the use of unsafe decoded JWT return value
    JwtToken2 = request.getParameter("JWT2");
    JWT.decode(JwtToken2);


    out.println("<html><body>");
    out.println("<h1>" + "heyyy Nobody" + "</h1>");
    out.println("</body></html>");
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
