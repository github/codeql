import? '../semmle-code.just'  # internal repo just file, if present

set fallback
set allow-duplicate-recipes
set unstable

error := style("error") + "error" + NORMAL + ":"

[no-exit-message]
@_require_semmle_code WHAT:
    if [ -z "${SEMMLE_CODE:-}" ]; then \
        echo "{{ error }} running {{ WHAT }} requires running from an internal repository checkout" >&2; \
        exit 1; \
    fi
