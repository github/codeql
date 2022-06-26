---
category: minorAnalysis
---
* The syntax of the (source|sink|summary)model CSV format has been changed slightly for Java and C#. A new column called `provenance` has been introduced, where the allowed values are `manual` and `generated`. The value used to indicate whether a model as been written by hand (`manual`) or create by the CSV model generator (`generated`).