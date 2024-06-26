import java.lang.reflect.Method;
import java.net.URI;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.ws.rs.core.AbstractMultivaluedMap;
import jakarta.ws.rs.core.CacheControl;
import jakarta.ws.rs.core.Cookie;
import jakarta.ws.rs.core.EntityTag;
import jakarta.ws.rs.core.Form;
import jakarta.ws.rs.core.GenericEntity;
import jakarta.ws.rs.core.HttpHeaders;
import jakarta.ws.rs.core.Link;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.MultivaluedHashMap;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.NewCookie;
import jakarta.ws.rs.core.PathSegment;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriBuilder;
import jakarta.ws.rs.core.UriInfo;
import jakarta.ws.rs.core.Variant;

public class JakartaRsFlow {
  String taint() { return "tainted"; }

  private static class ResponseSource {
    static Response taint() { return null; }
  }

  private static class ResponseBuilderSource {
    static Response.ResponseBuilder taint() { return Response.noContent(); }
  }

  private static class IntSource {
    static int taint() { return 0; }
  }

  private static class BooleanSource {
    static boolean taint() { return false; }
  }

  private static class DateSource {
    static Date taint() { return null; }
  }

  private static class SetStringSource {
    static Set<String> taint() { return new HashSet<String>(); }
  }

  static HttpHeaders taint(HttpHeaders h) { return h; }

  static PathSegment taint(PathSegment ps) { return ps; }

  static UriInfo taint(UriInfo ui) { return ui; }

  static Map taint(Map m) { return m; }

  static Link taint(Link l) { return l; }

  static Class taint(Class c) { return c; }

  private static class UriSource {
    static URI taint() throws Exception { return new URI(""); }
  }

  void sink(Object o) {}

  void testResponse() {
    sink(Response.accepted(taint())); // $ hasTaintFlow
    sink(Response.fromResponse(ResponseSource.taint())); // $ hasTaintFlow
    sink(Response.ok(taint())); // $ hasTaintFlow
    sink(Response.ok(taint(), new MediaType())); // $ hasTaintFlow
    sink(Response.ok(taint(), "type")); // $ hasTaintFlow
    sink(Response.ok(taint(), new Variant(new MediaType(), "", ""))); // $ hasTaintFlow
  }

  void testResponseBuilder(MultivaluedMap<String,Object> multivaluedMap, List<Variant> list) throws Exception {
    sink(ResponseBuilderSource.taint().build()); // $ hasTaintFlow
    sink(Response.noContent().entity(taint())); // $ hasTaintFlow
    sink(ResponseBuilderSource.taint().allow(new HashSet<String>())); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().cacheControl(new CacheControl())); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().clone()); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().contentLocation(new URI(""))); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().cookie()); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().encoding("")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().entity("")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().expires(new Date())); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().header("", "")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().language("")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().lastModified(new Date())); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().link("", "")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().link(new URI(""), "")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().links()); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().location(new URI(""))); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().replaceAll(multivaluedMap)); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().status(400)); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().tag(new EntityTag(""))); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().tag("")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().type("")); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().variant(new Variant(new MediaType(), "", ""))); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().variants(list)); // $ hasValueFlow
    sink(ResponseBuilderSource.taint().variants()); // $ hasValueFlow
  }

  void testHttpHeaders(HttpHeaders h) {
    sink(taint(h).getAcceptableLanguages()); // $ hasTaintFlow
    sink(taint(h).getAcceptableMediaTypes()); // $ hasTaintFlow
    sink(taint(h).getCookies()); // $ hasTaintFlow
    sink(taint(h).getHeaderString("")); // $ hasTaintFlow
    sink(taint(h).getLanguage()); // $ hasTaintFlow
    sink(taint(h).getMediaType()); // $ hasTaintFlow
    sink(taint(h).getRequestHeader("")); // $ hasTaintFlow
    sink(taint(h).getRequestHeaders()); // $ hasTaintFlow
  }

  void testMultivaluedMapAdd(MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2) {
    mm1.add(taint(), "value");
    sink(mm1.keySet().iterator().next()); // $ hasValueFlow
    mm2.add("key", taint());
    sink(mm2.get("key").get(0)); // $ hasValueFlow
  }

  void testMultivaluedMapAddAll(MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2, MultivaluedMap<String, String> mm3) {
    mm1.addAll(taint(), "a", "b");
    sink(mm1.keySet().iterator().next()); // $ hasValueFlow
    List<String> l = new ArrayList<String>();
    l.add(taint());
    mm2.addAll("key", l);
    sink(mm2.get("key").get(0)); // $ hasValueFlow
    mm3.addAll("key", "a", taint());
    sink(mm3.get("key").get(0)); // $ hasValueFlow
  }

  void testMultivaluedMapAddFirst(MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2) {
    mm1.addFirst(taint(), "value");
    sink(mm1.keySet().iterator().next()); // $ hasValueFlow
    mm2.addFirst("key", taint());
    sink(mm2.get("key").get(0)); // $ hasValueFlow
    sink(mm2.getFirst("key")); // $ hasValueFlow
  }

  void testMultivaluedMapputSingle(MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2) {
    mm1.putSingle(taint(), "value");
    sink(mm1.keySet().iterator().next()); // $ hasValueFlow
    mm2.putSingle("key", taint());
    sink(mm2.get("key").get(0)); // $ hasValueFlow
  }

  class MyAbstractMultivaluedMapJak<K, V> extends AbstractMultivaluedMap<K, V> {
    public MyAbstractMultivaluedMapJak(Map<K, List<V>> map) {
        super(map);
    }
  }

  void testAbstractMultivaluedMap(Map<String, List<String>> map1, Map<String, List<String>> map2, List<String> list) {
    map1.put(taint(), list);
    AbstractMultivaluedMap<String, String> amm1 = new MyAbstractMultivaluedMapJak<String, String>(map1);
    sink(amm1.keySet().iterator().next()); // $ hasValueFlow

    list.add(taint());
    map2.put("key", list);
    AbstractMultivaluedMap<String, String> amm2 = new MyAbstractMultivaluedMapJak<String, String>(map2);
    sink(amm2.get("key").get(0)); // $ hasValueFlow

    AbstractMultivaluedMap<String, String> amm3 = new MyAbstractMultivaluedMapJak<String, String>(null);
    amm3.put("key", list);
    sink(amm3.get("key").get(0)); // $ hasValueFlow
  }

  void testMultivaluedHashMap(Map<String, String> map1, Map<String, String> map2,
      MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2) {
    map1.put(taint(), "value");
    MultivaluedHashMap<String, String> mhm1 = new MultivaluedHashMap<String, String>(map1);
    sink(mhm1.keySet().iterator().next()); // $ hasValueFlow

    map2.put("key", taint());
    MultivaluedHashMap<String, String> mhm2 = new MultivaluedHashMap<String, String>(map2);
    sink(mhm2.get("key").get(0)); // $ hasValueFlow

    mm1.add(taint(), "value");
    MultivaluedHashMap<String, String> mhm3 = new MultivaluedHashMap<String, String>(mm1);
    sink(mhm3.keySet().iterator().next()); // $ hasValueFlow

    mm2.add("key", taint());
    MultivaluedHashMap<String, String> mhm4 = new MultivaluedHashMap<String, String>(mm2);
    sink(mhm4.get("key").get(0)); // $ hasValueFlow
  }

  void testPathSegment(PathSegment ps1, PathSegment ps2) {
    sink(taint(ps1).getMatrixParameters()); // $ hasTaintFlow
    sink(taint(ps2).getPath()); // $ hasTaintFlow
  }

  void testUriInfo(UriInfo ui, UriInfo untaintedUriInfo) throws Exception {
    ui = taint(ui);
    sink(ui.getPathParameters()); // $ hasTaintFlow
    sink(ui.getPathSegments()); // $ hasTaintFlow
    sink(ui.getQueryParameters()); // $ hasTaintFlow
    sink(ui.getRequestUri()); // $ hasTaintFlow
    sink(ui.getRequestUriBuilder()); // $ hasTaintFlow
    sink(ui.getQueryParameters().getFirst("someKey")); // $ hasTaintFlow
    sink(ui.getRequestUri()); // $ hasTaintFlow
    sink(ui.getRequestUriBuilder().build()); // $ hasTaintFlow
    URI taintedUri = UriSource.taint();
    URI untaintedUri = new URI("");
    sink(untaintedUriInfo.relativize(taintedUri)); // $ hasTaintFlow
    sink(untaintedUriInfo.resolve(taintedUri)); // $ hasTaintFlow
    sink(ui.resolve(untaintedUri)); // $ hasTaintFlow
  }

  void testCookie() {
    sink(new Cookie(taint(), "", "", "", 0)); // $ hasTaintFlow
    sink(new Cookie("", taint(), "", "", 0)); // $ hasTaintFlow
    sink(new Cookie("", "", taint(), "", 0)); // $ hasTaintFlow
    sink(new Cookie("", "", "", taint(), 0)); // $ hasTaintFlow
    sink(new Cookie("", "", "", "", IntSource.taint())); // $ hasTaintFlow
    sink(new Cookie(taint(), "", "", "")); // $ hasTaintFlow
    sink(new Cookie("", taint(), "", "")); // $ hasTaintFlow
    sink(new Cookie("", "", taint(), "")); // $ hasTaintFlow
    sink(new Cookie("", "", "", taint())); // $ hasTaintFlow
    sink(new Cookie(taint(), "")); // $ hasTaintFlow
    sink(new Cookie("", taint())); // $ hasTaintFlow
    sink(Cookie.valueOf(taint())); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).getDomain()); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).getName()); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).getPath()); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).getValue()); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).getVersion()); // $ hasTaintFlow
    sink(Cookie.valueOf(taint()).toString()); // $ hasTaintFlow
  }

  void testNewCookie() {
    sink(new NewCookie(Cookie.valueOf(taint()))); // $ hasTaintFlow

    sink(new NewCookie(Cookie.valueOf(taint()), "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), taint(), 0, false)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", IntSource.taint(), true)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", 0, BooleanSource.taint())); // $ hasTaintFlow

    sink(new NewCookie(Cookie.valueOf(taint()), "", 0, new Date(), true, true)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), taint(), 0, new Date(), true, false)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", IntSource.taint(), new Date(), false, true)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", 0, DateSource.taint(), false, false)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", 0, new Date(), BooleanSource.taint(), false)); // $ hasTaintFlow
    sink(new NewCookie(Cookie.valueOf(""), "", 0, new Date(), true, BooleanSource.taint())); // $ hasTaintFlow

    sink(new NewCookie(taint(), "")); // $ hasTaintFlow
    sink(new NewCookie("", taint())); // $ hasTaintFlow

    sink(new NewCookie(taint(), "", "", "", 0, "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie("", taint(), "", "", 0, "", 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", taint(), "", 0, "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", taint(), 0, "", 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", IntSource.taint(), "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, taint(), 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", IntSource.taint(), true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", 0, BooleanSource.taint())); // $ hasTaintFlow

    sink(new NewCookie(taint(), "", "", "", 0, "", 0, new Date(), true, true)); // $ hasTaintFlow
    sink(new NewCookie("", taint(), "", "", 0, "", 0, new Date(), false, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", taint(), "", 0, "", 0, new Date(), true, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", taint(), 0, "", 0, new Date(), false, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", IntSource.taint(), "", 0, new Date(), true, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, taint(), 0, new Date(), true, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", IntSource.taint(), new Date(), false, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", 0, DateSource.taint(), false, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", 0, new Date(), BooleanSource.taint(), true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", 0, "", 0, new Date(), false, BooleanSource.taint())); // $ hasTaintFlow

    sink(new NewCookie(taint(), "", "", "", "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie("", taint(), "", "", "", 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", taint(), "", "", 0, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", taint(), "", 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", taint(), 0, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", "", IntSource.taint(), true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", "", 0, BooleanSource.taint())); // $ hasTaintFlow

    sink(new NewCookie(taint(), "", "", "", "", 0, true, true)); // $ hasTaintFlow
    sink(new NewCookie("", taint(), "", "", "", 0, false, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", taint(), "", "", 0, true, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", taint(), "", 0, false, false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", taint(), 0, true, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", "", IntSource.taint(), false, true)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", "", 0, BooleanSource.taint(), false)); // $ hasTaintFlow
    sink(new NewCookie("", "", "", "", "", 0, true, BooleanSource.taint())); // $ hasTaintFlow

    sink(NewCookie.valueOf(taint()).getComment()); // $ hasTaintFlow
    sink(NewCookie.valueOf(taint()).getExpiry()); // $ hasTaintFlow
    sink(NewCookie.valueOf(taint()).getMaxAge()); // $ hasTaintFlow
    sink(NewCookie.valueOf(taint()).toCookie()); // $ hasTaintFlow
    sink(NewCookie.valueOf(taint())); // $ hasTaintFlow
  }

  void testForm(MultivaluedMap<String, String> mm1, MultivaluedMap<String, String> mm2) {
    sink(new Form(taint(), "")); // $ hasTaintFlow
    sink(new Form("", taint())); // $ hasTaintFlow
    mm1.add(taint(), "value");
    sink(new Form(mm1)); // $ hasTaintFlow
    mm2.add("key", taint());
    sink(new Form(mm2)); // $ hasTaintFlow
    Form f1 = new Form(taint(), "");
    sink(f1.asMap()); // $ hasTaintFlow
    Form f2 = new Form();
    sink(f2.param(taint(), "b")); // $ hasTaintFlow
    Form f3 = new Form();
    sink(f3.param("a", taint())); // $ hasTaintFlow
    Form f4 = new Form(taint(), "");
    sink(f4.param("a", "b")); // $ hasTaintFlow
  }

  void testGenericEntity() {
    Method m = DummyJakarta.class.getMethods()[0];
    GenericEntity<Set<String>> ge = new GenericEntity<Set<String>>(SetStringSource.taint(), m.getGenericReturnType());
    sink(ge); // $ hasTaintFlow
    sink(ge.getEntity()); // $ hasTaintFlow
  }

  void testMediaType(Map<String, String> m) {
    sink(new MediaType(taint(), "")); // $ hasTaintFlow
    sink(new MediaType("", taint())); // $ hasTaintFlow
    sink(new MediaType(taint(), "", m)); // $ hasTaintFlow
    sink(new MediaType("", taint(), m)); // $ hasTaintFlow
    sink(new MediaType("", "", taint(m))); // $ hasTaintFlow
    sink(new MediaType(taint(), "", "")); // $ hasTaintFlow
    sink(new MediaType("", taint(), "")); // $ hasTaintFlow
    sink(new MediaType("", "", taint())); // $ hasTaintFlow
    sink(MediaType.valueOf(taint()).getParameters()); // $ hasTaintFlow
    sink(MediaType.valueOf(taint()).getSubtype()); // $ hasTaintFlow
    sink(MediaType.valueOf(taint()).getType()); // $ hasTaintFlow
    sink(MediaType.valueOf(taint())); // $ hasTaintFlow
  }

  void testUriBuilder() throws Exception {
    sink(UriBuilder.fromPath("").build(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").build("", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").build(taint(), false)); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").build("", taint(), true)); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).build("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).build("", false)); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").buildFromEncoded(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").buildFromEncoded("", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).buildFromEncoded("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").buildFromEncodedMap(taint(new HashMap<String, String>()))); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).buildFromEncodedMap(new HashMap<String, String>())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").buildFromMap(taint(new HashMap<String, String>()), false)); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).buildFromMap(new HashMap<String, String>(), true)); // $ hasTaintFlow

    sink(UriBuilder.fromPath(taint()).clone()); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").fragment(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).fragment("")); // $ hasTaintFlow
    sink(UriBuilder.fromLink(taint(Link.valueOf("")))); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromUri(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").host(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).host("")); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").matrixParam(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").matrixParam("", "", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).matrixParam("", "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").path(taint(DummyJakarta.class))); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").path(DummyJakarta.class, taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).path(DummyJakarta.class)); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").queryParam(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").queryParam("", "", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).queryParam("", "")); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").replaceMatrix(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).replaceMatrix("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replaceMatrixParam(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replaceMatrixParam("", "", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).replaceMatrixParam("", "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replacePath(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).replacePath("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replaceQuery(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).replaceQuery("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replaceQueryParam(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").replaceQueryParam("", "", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).replaceQueryParam("", "")); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").resolveTemplate(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplate(taint(), "", false)); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplate("", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplate("", taint(), true)); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplate("", "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplate("", "", false)); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplateFromEncoded(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplateFromEncoded("", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplateFromEncoded("", "")); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").resolveTemplates(taint(new HashMap<String, Object>()))); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplates(taint(new HashMap<String, Object>()), true)); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplates(new HashMap<String, Object>())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplates(new HashMap<String, Object>(), false)); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").resolveTemplatesFromEncoded(taint(new HashMap<String, Object>()))); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).resolveTemplatesFromEncoded(new HashMap<String, Object>())); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").scheme(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).scheme("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").schemeSpecificPart(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).schemeSpecificPart("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").segment(taint(), "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").segment("", "", taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).segment("", "")); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).toTemplate()); // $ hasTaintFlow

    sink(UriBuilder.fromPath("").uri(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).uri("")); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").uri(UriSource.taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).uri(new URI(""))); // $ hasTaintFlow
    sink(UriBuilder.fromPath("").userInfo(taint())); // $ hasTaintFlow
    sink(UriBuilder.fromPath(taint()).userInfo("")); // $ hasTaintFlow
  }
}

class DummyJakarta {
  private static Set<String> foo() { return null; }
}
