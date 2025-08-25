# An expression containing the same kind of quotes as the outer f-string
songs = ['Take me back to Eden', 'Alkaline', 'Ascensionism']
f"This is the playlist: {", ".join(songs)}"

# An example of the previously maximal level of nesting
f"""{f'''{f'{f"{1+1}"}'}'''}"""

# An example of the new, unlimited level of nesting
f"{f"{f"{f"{f"{f"{1+1}"}"}"}"}"}"

# An f-string with newlines inside the expression part
f"This is the playlist: {", ".join([
    'Take me back to Eden',  # My, my, those eyes like fire
    'Alkaline',              # Not acid nor alkaline
    'Ascensionism'           # Take to the broken skies at last
])}"

# Two instances of string escaping used inside the expression part
print(f"This is the playlist: {"\n".join(songs)}")

print(f"This is the playlist: {"\N{BLACK HEART SUIT}".join(songs)}")
