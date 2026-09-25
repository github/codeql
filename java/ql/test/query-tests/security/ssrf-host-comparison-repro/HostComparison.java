import java.net.URI;
import java.util.Arrays;
import javax.servlet.http.HttpServletRequest;

public class HostComparison {
    public void unguarded(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        uri.toURL().openConnection(); // $ Alert
    }

    public void directEquals(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if ("example.com".equals(uri.getHost())) {
            uri.toURL().openConnection();
        }
    }

    public void directEqualsIgnoreCase(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if ("example.com".equalsIgnoreCase(uri.getHost())) {
            uri.toURL().openConnection();
        }
    }

    public void reversedEqualsIgnoreCase(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        if (uri.getHost().equalsIgnoreCase("example.com")) {
            uri.toURL().openConnection();
        }
    }

    public void localEquals(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if ("example.com".equals(host)) {
            uri.toURL().openConnection();
        }
    }

    public void localEqualsIgnoreCase(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if ("example.com".equalsIgnoreCase(host)) {
            uri.toURL().openConnection();
        }
    }

    public void streamEquals(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (Arrays.stream(new String[]{"example.com"}).anyMatch(uri.getHost()::equals)) {
            uri.toURL().openConnection(); // $ SPURIOUS: Alert
        }
    }

    public void reportedStreamHelper(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (isAllowedStream(uri.getHost(), "example.com")) {
            uri.toURL().openConnection(); // $ SPURIOUS: Alert
        }
    }

    private static boolean isAllowedStream(String host, String... allowedHosts) {
        return Arrays.stream(allowedHosts).anyMatch(host::equalsIgnoreCase);
    }

    public void reportedLoopHelper(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ SPURIOUS: Source
        if (isAllowedLoop(uri.getHost(), "example.com")) {
            uri.toURL().openConnection(); // $ SPURIOUS: Alert
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

    public void wrongBranch(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (!"example.com".equals(uri.getHost())) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void differentUri(HttpServletRequest request) throws Exception {
        URI checked = new URI(request.getParameter("checked"));
        URI used = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equals(checked.getHost())) {
            used.toURL().openConnection(); // $ Alert
        }
    }

    public void constantUrl() throws Exception {
        new URI("https://example.com/").toURL().openConnection();
    }

    public void caseInsensitiveWrongBranch(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (!"example.com".equalsIgnoreCase(uri.getHost())) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void caseInsensitiveDifferentUri(HttpServletRequest request) throws Exception {
        URI checked = new URI(request.getParameter("checked"));
        URI used = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equalsIgnoreCase(checked.getHost())) {
            used.toURL().openConnection(); // $ Alert
        }
    }

    public void reassignedHost(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        host = "example.com";
        if ("example.com".equalsIgnoreCase(host)) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void conditionallyReassignedHost(HttpServletRequest request, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        if (skip) {
            host = "example.com";
        }
        if ("example.com".equalsIgnoreCase(host)) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void reassignedUri(HttpServletRequest request) throws Exception {
        URI uri = new URI("https://example.com/");
        String host = uri.getHost();
        uri = new URI(request.getParameter("url")); // $ Source
        if ("example.com".equalsIgnoreCase(host)) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void untrustedComparison(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (request.getParameter("allowed").equalsIgnoreCase(uri.getHost())) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void unrelatedComparison(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        if (new FakeComparison().equalsIgnoreCase(uri.getHost())) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    private static class FakeComparison {
        boolean equalsIgnoreCase(String host) {
            return true;
        }
    }

    public void aliasChain(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        String alias = host;
        String secondAlias = alias;
        if ("example.com".equalsIgnoreCase(secondAlias)) {
            uri.toURL().openConnection();
        }
    }

    public void finallyOverwrite(HttpServletRequest request, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        try {
            if (skip) return;
            host = "example.com";
        } finally {
            if ("example.com".equalsIgnoreCase(host)) {
                uri.toURL().openConnection(); // $ Alert
            }
        }
    }

    public void rejectionReturns(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if (!"example.com".equalsIgnoreCase(host)) return;
        uri.toURL().openConnection();
    }

    private static final String ALLOWED_HOST = "example.com";

    public void constantAllowlistField(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        String host = uri.getHost();
        if (ALLOWED_HOST.equalsIgnoreCase(host)) {
            uri.toURL().openConnection();
        }
    }

    public void orBypass(HttpServletRequest request, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        String host = uri.getHost();
        if ("example.com".equalsIgnoreCase(host) || skip) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void assignmentCast(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        Object value = uri.getHost();
        String host = (String) value;
        if ("example.com".equalsIgnoreCase(host)) {
            uri.toURL().openConnection();
        }
    }

    public void comparisonCast(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url"));
        Object host = uri.getHost();
        if ("example.com".equalsIgnoreCase((String) host)) {
            uri.toURL().openConnection();
        }
    }

    public void castHostOverwrite(HttpServletRequest request) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        Object host = uri.getHost();
        host = "example.com";
        if ("example.com".equalsIgnoreCase((String) host)) {
            uri.toURL().openConnection(); // $ Alert
        }
    }

    public void castHostConditionalOverwrite(HttpServletRequest request, boolean skip) throws Exception {
        URI uri = new URI(request.getParameter("url")); // $ Source
        Object host = uri.getHost();
        if (skip) host = "example.com";
        if ("example.com".equalsIgnoreCase((String) host)) {
            uri.toURL().openConnection(); // $ Alert
        }
    }
}
