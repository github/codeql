
    def __init__(self, name, choices=[], default=[], shortDesc=None,
                 longDesc=None, hints=None, allowNone=1):   # 'default' parameter assigned a value
        self.choices = choices
        if choices and not default:
            default.append(choices[0][1])                   # value of 'default' parameter modified
        Argument.__init__(self, name, default, shortDesc, longDesc, hints, allowNone=allowNone)