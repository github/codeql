syn keyword dbschemeKeyword case of
syn keyword dbschemeType int ref string varchar 

syn match dbschemeCustomType "\v[@][a-zA-Z_0-9]+" 

syn region dbschemeComment start='/\*' end='\*/'

hi def link dbschemeType Type
hi def link dbschemeKeyword Keyword
hi def link dbschemeCustomType Type
hi def link dbschemeComment Comment
