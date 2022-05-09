"Foo::Bar".constantize

a.constantize

ActiveSupport::Logger.new(STDOUT)
ActiveSupport::TaggedLogging.new(STDOUT)

def m_camelize
    x = source "a"
    sink x.camelize # $hasTaintFlow=a
end

def m_camelcase
    x = source "a"
    sink x.camelcase # $hasTaintFlow=a
end

def m_classify
    x = source "a"
    sink x.classify # $hasTaintFlow=a
end

def m_dasherize
    x = source "a"
    sink x.dasherize # $hasTaintFlow=a
end

def m_deconstantize
    x = source "a"
    sink x.deconstantize # $hasTaintFlow=a
end

def m_demodulize
    x = source "a"
    sink x.demodulize # $hasTaintFlow=a
end

def m_foreign_key
    x = source "a"
    sink x.foreign_key # $hasTaintFlow=a
end

def m_humanize
    x = source "a"
    sink x.humanize # $hasTaintFlow=a
end

def m_indent
    x = source "a"
    sink x.indent(1) # $hasTaintFlow=a
end

def m_parameterize
    x = source "a"
    sink x.parameterize # $hasTaintFlow=a
end

def m_pluralize
    x = source "a"
    sink x.pluralize # $hasTaintFlow=a
end

def m_singularize
    x = source "a"
    sink x.singularize # $hasTaintFlow=a
end

def m_squish
    x = source "a"
    sink x.squish # $hasTaintFlow=a
end

def m_strip_heredoc
    x = source "a"
    sink x.strip_heredoc # $hasTaintFlow=a
end

def m_tableize
    x = source "a"
    sink x.tableize # $hasTaintFlow=a
end

def m_titlecase
    x = source "a"
    sink x.titlecase # $hasTaintFlow=a
end

def m_titleize
    x = source "a"
    sink x.titleize # $hasTaintFlow=a
end

def m_underscore
    x = source "a"
    sink x.underscore # $hasTaintFlow=a
end

def m_upcase_first
    x = source "a"
    sink x.upcase_first # $hasTaintFlow=a
end

def m_compact_blank
    x = [source 1]
    y = x.compact_blank
    sink y[0] # $hasValueFlow=1
end

def m_excluding
    x = [source(1), 2]
    y = x.excluding 2
    sink y[0] # $hasValueFlow=1
end

def m_without
    x = [source(1), 2]
    y = x.without 2
    sink y[0] # $hasValueFlow=1
end

def m_in_order_of
    x = [source(1), 2]
    y = x.in_order_of(:itself, [2,1])
    sink y[0] # $hasValueFlow=1
end

def m_including
    a = [source(1), 2]
    b = a.including(source(3), source(4))
    sink a[0] # $ hasValueFlow=1
    sink a[1]
    sink b[0] # $ hasValueFlow=1 $ hasValueFlow=3 $ hasValueFlow=4
    sink b[1] # $ hasValueFlow=3 $ hasValueFlow=4
    sink b[2] # $ hasValueFlow=3 $ hasValueFlow=4
    sink b[3] # $ hasValueFlow=3 $ hasValueFlow=4
end