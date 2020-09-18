package play.mvc;

import play.i18n.Lang;

import play.mvc.Http.HeaderNames;
import play.mvc.Http.Response;
import play.mvc.Http.Context;
import play.mvc.Http.Request;
import play.mvc.Http.Session;
import play.mvc.Http.Status;
import play.mvc.Http.Flash;

/**
 * Superclass for a Java-based controller.
 */
public abstract class Controller extends Results implements Status, HeaderNames {

    /**
     * Returns the current HTTP context.
     */
    public static Context ctx() {

    }

    /**
     * Returns the current HTTP request.
     */
    public static Request request() {

    }

    /**
     * Returns the current lang.
     */
    public static Lang lang() {

    }

    /**
     * Change durably the lang for the current user
     * @param code New lang code to use (e.g. "fr", "en-US", etc.)
     * @
     */
    public static boolean changeLang(String code) {

    }

    /**
     * Change durably the lang for the current user
     * @param lang New Lang object to use
     * @
     */
    public static boolean changeLang(Lang lang) {

    }

    /**
     * Clear the lang for the current user.
     */
    public static void clearLang() {
    }

    /**
     * Returns the current HTTP response.
     */
    public static Response response() {

    }

    /**
     * Returns the current HTTP session.
     */
    public static Session session() {

    }

    /**
     * Puts a new value into the current session.
     */
    public static void session(String key, String value) {
    }

    /**
     * Returns a value from the session.
     */
    public static String session(String key) {

    }

    /**
     * Returns the current HTTP flash scope.
     */
    public static Flash flash() {

    }

    /**
     * Puts a new value into the flash scope.
     */
    public static void flash(String key, String value) {
    }

    /**
     * Returns a value from the flash scope.
     */
    public static String flash(String key) {

    }

}