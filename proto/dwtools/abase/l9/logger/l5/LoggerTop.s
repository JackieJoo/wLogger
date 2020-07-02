(function _LoggerTop_s_() {

'use strict';

/*

Kinds of Chain : [ ordinary, excluding, original ]

Kinds of Print-like object : [ console, printer ]

Kinds of situations :

conosle -> ordinary -> self
printer -> ordinary -> self
conosle -> excluding -> self
printer -> excluding -> self
self -> ordinary -> conosle
self -> ordinary -> printer
self -> original -> conosle
self -> original -> printer

*/

/**
 * @classdesc Extends [wLoggerMid]{@link wLoggerMid} with printers chaining and output coloring mechanics.
 * @class wLoggerTop
 * @namespace Tools
 * @module Tools/base/Logger
 */

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.LoggerMid;
let Self = function wLoggerTop( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerTop';

// --
//
// --

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self,o );
}

// --
// relations
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

// --
// declare
// --

let Proto =
{

  // routine

  init,

  // relations

  Composes,
  Aggregates,
  Associates,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.PrinterChainingMixin.mixin( Self );
_.PrinterColoredMixin.mixin( Self );

_[ Self.shortName ] = Self;

_.assert( _.routineIs( _.PrinterChainingMixin.prototype._writeAct ) );
_.assert( Self.prototype._writeAct === _.PrinterChainingMixin.prototype._writeAct );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();