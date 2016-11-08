(function _PrinterBase_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  if( typeof wCopyable === 'undefined' )
  try
  {
    require( '../mixin/Copyable.s' );
  }
  catch( err )
  {
    require( 'wCopyable' );
  }

}

//

var symbolForLevel = Symbol.for( 'level' );

//

var _ = wTools;
var Parent = null;
var Self = function wPrinterBase()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function( o )
{
  var self = this;

  self.outputs = [];
  _.protoComplementInstance( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  // self.outputTo( null );
  //Object.preventExtensions( self );

  return self;
}

//

var init_static = function()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.outputWriteMethods.length ; m++ )
  if( !proto[ proto.outputWriteMethods[ m ] ] )
  proto._init_static( outputWriteMethods[ m ] );

}

//

var _init_static = function( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  var nameAct = name + 'Act';
  var nameUp = name + 'Up';
  var nameDown = name + 'Down';

  /* */

  var write = function()
  {
    var args = this.writeDoing( arguments );

    _.assert( _.arrayIs( args ) );

    if( this.onWrite )
    this.onWrite( args );

    return this[ nameAct ].apply( this,args );
  }

  /* */

  var writeUp = function()
  {
    var result = this[ name ].apply( this,arguments );

    this.up();

    return result;
  }

  /* */

  var writeDown = function()
  {

    this.down();
    if( arguments.length )
    var result = this[ name ].apply( this,arguments );

    return result;
  }

  proto[ name ] = write;
  proto[ nameUp ] = writeUp;
  proto[ nameDown ] = writeDown;

}

//

/**
 * Adds new logger( output ) to output list. Each message from current logger will be transfered
 * to each logger from that list. Supports several combining modes: 0, rewrite, supplement, append, prepend.
 * Returns true if new output is succesfully added, otherwise return false.
 *
 * @param { Object } output - Logger that must be added to list.
 * @param { Object } o - Options.
 * @param { Object } [ o.leveling=null ] - Controls logger leveling mode: 0, false or '' - uses it own leveling methods,
 * 'delta' -  current logger will use leveling methods from output logger.
 * @param { Object } [ o.combining=null ] - Mode which controls how new output appears in list:
 *  0, false or '' - combining is disabled;
 * 'rewrite' - clears list before adding new output;
 * 'append' - adds output to the end of list;
 * 'prepend' - adds output at the beginning;
 * 'supplement' - adds output if it not exist in list.
 *
 * @example
 *  var l = new wLogger();
 *  l.outputTo( logger, { combining : 'rewrite' } ); //returns true
 *  logger._prefix = '--';
 *  l.log( 'abc' );//logger prints '--abc'
 *
 * @example
 *  var l1 = new wLogger();
 *  var l2 = new wLogger();
 *  l1.outputTo( logger, { combining : 'rewrite' } );
 *  l2.outputTo( l1, { combining : 'rewrite' } );
 *  logger._prefix = '*';
 *  logger._postfix = '*';
 *  l2.log( 'msg from l2' );//logger prints '*msg from l2*'
 *
 * @example
 *  var l1 = new wLogger();
 *  var l2 = new wLogger();
 *  var l3 = new wLogger();
 *  logger.outputTo( l1, { combining : 'rewrite' } );
 *  logger.outputTo( l2, { combining : 'append' } );
 *  logger.outputTo( l3, { combining : 'append' } );
 *  l1._prefix = '*';
 *  l2._prefix = '**';
 *  l3._prefix = '***';
 *  logger.log( 'msg from logger' );
 *  //l1 prints '*msg from logger'
 *  //l2 prints '**msg from logger'
 *  //l3 prints '***msg from logger'
 *
 * @example
 *  var l1 = new wLogger();
 *  l.outputTo( logger, { combining : 'rewrite', leveling : 'delta' } );
 *  logger.up( 2 );
 *  l.up( 1 );
 *  logger.log( 'aaa\nbbb' );
 *  l.log( 'ccc\nddd' );
 *  //logger prints
 *  // ---aaa
 *  // ---bbb
 *  // ----ccc
 *  // -----ddd
 *
 * @method outputTo
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( output ) is not a Object or null.
 * @throws { Exception } If specified combining mode is not allowed.
 * @throws { Exception } If specified leveling mode is not allowed.
 * @throws { Exception } If combining mode is disabled and output list has multiple elements.
 * @memberof wTools
 *
 */
var outputTo = function( output,o )
{
  var self = this;
  var o = o || {};
  var combiningAllowed = [ 'rewrite','supplement','append','prepend' ];

  _.routineOptions( self.outputTo,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( output ) || output === null );

  _.assert( !o.combining || combiningAllowed.indexOf( o.combining ) !== -1 );
  _.assert( !o.combining || o.combining === 'rewrite'|| o.combining === 'append' || o.combining === 'prepend','not implemented combining mode' );
  _.assert( !o.leveling || o.leveling === 'delta','not implemented leveling mode' );

  /* output */

  if( output )
  {

    if( self.outputs.indexOf( output ) !== -1 )
    return false;

    if( self.outputs.length )
    {
      if( o.combining === 'supplement' )
      return false;
      else if( o.combining === 'rewrite' )
      self.outputs.splice( 0,self.outputs.length );
    }

    var descriptor = {};
    descriptor.output = output;
    descriptor.methods = {};

    if( !o.combining )
    _.assert( self.outputs.length === 0, 'outputTo : combining if off, multiple outputs are not allowed' );

    if( o.combining === 'prepend' )
    self.outputs.unshift( descriptor );
    else
    self.outputs.push( descriptor );

  }

  /* write */

  for( var m = 0 ; m < self.outputWriteMethods.length ; m++ )
  {

    var name = self.outputWriteMethods[ m ];
    var nameAct = name + 'Act';

    // if( o.combining === 'supplement' && _.routineIs( self[ nameAct ] ) )
    // continue;

    if( output === null )
    {
      self[ nameAct ] = null;
      continue;
    }

    _.assert( output[ name ],'outputTo expects output has method',name );

    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );

    if( self.outputs.length > 1 ) ( function()
    {
      var n = nameAct;
      self[ n ] = function()
      {
        for( var d = 0 ; d < this.outputs.length ; d++ )
        this.outputs[ d ].methods[ n ].apply( this,arguments );
      }
    })()
    else
    {
      self[ nameAct ] = descriptor.methods[ nameAct ];
    }

  }

  /* change level */

  for( var m = 0 ; m < self.outputChangeLevelMethods.length ; m++ )
  {

    var name = self.outputChangeLevelMethods[ m ];
    var nameAct = name + 'Act';

    // if( o.combining === 'supplement' && _.routineIs( self[ nameAct ] ) )
    // continue;

    if( output === null )
    {
      self[ nameAct ] = null;
      continue;
    }

    if( output[ name ] && o.leveling === 'delta' )
    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );
    else
    descriptor.methods[ nameAct ] = function(){};

    self[ nameAct ] = descriptor.methods[ nameAct ]

  }

  return true;
}

outputTo.defaults =
{
  combining : 0,
  leveling : 0,
}

//

var inputFrom = function( input,o )
{
  var self = this;
  var o = o || {};

  _.routineOptions( self.inputFrom,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( output ) || output === null );

  debugger;

  if( _.routineIs( input.outputTo ) )
  {
    input.outputTo( self,o );
    return;
  }

  debugger;

  /* write */

  for( var m = 0 ; m < self.outputWriteMethods.length ; m++ ) (function()
  {
    var name = self.outputWriteMethods[ m ];

    _.assert( input[ name ],'inputFrom expects input has method',name );

    var original = input[ name ];
    input[ name ] = function()
    {
      debugger;
    }

  })();

}

inputFrom.defaults =
{
  rewriting : 'rewrite',
}

inputFrom.defaults.__proto__ = outputTo.defaults;

//

var writeDoing = function( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = [ _.str.apply( _,args ) ];

  return result;
}

//

var up = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self._levelSet( self.level+dLevel );

}

//

var down = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self._levelSet( self.level-dLevel );

}

//

var _levelSet = function( level )
{
  var self = this;

  _.assert( level >= 0, '_levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var dLevel = level - self[ symbolForLevel ];

  if( dLevel > 0 )
  self.upAct( +dLevel );
  else if( dLevel < 0 )
  self.downAct( -dLevel );

  self[ symbolForLevel ] = level ;

}

//

var _outputSet = function( output )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self.outputTo( output,{ combining : 'rewrite' } );

}

//

var _outputGet = function( output )
{
  var self = this;
  return self.outputs.length ? self.outputs[ self.outputs.length-1 ].output : null;
}

// --
// relationships
// --

var Composes =
{
  level : 0,
  onWrite : null
}

var Aggregates =
{
}

var Associates =
{

  output : null,
  outputs : [],
  outputsDescriptors : [],

}

var outputWriteMethods =
[
  'log',
  'error',
  'info',
  'warn',
];

var outputChangeLevelMethods =
[
  'up',
  'down',
];

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,
  outputTo : outputTo,

  init_static : init_static,
  _init_static : _init_static,
  writeDoing : writeDoing,

  up : up,
  down : down,

  _levelSet : _levelSet,

  _outputSet : _outputSet,
  _outputGet : _outputGet,

  // var

  outputWriteMethods : outputWriteMethods,
  outputChangeLevelMethods : outputChangeLevelMethods,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

Self.prototype.init_static();

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
    output : 'output',
  }
});

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
    format : 'format',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools.PrinterBase = Self;

return Self;

})();
