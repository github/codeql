UNSAFE_REGEX1 = /(www|beta).example.com\//
UNSAFE_REGEX2 = Regexp.compile("(www|beta).example.com/")
UNSAFE_REGEX3 = Regexp.new("(www|beta).example.com/")
SAFE_REGEX = /(www|beta)\.example\.com\//

def unsafe
    target = params[:target]
    if UNSAFE_REGEX1.match(target)
        redirect_to target
    end
end

def safe
    target = params[:target]
    if SAFE_REGEX.match(target)
        redirect_to target
    end
end

# FP reported in https://github.com/github/codeql/issues/3712
# This does not define a regex (but could be used by other code to do so)
escaped = Regexp::escape("https://www.humblebundle.com/home/library")
