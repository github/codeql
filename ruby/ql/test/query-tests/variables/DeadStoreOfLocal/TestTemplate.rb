# -*- coding: utf-8 -*-
require 'erb'

template = ERB.new <<EOF
<%#-*- coding: Big5 -*-%>
  \_\_ENCODING\_\_ is <%= \_\_ENCODING\_\_ %>.
  x is <%= x %>.
EOF
x = 5  # OK - the template can see the value of x
puts template.result