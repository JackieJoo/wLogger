(function _PrinterTop_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  if( typeof wPrinterTop !== 'undefined' )
  return;

  isBrowser = false;

  if( typeof wPrinterMid === 'undefined' )
  require( './PrinterMid.s' )

  require( './aColoredMixin.s' )

  var _ = _global_.wTools;

  // _.include( 'wColor' );

}

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

//

var _ = _global_.wTools;
var Parent = _.PrinterMid;
var Self = function wPrinterTop( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterTop';

//

function init( o )
{
  var self = this;

  // if( !o )
  // o = {};
  //
  // if( !_global_.wTools.color && o.coloring === undefined )
  // {
  //   debugger;
  //   o.coloring = false;
  // }

  Parent.prototype.init.call( self,o );

}

// --
// relationships
// --

var Composes =
{

}

var Aggregates =
{
}

var Associates =
{
}

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.PrinterChainingMixin.mixin( Self );
_.PrinterColoredMixin.mixin( Self );

//

_.accessor
({
  object : Self.prototype,
  combining : 'rewrite',
  names :
  {
    level : 'level',
    // foregroundColor : 'foregroundColor',
    // backgroundColor : 'backgroundColor',
  }
});

//

_[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();