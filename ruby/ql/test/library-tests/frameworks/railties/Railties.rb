class Foo
  include Rails::Generators::Actions

  def foo
    execute_command(:rake, "test")
    execute_command(:rails, "server")

    rake("test")

    rails_command("server")

    git("status")
  end
end
