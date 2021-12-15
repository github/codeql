package play.mvc;

import play.i18n.Lang;
import play.mvc.Http.Context;
import play.mvc.Http.Flash;
import play.mvc.Http.HeaderNames;
import play.mvc.Http.Request;
import play.mvc.Http.Response;
import play.mvc.Http.Session;
import play.mvc.Http.Status;

public abstract class Controller extends Results implements Status, HeaderNames {

  public static Context ctx() {
    return null;
  }

  public static Request request() {
    return null;
  }

  public static Lang lang() {
    return null;
  }

  public static boolean changeLang(String code) {
    return true;
  }

  public static boolean changeLang(Lang lang) {
    return true;
  }

  public static void clearLang() {}

  public static Response response() {
    return null;
  }

  public static Session session() {
    return null;
  }

  public static void session(String key, String value) {}

  public static String session(String key) {
    return "";
  }

  public static Flash flash() {
    return null;
  }

  public static void flash(String key, String value) {}

  public static String flash(String key) {
    return "";
  }
}
