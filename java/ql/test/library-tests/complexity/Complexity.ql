import default

from MetricCallable f
where f.getName().matches("cc_") // cc1, cc2, ...
select f, f.getCyclomaticComplexity()
