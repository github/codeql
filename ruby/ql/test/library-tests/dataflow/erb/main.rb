class App
    def run1
        x = source(1)
        view = View1.new(x)
        render(view)
    end

    def run2
        view = View2.new
        render(view)
        view.foo
    end

    def run3
        x = source(4)
        view = View3.new(x)
        render(view)
    end

    def run4
        x = source(5)
        view = View4.new(x)
        render(view)
    end
end

class ViewComponent::Base
end
