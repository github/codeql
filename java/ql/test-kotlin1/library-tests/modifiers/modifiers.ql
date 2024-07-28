import java

from Modifiable m, string mod
where m.fromSource() and m.hasModifier(mod)
select m, m.getAPrimaryQlClass(), mod
