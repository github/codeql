def chained_access1
    Something.foo [[[
        'sink' # $ sink=Member[Something].Method[foo].Argument[0].Element[0].Element[0].Element[0]
    ]]]
end

def chained_access2
    array = []
    array[0] = [[
        'sink' # $ sink=Member[Something].Method[foo].Argument[0].Element[0].Element[0].Element[0]
    ]]
    Something.foo array
end

def chained_access3
    array = [[]]
    array[0][0] = [
        'sink' # $ sink=Member[Something].Method[foo].Argument[0].Element[0].Element[0].Element[0]
    ]
    Something.foo array
end

def chained_access4
    Something.foo {
        :one => {
            :two => {
                :three => 'sink' # $ sink=Member[Something].Method[foo].Argument[0].Element[:one].Element[:two].Element[:three]
            }
        }
    }
end
