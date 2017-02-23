( function _Browser_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Browser.test.s

*/

var _ = wTools;
var Parent = wTools.Testing;
var Self = {};

//

var toStrEscaping = function ( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function simplest( test )
{

  test.description = 'simple1';

  var logger = new wLogger();

  logger.logUp( 'up' );
  logger.log( 'log' );
  logger.log( 'log\nlog' );
  logger.log( 'log','a','b' );
  logger.log( 'log\nlog','a','b' );
  logger.log( 'log\nlog','a\n','b\n' );
  logger.logDown( 'down' );

  test.identical( 1,1);

}

//

var _escaping = function ( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function colorConsole( test )
{
  var got;
  var onWrite = function ( args ){ got = args };


  var logger = new wLogger( { output : null, onWrite : onWrite });


  test.description = 'case1';
  var msg = _.strColor.fg( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 0, 0, 0, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2';
  var msg = _.strColor.bg( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:none;background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3';
  var msg = _.strColor.bg( _.strColor.fg( 'red text', 'red' ), 'black' );
  logger.log( msg );
  var expected = [ '%cred text','color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case4';
  var msg = _.strColor.fg( 'yellow text' + _.strColor.bg( _.strColor.fg( 'red text', 'red' ), 'black' ), 'yellow')
  logger.log( msg );
  var expected = [ '%cyellow text%cred text','color:rgba( 255, 255, 0, 1 );background:none;', 'color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5: unknown color';
  var msg = _.strColor.fg( 'msg', 'unknown')
  logger.log( msg );
  var expected = [ '%cmsg','color:none;background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case6: hex color';
  var msg = _.strColor.fg( 'msg', 'ff00ff' )
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 255, 0, 255, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );


}

//

var Proto =
{

  name : 'Logger browser test',

  tests :
  {

    simplest : simplest,
    colorConsole : colorConsole

  },

  /* verbosity : 1, */

}

//

_.mapExtend( Self,Proto );
Self = wTestSuite( Self );
_.Testing.test( Self.name );

} )( );
