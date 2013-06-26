
/*jslint nomen:true, node:true*/

/**

The "main" tag tells yuidoc that this submodule should be grouped under the
main module "widget".


@module widget
@submodule gadget
@main widget
**/


/**
Gadget is a class.

The "extensionfor" says that this class "gadget" is an extension object
designed for optionally mixed into "widget".

"extensionfor" is the almost inverse of "uses". The differences is that
"this class _always_ has 'used' class mixed into its prototype", while
"extensionfor" says that this class _can be mixed_ into the 'extensionfor'
class, but it is not done by default.

@class gadget
@static
@extensionfor widget
**/

module.exports = {

    /**
    Example usage:

        var gadget = require('./gadget');
        gadget.load('A', 'B', 'C');

    @method load
    @protected
    @param {Object} name* list of name arguments
    @return {Object} some object
    **/
    load: function () {
    }
};
