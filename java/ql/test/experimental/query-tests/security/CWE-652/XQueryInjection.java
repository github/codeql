package com.vuln.v2.controller;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQExpression;
import javax.xml.xquery.XQItemType;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import net.sf.saxon.xqj.SaxonXQDataSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class XQueryInjection {

    public static void main(String[] args) throws Exception {
        XQDataSource xqds = new SaxonXQDataSource();
        XQConnection conn;
        try {
            String name = "admin";
            String query = "declare variable $name as xs:string external;"
                    + " for $user in doc(\"users.xml\")/Users/User[name=$name] return $user/password";
            conn = xqds.getConnection();
            XQExpression expr = conn.createExpression();
            expr.bindString(new QName("name"), name,
                    conn.createAtomicType(XQItemType.XQBASETYPE_STRING));
            XQResultSequence result = expr.executeQuery(query);
            while (result.next()) {
                System.out.println(result.getItemAsString(null));
            }
        } catch (XQException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping
    public void testRequestbad(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        String query = "for $user in doc(\"users.xml\")/Users/User[name='" + name
                + "'] return $user/password";
        XQPreparedExpression xqpe = conn.prepareExpression(query);
        XQResultSequence result = xqpe.executeQuery();
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testRequestbad1(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        XQDataSource xqds = new SaxonXQDataSource();
        String query = "for $user in doc(\"users.xml\")/Users/User[name='" + name
                + "'] return $user/password";
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        XQResultSequence result = expr.executeQuery(query);
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }


    @RequestMapping
    public void testStringtbad(@RequestParam String nameStr) throws XQException {
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        String query = "for $user in doc(\"users.xml\")/Users/User[name='" + nameStr
                + "'] return $user/password";
        XQPreparedExpression xqpe = conn.prepareExpression(query);
        XQResultSequence result = xqpe.executeQuery();
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testStringtbad1(@RequestParam String nameStr) throws XQException {
        XQDataSource xqds = new SaxonXQDataSource();
        String query = "for $user in doc(\"users.xml\")/Users/User[name='" + nameStr
                + "'] return $user/password";
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        XQResultSequence result = expr.executeQuery(query);
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testInputStreambad(HttpServletRequest request) throws Exception {
        InputStream name = request.getInputStream();
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression xqpe = conn.prepareExpression(name);
        XQResultSequence result = xqpe.executeQuery();
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testInputStreambad1(HttpServletRequest request) throws Exception {
        InputStream name = request.getInputStream();
        XQDataSource xqds = new SaxonXQDataSource();
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        XQResultSequence result = expr.executeQuery(name);
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testReaderbad(HttpServletRequest request) throws Exception {
        InputStream name = request.getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(name));
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression xqpe = conn.prepareExpression(br);
        XQResultSequence result = xqpe.executeQuery();
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testReaderbad1(HttpServletRequest request) throws Exception {
        InputStream name = request.getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(name));
        XQDataSource xqds = new SaxonXQDataSource();
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        XQResultSequence result = expr.executeQuery(br);
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void testExecuteCommandbad(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        XQDataSource xqds = new SaxonXQDataSource();
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        //bad code
        expr.executeCommand(name);
        //bad code
        InputStream is = request.getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        expr.executeCommand(br);
        expr.close();
    }

    @RequestMapping
    public void good(HttpServletRequest request) throws XQException {
        String name = request.getParameter("name");
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        String query = "declare variable $name as xs:string external;"
                + " for $user in doc(\"users.xml\")/Users/User[name=$name] return $user/password";
        XQPreparedExpression xqpe = conn.prepareExpression(query);
        xqpe.bindString(new QName("name"), name,
                conn.createAtomicType(XQItemType.XQBASETYPE_STRING));
        XQResultSequence result = xqpe.executeQuery();
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }

    @RequestMapping
    public void good1(HttpServletRequest request) throws XQException {
        String name = request.getParameter("name");
        String query = "declare variable $name as xs:string external;"
                + " for $user in doc(\"users.xml\")/Users/User[name=$name] return $user/password";
        XQDataSource xqds = new SaxonXQDataSource();
        XQConnection conn = xqds.getConnection();
        XQExpression expr = conn.createExpression();
        expr.bindString(new QName("name"), name,
                conn.createAtomicType(XQItemType.XQBASETYPE_STRING));
        XQResultSequence result = expr.executeQuery(query);
        while (result.next()) {
            System.out.println(result.getItemAsString(null));
        }
    }
}

