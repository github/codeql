local module_name

if condition then
  module_name = "alpha.module"
else
  module_name = "beta.module"
end

return require(module_name)
