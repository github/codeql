def print_character_codes_bad(strings):
    if strings is not None:
        for s in strings:
            if s is not None:
                for c in s:
                    print(c + '=' + ord(c))