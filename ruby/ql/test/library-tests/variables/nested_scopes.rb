def a
  puts "method a"
end
class C
  a = 5
  module M
    a = 4
    module N
      a = 3
      class D
        a = 2
        def show_a
          a = 1
          puts a
          a.times do |a|
            a.times do | x; a| 
              a = 6
              a.times { |x| puts a }
            end
          end
        end
        def show_a2 a
          puts a
        end
        puts a
      end
      def self.show
          puts a # not a variable, but a call to a()
      end
      class << self
          a = 10
          puts a
      end
      puts a
    end
    puts a
  end
  puts a
end
d = C::M::N::D.new
d.show_a

