require 'rails'

module App
  class Application < Rails::Application
    config.load_defaults 6.0

    # GOOD: strong cipher
    config.action_dispatch.encrypted_cookie_cipher = "aes-256-gcm"

    # GOOD: strong cipher
    config.action_dispatch.encrypted_cookie_cipher = "ChaCha"

    # BAD: weak block encryption algorithm
    config.action_dispatch.encrypted_cookie_cipher = "DES"

    # BAD: weak block encryption mode
    config.action_dispatch.encrypted_cookie_cipher = "AES-256-ECB"

    # GOOD
    config.action_dispatch.use_authenticated_cookie_encryption = true

    # BAD: less secure block encryption mode
    config.action_dispatch.use_authenticated_cookie_encryption = false

    # GOOD
    config.action_dispatch.cookies_same_site_protection = :lax

    # GOOD
    config.action_dispatch.cookies_same_site_protection = "strict"

    # BAD: disabling same-site protections for sending cookies
    config.action_dispatch.cookies_same_site_protection = :none

    # BAD: not all browsers default to `lax` if unset
    config.action_dispatch.cookies_same_site_protection = nil
  end
end
