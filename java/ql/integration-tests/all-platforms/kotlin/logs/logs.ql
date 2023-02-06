import external.ExternalArtifact

from ExternalData ed
where ed.getDataPath().matches("%logs.csv")
select ed.getFieldAsInt(0), ed.getFieldAsInt(1), ed.getField(2), ed.getField(3), ed.getField(4)
