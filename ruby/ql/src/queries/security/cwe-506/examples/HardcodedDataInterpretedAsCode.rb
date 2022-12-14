def e(r)
  [r].pack 'H*'
end

# BAD: hexadecimal constant decoded and interpreted as import path
require e("2e2f746573742f64617461")
