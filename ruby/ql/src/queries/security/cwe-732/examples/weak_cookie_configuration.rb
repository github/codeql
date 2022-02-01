module App
  class Application < Rails::Application
    # Sets default `Set-Cookie` `SameSite` attribute to `None`
    config.action_dispatch.cookies_same_site_protection = :none

    # Sets default `Set-Cookie` `SameSite` attribute to `Strict`
    config.action_dispatch.cookies_same_site_protection = :strict
  end
end
