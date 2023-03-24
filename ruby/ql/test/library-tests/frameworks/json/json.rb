sink JSON.parse(source "a") # $hasTaintFlow=a
sink JSON.parse!(source "a") # $hasTaintFlow=a
sink JSON.load(source "a") # $hasTaintFlow=a
sink JSON.restore(source "a") # $hasTaintFlow=a

sink JSON.generate(source "a") # $hasTaintFlow=a
sink JSON.fast_generate(source "a") # $hasTaintFlow=a
sink JSON.pretty_generate(source "a") # $hasTaintFlow=a
sink JSON.dump(source "a") # $hasTaintFlow=a
sink JSON.unparse(source "a") # $hasTaintFlow=a
sink JSON.fast_unparse(source "a") # $hasTaintFlow=a
