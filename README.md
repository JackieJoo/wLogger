# wLogger
Module in JavaScript providing convenient, layered, cross-platform means for multilevel, colorful logging.

## wLogger



## Installation
```terminal
npm install wLogger
```
## Usage
### Options
* output { object }[ optional, default : console ] - single output object for current logger;
* level { number }[ optional, default : 0 ] - controls current output level;
* _prefix { string }[ optional, default : '' ] - string inserted before each message;
* _postfix { string }[ optional, default : '' ] - string inserted after each message;
* _dprefix { string }[ optional, default : '  ' ] - string inserted before each message if level > 1, count of insertions depends on level property;
* _dpostfix { string }[ optional, default : '' ] - string inserted after each message if level > 1,count of insertions depends on level property.

### Methods
Output:
* log
* error
* info
* warn

Leveling:
* Increase current output level - [up](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.up)
* Decrease current output level - [down](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.down)

Chaining:
* Add object to output list - [outputTo](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputTo)
* Remove object from output list - [outputToUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputToUnchain)
* Add current logger to target's output list - [inputFrom](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFrom)
* Remove current logger from target's output list - [inputFromUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFromUnchain)

Other:
* Check if object exists in logger's inputs list - [hasInput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasInput)
* Check if object exists in logger's outputs list - [hasOutput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasOutput)
* Current text foreground color - [colorForegroundGet](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterMid.html#.colorForegroundGet)
* Current text background color - [colorBackgroundGet](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterMid.html#.colorForegroundGet)
