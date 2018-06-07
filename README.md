TVShader Touch Support

Touch support routines for manually dispatching touch events within a specified group.
For Corona SDK.

TVShader is available in the Corona Marketplace:  https://marketplace.coronalabs.com/graphics/tvshader

(You need a copy of TVShader to use the demo as written.  The touch support module
itself doesn't require TVShader, but is perhaps of little use if you're not trying to
solve a paricular problem __caused__ by using TVShader or something similar
for full-screen effects.)

Primarily intended for use when that group has been "hijacked" for full-screen effect
rendering and can no longer receive touch events on the individual child elements.

This "solution" still has plenty of room for improvement.  For example, higher-level
group visibility should be "passed down" to grand-children and great-grand-children,
along with treating alpha=0 as isVisible=false, etc, et al.

So consider this a place to start, rather than a final destination - only you can
know if you'll need to handle more of the "tricky" cases.

The routine is recursive, so theoretically processes a deeply nested
structure, but in practice it's really only tested to a single depth.  But it does
a good job at handling rotated objects within that arbitrarily transformed group.

