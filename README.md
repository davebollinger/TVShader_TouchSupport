TVShader Touch Support

Touch support routines for manually dispatching touch events within a specified group.
For Corona SDK.

You need a copy of TVShader to use this as written.
TVShader is available in the Corona Marketplace:  https://marketplace.coronalabs.com/graphics/tvshader

Primarily intended for use when that group has been "hijacked" for full-screen effect
rendering and can no longer receive touch events on the individual child elements.

This "solution" still has plenty of room for improvement.  For example, higher-level
group visibility should be "passed down" to grand-children and great-grand-children,
etc, et al.

The routine is recursive, so theoretically processes a deeply nested
structure, but in practice it's really only tested to a single depth.  But it does
a good job at handling rotated objects within that arbitrarily transformed group.

