class App
    def run
        x = source(1)
        view = View.new(x)
        render(view)
    end
end