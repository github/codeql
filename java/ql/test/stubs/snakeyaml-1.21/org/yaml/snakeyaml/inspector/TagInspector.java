package org.yaml.snakeyaml.inspector;

import org.yaml.snakeyaml.nodes.Tag;

public interface TagInspector {
    boolean isGlobalTagAllowed(Tag tag);
}
