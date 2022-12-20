---
 category: majorAnalysis
---
 * Flow through `initialize` constructors is now taken into account. For example, in
 ```rb
class C
  def initialize(x)
    @field = x
  end
end

C.new(y)
```
there will be flow from `y` to the field `@field` on the constructed `C` object.