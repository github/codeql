---
category: feature
---
* The "Unpinned tag for a non-immutable Action in workflow" query (`actions/unpinned-tag`) now supports expanding the trusted action owner list using data extensions (`extensible: trustedActionsOwnerDataModel`). If you trust an Action publisher, you can include the owner name/organization in a data extension model pack to add it to the allow list for this query. This addition will prevent security alerts when using unpinned tags for Actions published by that owner.