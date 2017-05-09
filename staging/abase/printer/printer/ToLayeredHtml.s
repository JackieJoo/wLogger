(function _PrinterToLayeredHtml_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  // if( typeof wBase === 'undefined' )
  try
  {
    require( '../../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wLogger' );

}

if( !_global_.jQuery )
return;

//

var $ = jQuery;
var _ = wTools;
var Parent = wPrinterTop;
var Self = function wPrinterToLayeredHtml( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterToLayeredHtml';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  self.containerDom = $( self.containerDom );
  _.assert( self.containerDom.length,'wPrinterToLayeredHtml : not found containerDom' );

  self.containerDom.addClass( self.contentCssClass );

  if( self.vertical )
  self.containerDom.addClass( 'vertical' );
  else
  self.containerDom.addClass( 'horizontal' );

  self.currentDom = self.containerDom;

}

//

function write()
{
  var self = this;

  /* */

  if( arguments.length === 1 )
  if( self.canPrintFrom( arguments[ 0 ] ) )
  {
    self.printFrom( arguments[ 0 ] );
    return;
  }

  /* */

  var o = wPrinterBase.prototype.write.apply( self,arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );

  /* */

  var data = _.strConcat.apply( {},arguments );
  data = data.split( '\n' );

  for( var d = 0 ; d < data.length ; d ++ )
  {
    if( d > 0 )
    self._makeNextLineDom();
    var terminal = self._makeTerminalDom();
    terminal.text( data[ d ] );
  }

  /* */

  return o;
}

//

function levelSet( level )
{
  var self = this;

  _.assert( level >= 0, 'level cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var dLevel = level - self[ symbolForLevel ];

  Parent.prototype.levelSet.call( self,level );

  if( dLevel > 0 )
  {
    for( var l = 0 ; l < dLevel ; l++ )
    self.currentDom = self._makeBranchDom();
  }
  else if( dLevel < 0 )
  {
    for( var l = 0 ; l < -dLevel ; l++ )
    self.currentDom = self.currentDom.parent();
  }

}

//

function _makeBranchDom( )
{
  var self = this;
  var result = $( '<' + self.elementCssTag + '>' );

  if( _.mapKeys( self.attributes ).length )
  _.domAttrs( result,self.attributes );

  self.currentDom.append( result );
  result.addClass( self.branchCssClass );

  if( self.usingRandomColor )
  {
    var color = _.color.randomRgbWithSl( 0.5,0.5 );
    color[ 3 ] = self.opacity;
    // color = [ 0.75,1,1,0.5 ];
    result.css( 'background-color',_.color.colorToRgbaHtml( color ) );
  }

  return result;
}

//

function _makeTerminalDom()
{
  var self = this;
  var result = $( '<' + self.elementCssTag + '>' );

  if( _.mapKeys( self.attributes ).length )
  _.domAttrs( result,self.attributes );

  self.currentDom.append( result );
  result.addClass( self.terminalCssClass );

  return result;
}

//

function _makeNextLineDom()
{
  var self = this;

  if( !self.usingNextLineDom )
  return;

  var result = $( '<' + self.elementCssTag + '>' );
  result.text( ' ' );

  result.addClass( self.nextLineCssClass );
  self.currentDom.append( result );

  return result;
}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  contentCssClass : 'layered-log-content',
  branchCssClass : 'layered-log-branch',
  terminalCssClass : 'layered-log-terminal',
  nextLineCssClass : 'layered-log-next-line',

  elementCssTag : 'span',

  opacity : 0.2,
  usingRandomColor : 0,
  usingNextLineDom : 0,

  vertical : 0,

}

var Aggregates =
{
}

var Associates =
{
  containerDom : null,
  currentDom : null,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  write : write,

  levelSet : levelSet,

  _makeBranchDom : _makeBranchDom,
  _makeTerminalDom : _makeTerminalDom,
  _makeNextLineDom : _makeNextLineDom,


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

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();