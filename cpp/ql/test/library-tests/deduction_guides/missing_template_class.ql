import cpp

from DeductionGuide d
where not exists(d.getTemplateClass())
select d
