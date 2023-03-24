def e(r)
  [r].pack 'H*'
end

totally_harmless_string = '707574732822636f646520696e6a656374696f6e2229'

eval(e(totally_harmless_string)) # NOT OK: eval("puts('hello'")
eval(totally_harmless_string)    # OK: throws parse error

require e('666f6f626172') # NOT OK: require 'foobar' 
require '666f6f626172'    # OK: no taint step between source and sink

x = 'deadbeef'
require e(x) # OK: doesn't meet our criteria for being a source

another_questionable_string = "\x70\x75\x74\x73\x28\x27\x68\x65\x6C\x6C\x6F\x27\x29"
eval(another_questionable_string.strip) # NOT OK: eval("puts('hello'")
eval(another_questionable_string)       # OK: no taint step between source and sink
