match x:
    case 2:
        pass
    case n:
        print(n, 'not allowed')

match x:
    case n if n > 0:
        pass
    case _:
        print('only positives allowed')
