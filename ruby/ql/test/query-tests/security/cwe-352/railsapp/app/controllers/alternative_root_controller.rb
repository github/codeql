class AlternativeRootController < ActionController::Base
    # BAD: no protect_from_forgery call
end # $ Alert[rb/csrf-protection-not-enabled]
