package com.online;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TestApiServlet extends HttpServlet {
    private static HashMap hashMap = new HashMap();

    @Override
    protected void doGet(
            HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String resultStr = "TestApiServlet";
        PrintWriter pw = resp.getWriter();
        pw.println(resultStr);
        pw.flush();
    }
}

