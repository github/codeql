
# Flatten nesting by using early exits
def print_character_codes_early_exit(strings):
    if strings is None:
        return
    for s in strings:
        if s is None:
            continue
        for c in s:
            print(c + '=' + ord(c))
            
            
#Move flow control into its own generator function           
def print_character_codes_use_gen(strings):
    for c in gen_chars_in_strings(strings):
        print(c + '=' + ord(c))
        
def gen_chars_in_strings(strings):
    if strings is None:
        return
    for s in strings:
        if s is None:
            continue
        for c in s:
            yield c
            
#Move inner loop into its own function
def print_character_codes_in_string(string):
    if string is not None:
        for c in string:
            print(c + '=' + ord(c))
            
def print_character_codes_extracted(strings):
    if strings is not None:
        for s in strings:
            print_character_codes_in_string(s)