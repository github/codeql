import java.net.URI;
import java.util.Arrays;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HostComparisonRedirect {
    public void unguarded(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        response.sendRedirect(uri.toString()); // $ Alert
    }

    public void directEquals(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if ("example.com".equals(uri.getHost())) {
            response.sendRedirect(uri.toString());
        }
    }

    public void directEqualsIgnoreCase(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if ("example.com".equalsIgnoreCase(uri.getHost())) {
            response.sendRedirect(uri.toString());
        }
    }

    public void reversedEqualsIgnoreCase(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if (uri.getHost().equalsIgnoreCase("example.com")) {
            response.sendRedirect(uri.toString());
        }
    }

    public void localEquals(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if ("example.com".equals(host)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void localEqualsIgnoreCase(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if ("example.com".equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void streamEquals(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (Arrays.stream(new String[]{"example.com"}).anyMatch(uri.getHost()::equals)) {
            response.sendRedirect(uri.toString()); // $ SPURIOUS: Alert
        }
    }

    public void reportedStreamHelper(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (isAllowedStream(uri.getHost(), "example.com")) {
            response.sendRedirect(uri.toString()); // $ SPURIOUS: Alert
        }
    }

    private static boolean isAllowedStream(String host, String... allowedHosts) {
        return Arrays.stream(allowedHosts).anyMatch(host::equalsIgnoreCase);
    }

    public void reportedLoopHelper(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (isAllowedLoop(uri.getHost(), "example.com")) {
            response.sendRedirect(uri.toString()); // $ SPURIOUS: Alert
        }
    }

    private static boolean isAllowedLoop(String host, String... allowedHosts) {
        for (String allowed : allowedHosts) {
            if (allowed.equalsIgnoreCase(host)) {
                return true;
            }
        }
        return false;
    }

    public void wrongBranch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (!"example.com".equals(uri.getHost())) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void differentUri(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI checked = new URI(request.getParameter("checked"));
        URI used = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equals(checked.getHost())) {
            response.sendRedirect(used.toString()); // $ Alert
        }
    }

    public void constantUrl(HttpServletResponse response) throws Exception {
        response.sendRedirect("https://example.com/");
    }

    public void caseInsensitiveWrongBranch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (!"example.com".equalsIgnoreCase(uri.getHost())) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void caseInsensitiveDifferentUri(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI checked = new URI(request.getParameter("checked"));
        URI used = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equalsIgnoreCase(checked.getHost())) {
            response.sendRedirect(used.toString()); // $ Alert
        }
    }

    public void reassignedHost(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        host = "example.com";
        if ("example.com".equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void conditionallyReassignedHost(HttpServletRequest request, HttpServletResponse response, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        if (skip) {
            host = "example.com";
        }
        if ("example.com".equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void reassignedUri(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI("https://example.com/");
        String host = uri.getHost();
        uri = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void untrustedComparison(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (request.getParameter("allowed").equalsIgnoreCase(uri.getHost())) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void unrelatedComparison(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (new FakeComparison().equalsIgnoreCase(uri.getHost())) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    private static class FakeComparison {
        boolean equalsIgnoreCase(String host) {
            return true;
        }
    }

    public void aliasChain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        String alias = host;
        String secondAlias = alias;
        if ("example.com".equalsIgnoreCase(secondAlias)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void finallyOverwrite(HttpServletRequest request, HttpServletResponse response, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        try {
            if (skip) return;
            host = "example.com";
        } finally {
            if ("example.com".equalsIgnoreCase(host)) {
                response.sendRedirect(uri.toString()); // $ Alert
            }
        }
    }

    public void rejectionReturns(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if (!"example.com".equalsIgnoreCase(host)) return;
        response.sendRedirect(uri.toString());
    }

    private static final String ALLOWED_HOST = "example.com";

    public void constantAllowlistField(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if (ALLOWED_HOST.equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void orBypass(HttpServletRequest request, HttpServletResponse response, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        if ("example.com".equalsIgnoreCase(host) || skip) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void assignmentCast(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        Object value = uri.getHost();
        String host = (String) value;
        if ("example.com".equalsIgnoreCase(host)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void comparisonCast(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        Object host = uri.getHost();
        if ("example.com".equalsIgnoreCase((String) host)) {
            response.sendRedirect(uri.toString());
        }
    }

    public void castHostOverwrite(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        Object host = uri.getHost();
        host = "example.com";
        if ("example.com".equalsIgnoreCase((String) host)) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }

    public void castHostConditionalOverwrite(HttpServletRequest request, HttpServletResponse response, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        Object host = uri.getHost();
        if (skip) host = "example.com";
        if ("example.com".equalsIgnoreCase((String) host)) {
            response.sendRedirect(uri.toString()); // $ Alert
        }
    }
}
