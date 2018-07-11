( function _ChainingWithProcess_test_ss( ) {

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wPath' );
}

//

var _global = _global_; var _ = _global_.wTools;
var Parent = _.Tester;

// --
// resource
// --

function testFile()
{

	console.log( 'slave : starting' );
}

//

function onRoutineBegin( test,testFile )
{
  var self = this;
  var c = Object.create( null );
  c.tempDirPath = self.tempDirPath = _.pathNormalize( _.dirTempMake() );
  c.testFilePath = _.pathNormalize( _.pathJoin( c.tempDirPath,testFile.name + '.s' ) );
  _.fileProvider.fileWrite( c.testFilePath,_.routineSourceGet({ routine : testFile, withWrap : 0 }) );
  return c;
}

//

function onRoutineEnd( test )
{
  var self = this;
  // _.fileProvider.filesDelete( self.tempDirPath );
}

// --
// test
// --

function trivial( test )
{
  var self = this;
  debugger
  var c = onRoutineBegin.call( this,test,testFile );
  function onWrite( o )
  {
    got.push( o.input[ 0 ] );
  }
  var l = _.Logger({ onWrite : onWrite, output : null });
  var shell =
  {
    path : c.testFilePath,
    stdio : 'pipe',
    mode : 'spawn',
    outputColoring : 0,
    outputPrefixing : 0,
    ipc : 1,
  }
  var expected =
  [
    'slave : starting',
  ];
  var got  = [];
  var result = _.shellNode( shell )
  .doThen( function( err )
  {
    console.log( 'shellNode : done' );
    if( err )
    _.errLogOnce( err );
    test.description = 'no error from child process throwen';
    test.shouldBe( !err );
    test.shouldBe( _.arraySetIdentical( got, expected ) );
  });

  l.inputFrom( shell.process );
  return result;
}

trivial.timeOut = 30000;

// --
// proto
// --

var Self =
{

  name : 'ChainingWithProcess',
  silencing : 1,
  enabled : 0,
  onRoutineEnd : onRoutineEnd,
  context :
  {
    tempDirPath : null,
  },
  tests :
  {
    trivial : trivial,
  },

};

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
