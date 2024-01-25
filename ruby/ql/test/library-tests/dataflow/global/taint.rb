def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

def stringify x
    case x
        when String then
            x
        else
            ""
        end
    end
end

x = stringify (taint "1")
sink x # $ hasValueFlow=1

y = x[0..1]
sink y # $ hasTaintFlow=1