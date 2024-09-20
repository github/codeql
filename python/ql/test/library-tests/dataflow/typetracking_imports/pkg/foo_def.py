# apparently adding the assignment makes type-tracker unhappy, so we add this eval so
# it's possible to run the example and see that everything works
exec("tracked = 'tracked'")
foo = tracked # $ tracked
print(foo) # $ tracked
