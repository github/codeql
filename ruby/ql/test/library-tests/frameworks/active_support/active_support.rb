"Foo::Bar".constantize

a.constantize
a.safe_constantize

ActiveSupport::Logger.new(STDOUT)
ActiveSupport::TaggedLogging.new(STDOUT)

def m_at
    x = source "a"
    sink x.at(1..3) # $hasTaintFlow=a
end

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

def first
    x = source "a"
    sink x.first(3) # $hasTaintFlow=a
end

def m_foreign_key
    x = source "a"
    sink x.foreign_key # $hasTaintFlow=a
end

def m_from
    x = source "a"
    sink x.from(3) # $hasTaintFlow=a
end

def m_html_safe
    x = source "a"
    sink x.html_safe # $hasTaintFlow=a
end

def m_humanize
    x = source "a"
    sink x.humanize # $hasTaintFlow=a
end

def m_indent
    x = source "a"
    sink x.indent(1) # $hasTaintFlow=a
end

def m_indent!
    x = source "a"
    sink x.indent!(1) # $hasTaintFlow=a
end

def m_inquiry
    x = source "a"
    sink x.inquiry # $hasTaintFlow=a
end

def m_last
    x = source "a"
    sink x.last(1) # $hasTaintFlow=a
end

def m_mb_chars
    x = source "a"
    sink x.mb_chars # $hasTaintFlow=a
end

def m_parameterize
    x = source "a"
    sink x.parameterize # $hasTaintFlow=a
end

def m_pluralize
    x = source "a"
    sink x.pluralize # $hasTaintFlow=a
end

def m_remove
    x = source "a"
    sink x.remove("foo") # $hasTaintFlow=a
end

def m_remove!
    x = source "a"
    sink x.remove!("foo") # $hasTaintFlow=a
end

def m_singularize
    x = source "a"
    sink x.singularize # $hasTaintFlow=a
end

def m_squish
    x = source "a"
    sink x.squish # $hasTaintFlow=a
end

def m_squish!
    x = source "a"
    sink x.squish! # $hasTaintFlow=a
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

def m_to
    x = source "a"
    sink x.to(3) # $hasTaintFlow=a
end

def m_truncate
    x = source "a"
    sink x.truncate(3) # $hasTaintFlow=a
end

def m_truncate_bytes
    x = source "a"
    sink x.truncate_bytes(3) # $hasTaintFlow=a
end

def m_truncate_words
    x = source "a"
    sink x.truncate_words(3) # $hasTaintFlow=a
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

def m_safe_buffer_new
  x = source "a"
  y = ActionView::SafeBuffer.new(x)
  sink y # $hasTaintFlow=a
end

def m_safe_buffer_safe_concat_retval
  x = ActionView::SafeBuffer.new("a")
  b = source "b"
  y = x.safe_concat(b)
  sink y # $hasTaintFlow=b
end

def m_safe_buffer_safe_concat_self
  x = ActionView::SafeBuffer.new("a")
  b = source "b"
  x.safe_concat(b)
  sink x # $hasTaintFlow=b
end

def m_safe_buffer_concat
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.concat(b)
  sink y # $hasTaintFlow=a
end

def m_safe_buffer_insert
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.insert(i, b)
  sink y # $hasTaintFlow=a $hasTaintFlow=b
end

def m_safe_buffer_prepend
  a = source "a"
  b = source "b"
  x = ActionView::SafeBuffer.new(a)
  y = x.prepend(b)
  sink y # $hasTaintFlow=a
end

def m_safe_buffer_to_s
  a = source "a"
  x = ActionView::SafeBuffer.new(a)
  y = x.to_s
  sink y # $hasTaintFlow=a
end

def m_safe_buffer_to_param
  a = source "a"
  x = ActionView::SafeBuffer.new(a)
  y = x.to_param
  sink y # $hasTaintFlow=a
end

def m_pathname_existence
  a = source "a"
  x = Pathname.new(a)
  y = x.existence
  sink y # $hasTaintFlow=a
  z = y.existence
  sink z # $hasTaintFlow=a
end

def m_presence
  x = source "a"
  sink x.presence # $hasValueFlow=a

  y = source 123
  sink y.presence # $hasValueFlow=123
end

def m_deep_dup
  x = source "a"
  sink x.deep_dup # $hasValueFlow=a
end

def m_try(method)
    x = "abc"
    x.try(:upcase)
    x.try(method)
    x.try!(:upcase).try!(:downcase)
    x.try!(method)
end

def m_json_escape
  a = source "a"
  b = json_escape a
  sink b # $hasTaintFlow=a
end

def m_json_encode
    x = source "a"
    sink ActiveSupport::JSON.encode(x) # $hasTaintFlow=a
end

def m_json_decode
    x = source "a"
    sink ActiveSupport::JSON.decode(x) # $hasTaintFlow=a
end

def m_json_dump
    x = source "a"
    sink ActiveSupport::JSON.dump(x) # $hasTaintFlow=a
end

def m_json_load
    x = source "a"
    sink ActiveSupport::JSON.load(x) # $hasTaintFlow=a
end

def m_to_json
    x = source "a"
    y = [x]
    sink x.to_json # $hasTaintFlow=a
    sink y.to_json # $hasTaintFlow=a
end
