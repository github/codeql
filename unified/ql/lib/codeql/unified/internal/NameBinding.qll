/**
 * Re-exports everything from the name-binding passes, while avoiding conflicts on 'Public'.
 *
 * TODO: move name binding passes into a subfolder.
 */

import StaticNameBinding
import LocalNameBinding
import NameBindingPlugin

module Public {
  // re-declare here to avoid conflicting import
  import StaticNameBinding::Public
  import LocalNameBinding::Public
}
