module Foo
    def foo_before
    end

    FOO_CONSTANT ||= 123

    def foo_after
    end
end

def top_before
end

TOP_CONSTANT ||= 123

def top_after
end

::TOP_CONSTANT2 ||= 123

def top_after2
end
