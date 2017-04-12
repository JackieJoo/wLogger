(function _aColoredMixin_s_() {

'use strict';

var isBrowser = true;
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

  isBrowser = false;

  var _ = wTools;

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

}

var _ = wTools;

//

function mixin( constructor )
{

  var dst = constructor.prototype;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( constructor ) );

  _.mixin
  ({
    dst : dst,
    mixin : Self,
  });

  _.accessor
  ({
    object : dst,
    combining : 'rewrite',
    names :
    {
      // level : 'level',
      foregroundColor : 'foregroundColor',
      backgroundColor : 'backgroundColor',
    }
  });

}

// --
// etc
// --

function _rgbToCode( rgb )
{
  var r = rgb[ 0 ];
  var g = rgb[ 1 ];
  var b = rgb[ 2 ];

  var ansi = 30 + ( ( Math.round( b ) << 2 ) | ( Math.round( g ) << 1 ) | Math.round( r ) );

  // why 8 ???

  return ansi;
}

//

function _handleStrip( strip )
{
  var allowedKeys = [ 'bg','background','fg','foreground' ];
  var parts = strip.split( ' : ' );
  if( parts.length === 2 )
  {
    if( allowedKeys.indexOf( parts[ 0 ] ) === -1 )
    return;
    return parts;
  }
}

//

/* !!! eliminate this routine, implement additional routine/routines in _.color if needed */
function _colorConvert( color )
{
  if( !color )
  return null;

  try
  {
    if( !isBrowser )
    color = _.color.rgbFrom( color );
    else
    color = _.color.rgbaFrom( color );
  }
  catch ( err )
  {
    var name = _.color.colorNameNearest( color );
    if( name )
    color = _.color.ColorMap[ name ];
    else
    return null;
  }

  return color;
}

//

function _foregroundColorGet()
{
  var self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  var self = this;
  return self[ symbolForBackground ];
}

//

function _foregroundColorSet( color )
{
  var self = this;
  var layer = 'foreground';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( layer ) )
    self[ symbolForForeground ] = self._stackPop( layer );
    else
    self[ symbolForForeground ] = null;
  }
  else
  {
    if( self[ symbolForForeground ] )
    self._stackPush( layer, self[ symbolForForeground ] );

    self[ symbolForForeground ] = self._colorConvert( color );
  }
}

//

function _backgroundColorSet( color )
{
  var self = this;
  var layer = 'background';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( layer ) )
    self[ symbolForBackground ] = self._stackPop( layer );
    else
    self[ symbolForBackground ] = null;
  }
  else
  {
    if( self[ symbolForBackground ] )
    self._stackPush( layer, self[ symbolForBackground ] );

    self[ symbolForBackground ] = self._colorConvert( color );
  }
}

// --
// stack
// --

function _stackPush( layer, color )
{
  var self = this;

  if( !self.colorsStack )
  {
    self.colorsStack = { 'foreground' : [], 'background' : [] };
  }

  self.colorsStack[ layer ].push( color );
}

//

function _stackPop( layer )
{
  var self = this;

  return self.colorsStack[ layer ].pop();
}

//

function _stackIsNotEmpty( layer )
{
  var self = this;
  if( self.colorsStack && self.colorsStack[ layer ].length )
  return true;

  return false;
}

// --
// colored text
// --

/* !!! find a new home for the function */

function coloredToHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( !_.objectIs( o ) )
  o = { src : o }

  _.routineOptions( coloredToHtml,o );
  _.assert( _.strIs( o.src ) || _.arrayIs( o.src ) );
  _.assert( _.routineIs( o.onStrip ) );

  if( _.arrayIs( o.src ) )
  {
    var optionsForStr =
    {
      delimeter  : ''
    }
    o.src = _.strConcat.apply( optionsForStr ,o.src );

  }

  var result = '';
  var spanCount = 0;

  var splitted = _.strExtractStrips( o.src, { onStrip : o.onStrip } );

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( style === 'foreground')
      {
        self.foregroundColor = o.colorConvert( color );
      }
      else if( style === 'background')
      {
        self.backgroundColor = o.colorConvert( color );
      }

      var fg = self.foregroundColor;
      var bg = self.backgroundColor;

      if( !fg || fg === 'default' )
      fg = null;

      if( !bg || bg === 'default' )
      bg = null;

      if( color === 'default' && spanCount )
      {
        result += `</${o.tag}>`;
        spanCount--;
      }
      else
      {
        var style = '';

        if( o.compact )
        {
          if( fg )
          style += `color:${ _.color.colorToRgbaHtml( fg ) };`;

          if( bg )
          style += `background:${ _.color.colorToRgbaHtml( bg ) };`;
        }
        else
        {
          fg = fg || 'transparent';
          bg = bg || 'transparent';
          style = `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };`;
        }

        if( style.length )
        result += `<${o.tag} style='${style}'>`;
        else
        result += `<${o.tag}>`;

        spanCount++;
      }
    }
    else
    {
      var text = _.strReplaceAll( splitted[ i ], '\n', '<br>' );

      if( !o.compact && !spanCount )
      {
        result += `<${o.tag}>${text}</${o.tag}>`;
      }
      else
      result += text;
    }
  }

  _.assert( spanCount === 0 );

  return result;
}

coloredToHtml.defaults =
{
  src : null,
  tag : 'span',
  compact : true,
  onStrip : _handleStrip,
  colorConvert : _colorConvert,
}

//

function _writePrepareHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  o.outputForTerminal = [ self.coloredToHtml( o.output[ 0 ] ) ];

  return o;
}

//

function _writePrepareShell( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = '';

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  var layersOnly = true;
  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    {
      layersOnly = false;

      if( self._cursorSaved )
      {
        /*restores cursos position*/
        result +=  '\x1b[u';
        self._cursorSaved = 0;
      }
      result +=  splitted[ i ];
    }
    else
    {
      var layer = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( layer === 'foreground')
      {
        self.foregroundColor = color;

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;
        else
        result += `\x1b[39m`;
      }
      else if( layer === 'background' )
      {
        self.backgroundColor = color;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode( self.backgroundColor ) + 10 }m`;
        else
        result += `\x1b[49m`;
      }
    }
  }

  if( layersOnly )
  {
    /* saves cursos position */
    self._cursorSaved = 1;
    result += '\x1b[s';
  }

  o.outputForTerminal = [ result ];

  return o;
}

//

function _writePrepareBrowser( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = [ '' ];

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var layer = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( layer === 'foreground')
      {
        self.foregroundColor = color;
      }
      else if( layer === 'background')
      {
        self.backgroundColor = color;
      }
      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( !i && !self._isStyled )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        var fg = self.foregroundColor || 'none';
        var bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
      }
    }
  }

  o.outputForTerminal = result;

  return o;
}

//

function _writePrepareWithoutColors( o )
{
  var self = this;
  var result = '';

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  for( var i = 0 ; i < splitted.length ; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
  }

  o.outputForTerminal = [ result ];

  return o;
}

//

function _writePrepare( original )
{

  return function _writePrepare( o )
  {
    var self = this;

    _.assert( arguments.length === 1 );
    _.assert( _.mapIs( o ) );

    o = original.call( self,o );

    _.assert( _.strIs( o.pure ) );
    _.assert( _.arrayLike( o.input ) );
    _.assert( _.arrayLike( o.output ) );
    _.assert( o.output.length === 1 )

    if( _.color && self.coloring )
    {

      if( self.permanentStyle )
      {
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],self.permanentStyle );
      }

      if( self.coloringConnotation )
      {
        if( self.attributes.connotation === 'positive' )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'positive' );
        else if( self.attributes.connotation === 'negative' )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'negative' );
      }

      if( self.coloringHeadAndTail )
      if( self.attributes.head || self.attributes.tail )
      if( _.strStrip( o.pure ) )
      {
        var reserve = self.verbosityReserve();
        if( self.attributes.head && reserve > 1 )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'head' );
        else if( self.attributes.tail && reserve > 1 )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'tail' );
      }

      if( !self.passingRawColor )
      {
        if( self.writingToHtml )
        self._writePrepareHtml( o );
        else if( !isBrowser )
        self._writePrepareShell( o );
        else
        self._writePrepareBrowser( o );
      }

    }
    else
    {
      self._writePrepareWithoutColors( o );
    }

    _.assert( _.arrayIs( o.output ) );

    return o;
  }

}

// --
// topic
// --

function topic()
{
  var self = this;

  debugger;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.log( result );
  this.log();

  return result;
}

//

function topicUp()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.logUp( result );
  this.log();

  return result;
}

//

function topicDown()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );


  this.log();
  this.logDown( result );
  this.log();

  return result;
}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

var Composes =
{

  foregroundColor : null,
  backgroundColor : null,

  colorsStack : null,
  passingRawColor : 0,
  coloring : 1,
  coloringHeadAndTail : 1,
  coloringConnotation : 1,
  writingToHtml : 0,

  _isStyled : 0,
  _cursorSaved : 0,

  permanentStyle : null,

  // attributes : {},

}

var Aggregates =
{
}

var Associates =
{
}

var Statics =
{
  coloredToHtml : coloredToHtml
}

// --
// proto
// --

var Functor =
{

  _writePrepare : _writePrepare,

}

var Extend =
{

  // etc

  _rgbToCode : _rgbToCode,
  _colorConvert : _colorConvert,
  _handleStrip : _handleStrip,

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,

  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,


  // stack

  _stackPush : _stackPush,
  _stackPop : _stackPop,
  _stackIsNotEmpty : _stackIsNotEmpty,


  // colored text

  coloredToHtml : coloredToHtml,
  _writePrepareHtml : _writePrepareHtml,
  _writePrepareShell : _writePrepareShell,
  _writePrepareBrowser : _writePrepareBrowser,
  _writePrepareWithoutColors : _writePrepareWithoutColors,


  // topic

  topic : topic,
  topicUp : topicUp,
  topicDown : topicDown,


  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

//

var Self =
{

  Extend : Extend,
  Functor : Functor,

  mixin : mixin,

  name : 'wPrinterColoredMixin',
  nameShort : 'PrinterColoredMixin',

}

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
