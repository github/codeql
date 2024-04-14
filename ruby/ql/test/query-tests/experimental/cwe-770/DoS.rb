class UserController < ActionController::Base
    def bad_examples_1
      limit_i = params[:limit].to_i
      
      # BAD:
      1.upto(limit_i) do |i|
          put "a repeatable operation"
      end

      # BAD:
      1.downto(limit_i) do |i|
          put "a repeatable operation"
      end

      # BAD:
      1.downto(limit_i+1000) do |i|
        put "a repeatable operation"
    end
      
      # BAD:
      limit_i.times do
          put "a repeatable operation"
      end
  
      # BAD:
      limit_i.downto(1) do |i|
          put "a repeatable operation"
      end

      # BAD:
      limit_i.upto(1000) do |i|
        put "a repeatable operation"
      end

       # BAD:
       for i in 1..limit_i
          put "a repeatable operation"
       end

        # BAD:
        until limit_i == 0
            put "a repeatable operation"
            limit_i -= 1
        end

        # BAD: 
        while limit_i > 0
            put "a repeatable operation"
            limit_i -= 1
        end
  
    end

    def bad_examples_2
        limit_f = params[:limit].to_f
        
        # BAD:
        1.upto(limit_f) do |i|
            put "a repeatable operation"
        end

        # BAD:
        1.upto(limit_f-1000) do |i|
            put "a repeatable operation"
        end
  
        # BAD:
        1.downto(limit_f) do |i|
            put "a repeatable operation"
        end
        
        # BAD:
        limit_f.times do
            put "a repeatable operation"
        end
    
        # BAD:
        limit_f.downto(1) do |i|
            put "a repeatable operation"
        end
  
        # BAD:
        limit_f.upto(1000) do |i|
          put "a repeatable operation"
        end
  
         # BAD:
         for i in 1..limit_f
            put "a repeatable operation"
         end
  
          # BAD:
          until limit_f == 0
              put "a repeatable operation"
              limit_f -= 1
          end
  
          # BAD: 
          while limit_f > 0
              put "a repeatable operation"
              limit_f -= 1
          end
    
      end

    def good_examples
        limit_i = params[:limit].to_i

        if limit_i > 1000 
            limit_i = 1000
        end

        # GOOD:
        1.upto(limit_i) do |i|
            put "a repeatable operation"
        end

        # GOOD:
        if 0 > limit_i 
            limit_i = 0
        end

        1000.downto(limit_i) do |i|
            put "a repeatable operation"
        end

        # GOOD:
        if limit_i > 0 && limit_i < 1000
            limit_i.times do
                put "a repeatable operation"
            end
        end

    end 
  end