import default

from Javadoc jd, Documentable d
where hasJavadoc(d, jd)
select jd, d
