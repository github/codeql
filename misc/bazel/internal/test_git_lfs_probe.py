import contextlib
import http.client
import io
import json
import os
import pathlib
import runpy
import ssl
import subprocess
import tempfile
import unittest
import urllib.error
from unittest import mock


SCRIPT = pathlib.Path(__file__).with_name("git_lfs_probe.py")
ENDPOINT = "https://lfs.example.test/repo/info/lfs"
BACKUP = "https://backup.example.test/repo/info/lfs"
OID = "a" * 64
DOWNLOAD = "https://downloads.example.test/content?signature=test-signature"


def response():
    return io.BytesIO(json.dumps({
        "objects": [{"oid": OID, "actions": {"download": {"href": DOWNLOAD}}}],
    }).encode())


def truncated_response():
    sock = mock.Mock()
    sock.makefile.return_value = io.BytesIO(
        b'HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\n{"objects": ['
    )
    resp = http.client.HTTPResponse(sock)
    resp.begin()
    return resp


def http_error(code, retry_after=None):
    headers = {} if retry_after is None else {"Retry-After": retry_after}
    return urllib.error.HTTPError(
        ENDPOINT + "/objects/batch", code, "test-secret", headers, io.BytesIO()
    )


class BatchRequestTest(unittest.TestCase):
    def setUp(self):
        self.stack = contextlib.ExitStack()
        self.addCleanup(self.stack.close)
        root = pathlib.Path(self.stack.enter_context(tempfile.TemporaryDirectory()))
        pointer = root / "pointer"
        pointer.write_text(
            "version https://git-lfs.github.com/spec/v1\n"
            f"oid sha256:{OID}\nsize 42\n"
        )
        local = root / "local"
        local.write_text("not an LFS pointer\n")
        self.stack.enter_context(mock.patch("sys.argv", [str(SCRIPT), str(local), str(pointer)]))
        self.stack.enter_context(mock.patch.dict(os.environ, {"GITHUB_TOKEN": ""}))
        self.stack.enter_context(mock.patch(
            "subprocess.check_output",
            side_effect=[
                str(root),
                f"Endpoint={ENDPOINT} (auth=none)\nEndpoint (backup)={BACKUP} (auth=none)\n",
            ],
        ))
        self.stack.enter_context(mock.patch(
            "subprocess.run",
            return_value=subprocess.CompletedProcess(
                [], 0, stdout="Authorization: Basic test-secret"
            ),
        ))
        self.urlopen = self.stack.enter_context(mock.patch("urllib.request.urlopen"))
        self.sleep = self.stack.enter_context(mock.patch("time.sleep"))
        self.stack.enter_context(mock.patch("time.time", return_value=1445412480))
        self.stdout = self.stack.enter_context(contextlib.redirect_stdout(io.StringIO()))
        self.stderr = self.stack.enter_context(contextlib.redirect_stderr(io.StringIO()))

    def run_probe(self, outcomes):
        self.urlopen.side_effect = outcomes
        runpy.run_path(str(SCRIPT), run_name="__main__")

    def assert_requests(self, endpoints):
        self.assertEqual(self.urlopen.call_count, len(endpoints))
        for call, endpoint in zip(self.urlopen.call_args_list, endpoints):
            request = call.args[0]
            self.assertEqual(request.full_url, endpoint + "/objects/batch")
            self.assertEqual(request.get_method(), "POST")
            self.assertEqual(request.get_header("Authorization"), "Basic test-secret")
            self.assertEqual(request.get_header("Content-type"), "application/vnd.git-lfs+json")
            self.assertEqual(json.loads(request.data), {
                "operation": "download",
                "transfers": ["basic"],
                "objects": [{"oid": OID, "size": 42}],
                "hash_algo": "sha256",
            })
        self.assertNotIn("test-secret", self.stderr.getvalue())
        self.assertNotIn("test-signature", self.stderr.getvalue())

    def test_disconnect_and_read_timeout_retry_same_request(self):
        partial_response = mock.MagicMock()
        partial_response.__enter__.return_value = partial_response
        partial_response.read.side_effect = TimeoutError("test-secret")
        self.run_probe([
            http.client.RemoteDisconnected("test-secret"),
            partial_response,
            response(),
        ])
        self.assert_requests([ENDPOINT] * 3)
        self.assertEqual(self.sleep.call_args_list, [mock.call(1), mock.call(2)])
        partial_response.__exit__.assert_called_once()
        self.assertEqual(self.stdout.getvalue(), f"local\n{OID} {DOWNLOAD}\n")

    def test_truncated_body_retries_same_request(self):
        self.run_probe([truncated_response(), response()])
        self.assert_requests([ENDPOINT] * 2)
        self.sleep.assert_called_once_with(1)
        self.assertEqual(self.stdout.getvalue(), f"local\n{OID} {DOWNLOAD}\n")

    def test_wrapped_timeout_retries_before_fallback(self):
        self.run_probe([
            urllib.error.URLError(TimeoutError("test-secret")),
            response(),
        ])
        self.assert_requests([ENDPOINT] * 2)
        self.sleep.assert_called_once_with(1)

    def test_rate_limit_retry_after(self):
        cases = [
            ("7", 7),
            ("30", 30),
            ("Wed, 21 Oct 2015 07:28:09 GMT", 9),
            ("Wed, 21 Oct 2015 07:27:00 GMT", 1),
            ("invalid", 1),
            (None, 1),
        ]
        for header, delay in cases:
            with self.subTest(header=header):
                self.urlopen.reset_mock()
                self.sleep.reset_mock()
                with mock.patch("subprocess.check_output", side_effect=[
                    str(SCRIPT.parent),
                    f"Endpoint={ENDPOINT} (auth=none)\n",
                ]):
                    error = http_error(429, header)
                    body = error.fp
                    self.run_probe([error, response()])
                self.assert_requests([ENDPOINT] * 2)
                self.sleep.assert_called_once_with(delay)
                self.assertTrue(body.closed)

    def test_long_retry_after_skips_endpoint_without_sleeping(self):
        self.run_probe([http_error(429, "31"), response()])
        self.assert_requests([ENDPOINT, BACKUP])
        self.sleep.assert_not_called()
        self.assertIn("429", self.stderr.getvalue())

    def test_transient_errors_exhaust_then_fall_back(self):
        for failures in [
            [http_error(503), http_error(502), http_error(504)],
            [truncated_response() for _ in range(3)],
        ]:
            with self.subTest(response_type=type(failures[0]).__name__):
                self.urlopen.reset_mock()
                self.sleep.reset_mock()
                with mock.patch("subprocess.check_output", side_effect=[
                    str(SCRIPT.parent),
                    f"Endpoint={ENDPOINT} (auth=none)\nEndpoint (backup)={BACKUP} (auth=none)\n",
                ]):
                    self.run_probe(failures + [response()])
                self.assert_requests([ENDPOINT] * 3 + [BACKUP])
                self.assertEqual(self.sleep.call_args_list, [mock.call(1), mock.call(2)])

    def test_all_endpoints_exhausted_reports_failure(self):
        with self.assertRaises(SystemExit) as raised:
            self.run_probe([TimeoutError("test-secret") for _ in range(6)])
        self.assertEqual(raised.exception.code, 1)
        self.assert_requests([ENDPOINT] * 3 + [BACKUP] * 3)
        self.assertEqual(
            self.sleep.call_args_list,
            [mock.call(1), mock.call(2), mock.call(1), mock.call(2)],
        )
        self.assertIn("ERROR: no valid endpoints found", self.stderr.getvalue())
        self.assertEqual(self.stdout.getvalue(), "")

    def test_permanent_errors_are_not_retried(self):
        with self.assertRaises(SystemExit) as raised:
            self.run_probe([
                http_error(403),
                urllib.error.URLError(ssl.SSLCertVerificationError("test-secret")),
            ])
        self.assertEqual(raised.exception.code, 1)
        self.assert_requests([ENDPOINT, BACKUP])
        self.sleep.assert_not_called()
        self.assertIn("403", self.stderr.getvalue())
        self.assertIn("SSLCertVerificationError", self.stderr.getvalue())

    def test_malformed_response_fallback_preserves_batch_payload(self):
        malformed = io.BytesIO(json.dumps({
            "objects": [{"oid": OID, "actions": {"upload": {"href": DOWNLOAD}}}],
        }).encode())
        self.run_probe([malformed, response()])
        self.assert_requests([ENDPOINT, BACKUP])
        self.sleep.assert_not_called()
        self.assertEqual(self.stdout.getvalue(), f"local\n{OID} {DOWNLOAD}\n")


if __name__ == "__main__":
    unittest.main()
