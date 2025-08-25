match [1,2]:
    case (a, b):
        print(b, a)

match 1+2j:
    case 1+2j:
        pass
    case -1-2.6e7j:
        pass
    case -1:
        pass
    case 2:
        pass
    case -1.5+5j:
        pass

def soft_keywords():
    match = 0
    case = 0
    match match:
        case case:
            x = 0

match (0,1):
    case *x,:
        pass

match (2,3):
    case (*x,):
        pass

match w, x:
    case y, z:
        v = 0

match x, y:
    case 1, 2:
        pass

match z:
    case w:
        pass
