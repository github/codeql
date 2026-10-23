from flask import Flask, request, redirect # $ Source

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    return redirect(target, code=302) # $ Alert


# Check for safe prefixes

@app.route('/ok')
def ok():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/"
    safe += untrusted
    return redirect(safe, code=302)


@app.route('/ok2')
def ok2():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/" + untrusted
    return redirect(safe, code=302)


@app.route('/ok3')
def ok3():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/{}".format(untrusted)
    return redirect(safe, code=302) # $ SPURIOUS: Alert # FP


@app.route('/ok4')
def ok4():
    untrusted = request.args.get('target', '')
    safe = f"https://safe.com/{untrusted}"
    return redirect(safe, code=302) # $ SPURIOUS: Alert # FP


@app.route('/ok5')
def ok5():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/%s" % untrusted
    return redirect(safe, code=302) # $ SPURIOUS: Alert # FP


@app.route('/const-str-compare')
def const_str_compare():
    target = request.args.get('target', '')
    if target == "example.com/":
        return redirect(target, code=302)


# Check that our sanitizer is not too broad

@app.route('/not_ok1')
def not_ok1():
    untrusted = request.args.get('target', '')
    unsafe = untrusted + "?login=success"
    return redirect(unsafe, code=302) # $ Alert


@app.route('/not_ok2')
def not_ok2():
    untrusted = request.args.get('target', '')
    unsafe = "{}?login=success".format(untrusted)
    return redirect(unsafe, code=302) # $ Alert


@app.route('/not_ok3')
def not_ok3():
    untrusted = request.args.get('target', '')
    unsafe = f"{untrusted}?login=success"
    return redirect(unsafe, code=302) # $ Alert


@app.route('/not_ok4')
def not_ok4():
    untrusted = request.args.get('target', '')
    unsafe = "%s?login=success" % untrusted
    return redirect(unsafe, code=302) # $ Alert

from django.utils.http import url_has_allowed_host_and_scheme
import math

@app.route('/ok6')
def ok6():
    untrusted = request.args.get('target', '')
    # random chance.
    if math.random() > 0.5:
        redirect(untrusted, code=302) # $ Alert # NOT OK
    if url_has_allowed_host_and_scheme(untrusted, allowed_hosts=None):
        return redirect(untrusted, code=302) # OK

    return redirect("https://example.com", code=302) # OK

import yarl

@app.route('/ok7')
def ok7():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if not yarl.URL(untrusted).is_absolute():
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)

@app.route('/not_ok5')
def not_ok5():
    untrusted = request.args.get('target', '')
    # no backslash replace
    if not yarl.URL(untrusted).is_absolute():
        return redirect(untrusted, code=302) # $ Alert # NOT OK
    return redirect("/", code=302)

from urllib.parse import urlparse

@app.route('/not_ok8')
def not_ok8():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if not urlparse(untrusted).netloc:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)

@app.route('/not_ok9')
def not_ok9():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc == "":
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)

@app.route('/not_ok6')
def not_ok6():
    untrusted = request.args.get('target', '')
    # no backslash replace
    if not urlparse(untrusted).netloc:
        return redirect(untrusted, code=302) # $ Alert # NOT OK
    return redirect("/", code=302)

@app.route('/not_ok7')
def not_ok7():
    untrusted = request.args.get('target', '')
    # wrong check
    if urlparse(untrusted).netloc != "":
        return redirect(untrusted, code=302) # $ Alert # NOT OK
    return redirect("/", code=302)

@app.route('/not_ok10')
def not_ok10():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc in ["", request.host]:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)

@app.route('/not_ok11')
def not_ok11():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc not in ["", request.host]:
        return redirect("/", code=302) # OK
    return redirect(untrusted, code=302) # $ Alert


@app.route('/checked_relative_url')
def checked_relative_url():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


from urllib.parse import urlsplit

@app.route('/checked_lstripped_relative_url')
def checked_lstripped_relative_url():
    untrusted = request.args.get('target', '').replace("\\", "/").lstrip()
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/checked_relative_url_comparisons')
def checked_relative_url_comparisons():
    untrusted = request.args.get('target', '').replace("\\", "").strip()
    parsed = urlparse(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("//")
        and parsed.scheme == ""
        and parsed.netloc == ""
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/checked_relative_url_early_return')
def checked_relative_url_early_return():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlparse(untrusted)
    if (
        not untrusted.isprintable()
        or untrusted.startswith("///")
        or parsed.scheme != ""
        or parsed.netloc not in ["", request.host]
    ):
        return redirect("/", code=302) # OK
    return redirect(untrusted, code=302) # OK


@app.route('/checked_split_url')
def checked_split_url():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlsplit(url=untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in ["", request.host]
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/checked_tuple_startswith')
def checked_tuple_startswith():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlparse(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith(("///", "\\"))
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/named_empty_scheme')
def named_empty_scheme():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    empty_scheme = ""
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and urlparse(untrusted).scheme == empty_scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/checked_named_host_collections')
def checked_named_host_collections():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    kind = request.args.get('kind')
    if kind == "list":
        allowed_hosts = ["", request.host]
    elif kind == "tuple":
        allowed_hosts = ("", request.host)
    elif kind == "set":
        allowed_hosts = {"", request.host}
    else:
        allowed_hosts = {"": True, request.host: True}
    hosts = allowed_hosts
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in hosts
    ):
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/missing_backslash_check')
def missing_backslash_check():
    untrusted = request.args.get('target', '').strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/printable_without_strip')
def printable_without_strip():
    untrusted = request.args.get('target', '').replace("\\", "/")
    parsed = urlparse(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/strip_before_backslash_replace')
def strip_before_backslash_replace():
    untrusted = request.args.get('target', '').strip().replace("\\", "")
    parsed = urlparse(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/custom_strip_characters')
def custom_strip_characters():
    untrusted = request.args.get('target', '').replace("\\", "/").strip(" ")
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/stripped_without_printable_check')
def stripped_without_printable_check():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlparse(untrusted)
    if (
        not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/printable_check_on_other_url')
def printable_check_on_other_url():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    other = request.args.get('other', '').replace("\\", "/").strip()
    parsed = urlparse(untrusted)
    if (
        other.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and not parsed.netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/missing_slash_check')
def missing_slash_check():
    untrusted = request.args.get('target', '').replace("\\", "").strip()
    if (
        untrusted.isprintable()
        and not urlparse(untrusted).netloc
        and not urlparse(untrusted).scheme
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/unchecked_split_url_slashes')
def unchecked_split_url_slashes():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlsplit(untrusted)
    if untrusted.isprintable() and not parsed.scheme and not parsed.netloc:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/insufficient_slash_check')
def insufficient_slash_check():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("////")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/slash_check_with_offset')
def slash_check_with_offset():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///", 1)
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/wrong_slash_branch')
def wrong_slash_branch():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and untrusted.startswith("///")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/checks_on_different_urls')
def checks_on_different_urls():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    other = request.args.get('other', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not other.startswith("///")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/missing_scheme_check')
def missing_scheme_check():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/nonempty_scheme')
def nonempty_scheme():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and urlparse(untrusted).scheme == "https"
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/unknown_scheme')
def unknown_scheme():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    allowed_scheme = get_allowed_scheme()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and urlparse(untrusted).scheme == allowed_scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/conditionally_nonempty_scheme')
def conditionally_nonempty_scheme():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if request.args.get('allow-https'):
        allowed_scheme = "https"
    else:
        allowed_scheme = ""
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and urlparse(untrusted).scheme == allowed_scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/reversed_scheme_membership')
def reversed_scheme_membership():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and "" in urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/missing_netloc_check')
def missing_netloc_check():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not urlparse(untrusted).scheme
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/unchecked_branch')
def unchecked_branch():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not urlparse(untrusted).scheme
        and not urlparse(untrusted).netloc
    ):
        return redirect(untrusted, code=302) # OK
    return redirect(untrusted, code=302) # $ Alert


@app.route('/host_substring_membership')
def host_substring_membership():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlparse(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in "example.com"
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/named_host_substring_membership')
def named_host_substring_membership():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    allowed_hosts = "example.com"
    hosts = allowed_hosts
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in hosts
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/split_host_substring_membership_early_return')
def split_host_substring_membership_early_return():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    parsed = urlsplit(untrusted)
    if (
        not untrusted.isprintable()
        or untrusted.startswith("///")
        or parsed.scheme
        or parsed.netloc not in "example.com"
    ):
        return redirect("/", code=302)
    return redirect(untrusted, code=302) # $ Alert


@app.route('/named_host_substring_membership_early_return')
def named_host_substring_membership_early_return():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    allowed_hosts = "example.com"
    parsed = urlparse(untrusted)
    if (
        not untrusted.isprintable()
        or untrusted.startswith("///")
        or parsed.scheme
        or parsed.netloc not in allowed_hosts
    ):
        return redirect("/", code=302)
    return redirect(untrusted, code=302) # $ Alert


@app.route('/conditionally_string_host_list')
def conditionally_string_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    if request.args.get('use-list'):
        allowed_hosts = ["", request.host]
    else:
        allowed_hosts = "example.com"
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in allowed_hosts
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/unknown_host_list')
def unknown_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/").strip()
    allowed_hosts = get_allowed_hosts()
    parsed = urlsplit(untrusted)
    if (
        untrusted.isprintable()
        and not untrusted.startswith("///")
        and not parsed.scheme
        and parsed.netloc in allowed_hosts
    ):
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/checked_explicit_host')
def checked_explicit_host():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc == "example.com":
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/checked_explicit_host_list')
def checked_explicit_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc in ["example.com", "sub.example.com"]:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/named_nonempty_host_list')
def named_nonempty_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_hosts = ["example.com", "sub.example.com"]
    if urlparse(untrusted).netloc in allowed_hosts:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/host_list_with_named_nonempty_host')
def host_list_with_named_nonempty_host():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_host = "sub.example.com"
    if urlparse(untrusted).netloc in [allowed_host, "example.com"]:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/parsed_hostname')
def parsed_hostname():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_host = urlparse("https://example.com").hostname
    if urlparse(untrusted).netloc == allowed_host:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/split_hostname_list')
def split_hostname_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_host = urlsplit("https://example.com").hostname
    if urlparse(untrusted).netloc in [allowed_host, "sub.example.com"]:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)


@app.route('/named_empty_host')
def named_empty_host():
    untrusted = request.args.get('target', '').replace("\\", "/")
    empty_host = ""
    if urlparse(untrusted).netloc == empty_host:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/named_possibly_empty_host_list')
def named_possibly_empty_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_hosts = ["", "example.com"]
    if urlparse(untrusted).netloc in allowed_hosts:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/aliased_possibly_empty_host_list')
def aliased_possibly_empty_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    allowed_hosts = ["", "example.com"]
    hosts = allowed_hosts
    if urlparse(untrusted).netloc in hosts:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/conditionally_empty_host_list')
def conditionally_empty_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if request.args.get('allow-relative'):
        allowed_hosts = ["", "example.com"]
    else:
        allowed_hosts = ["example.com"]
    if urlparse(untrusted).netloc in allowed_hosts:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/host_list_with_named_empty_host')
def host_list_with_named_empty_host():
    untrusted = request.args.get('target', '').replace("\\", "/")
    empty_host = ""
    if urlparse(untrusted).netloc in [empty_host, "example.com"]:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/host_list_with_unknown_element')
def host_list_with_unknown_element():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc in [get_allowed_host(), "example.com"]:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/request_host_attribute')
def request_host_attribute():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc == request.host:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/request_host_list')
def request_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc in [request.host, "sub.example.com"]:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/arbitrary_attribute_host')
def arbitrary_attribute_host():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc == app.redirect_host:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)


@app.route('/arbitrary_attribute_host_list')
def arbitrary_attribute_host_list():
    untrusted = request.args.get('target', '').replace("\\", "/")
    if urlparse(untrusted).netloc in [app.redirect_host, "sub.example.com"]:
        return redirect(untrusted, code=302) # $ Alert
    return redirect("/", code=302)
