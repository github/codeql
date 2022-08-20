class B::A
end

class A::B
end

class A < B
  prepend B
end

prepend A
