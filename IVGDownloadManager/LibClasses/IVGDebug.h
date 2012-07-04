/*
 *  IvyGulchDebug.h
 *  IvyGulchUtils
 *
 *  Created by Douglas Sjoquist on 11/28/10.
 *  Copyright 2010 IvyGulch, LLC All rights reserved.
 *
 */


// Define IVG_DEBUG_MODE for Debug distributions in project build config files

// if IVG_DEBUG_MODE is set, then these macros are in effect, otherwise they do nothing
//   IVGDStatement includes enclosed text as a statement, only simple statements will work
//      (intent is to used when a temporary object needs to be created to display in subsequent log message)
//
//   IVGDLog takes 3 or more parameters
//      l   --  debug level, an integer value that represents the level of detail of this log message
//      c   --  category level, an integer value that is the current level that should be displayed
//              the intent is to allow specific categories (classes) to have their own debug level via individual #defines
//      s   --  NSLog format string to use
//      ...     Var args that match the format string
//
// IVGALog displays similar log messages, but is unconditional (no debug level, conditions, and ignores IVG_DEBUG_MODE)
// 
// IVGDSLog and IVGASLog behave the same, except they include the self pointer as well
// IVGDFLog and IVGAFLog behave the same, except they include the filename/linenumber as well
// IVGDSFLog and IVGASFLog behave the same, except they include the self pointer and filename/linenumber as well

#define IVGDBG_TRACE 4
#define IVGDBG_DEBUG 3
#define IVGDBG_INFO 2
#define IVGDBG_WARN 1
#define IVGDBG_NONE 0

#ifdef IVG_DEBUG_MODE
#define IVGDStatement( s ) s
#define IVGDLog( l, c, s, ... ) if ((l) <= (c)) NSLog( @"%@", [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGDSLog( l, c, s, ... ) if ((l) <= (c)) NSLog( @"<%p> %@", self, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGDFLog( l, c, s, ... ) if ((l) <= (c)) NSLog( @"%@:(%d) %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGDSFLog( l, c, s, ... ) if ((l) <= (c)) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define IVGDStatement( s ) 
#define IVGDLog( l, c, s, ... ) 
#define IVGDSLog( l, c, s, ... ) 
#define IVGDFLog( l, c, s, ... ) 
#define IVGDSFLog( l, c, s, ... ) 
#endif

#define IVGALog( s, ... ) NSLog( @"%@", [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGASLog( s, ... ) NSLog( @"<%p> %@", self, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGAFLog( s, ... ) NSLog( @"%@:(%d) %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define IVGASFLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
