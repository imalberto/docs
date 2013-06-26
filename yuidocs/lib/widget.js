
/*jslint nomen:true, node:true*/

/**
A module is a group of classes.


@module widget
**/

"use strict";

var ATTRS = {},
    RENDERED = 'rendered',
    EVT_ERROR;

/**
Use the "event" to describe the event details.

The "param" here describes the properties hanging off the event object.

@event error
@param {String} msg a description for the emitted event
**/
EVT_ERROR = 'error';


/**
The "attribute" tag is YUI specific, and affects how attributes are
declared in widgets.

@attribute rendered
@readOnly
@default false
@type Boolean
**/
ATTRS[RENDERED] = {
};

/**
Here, a class is generally an object with a constructor function. Typically,
one would use a "class" to group methods, properties, attributes, and
events. 

Usually there will be at least one class for each module in the source tree.
The "class" block should reside above the constructor function, or above
all the methods, properties, attributes and events.

A "class" should always be paired with either a "constructor" or "static".

@class widget
@static
**/
module.exports = {
    
    /**
    @property location
    @type String|mixed|any
    @default "http://www.yahoo.com"
    **/
    location: 'http://www.yahoo.com',
    
    /**
    Marking this attribute | property as optional
    
    @property readable
    @type Boolean
    @final
    @optional
    **/
    readable: false,
    
    /**
    @method admin
    @public
    @param {Boolean} [default] tells that the `default` argument is optional
    **/
    admin: function () {
    },
    
    /**
    The "for" here says that this method applies to the class "widget". There could
    be multiple classes defined in a module, or a class could have an "inner" class.
    "for" is how you would specific which class this method belongs to. In this
    example, "for" is redundant because there is only one class.
    
    @method help
    @for widget
    @param {Boolean} [argOne] this is an optional argument
    @param {Boolean} [argTwo=false] the default value of this argument is false
    @param {String} name* list of names supplied to the function as arguments
    **/
    help: function () {
    },
    
    /**
    @method version
    @since 1.2.0
    @deprecated
    **/
    version: function () {
    }
    
    
};

