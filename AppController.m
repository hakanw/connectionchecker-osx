/* -*- Mode: Objective-C; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-  */
/*
    Copyright 2008-2009 Håkan Waara (hakan@konstochvanligasaker.se)
    This file is part of ConnectionChecker.

    ConnectionChecker is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ConnectionChecker is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ConnectionChecker.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "AppController.h"
#import "ConnectionView.h"

@interface AppController(Private)
- (void)check:(NSTimer *)timer;
- (void)setupTimerAndHost;
@end

@implementation AppController

- (void)awakeFromNib
{
  if ([[NSScreen screens] count]) { 
    // figure out an area covering all screens
    NSRect allScreensFrame;
    NSScreen *screen;
    NSEnumerator *screenEnumerator = [[NSScreen screens] objectEnumerator];
    while ((screen = [screenEnumerator nextObject])) {
      allScreensFrame = NSUnionRect([screen frame], allScreensFrame);
    } 
    
    // create the connection view
    connectionView = [[ConnectionView alloc] initWithFrame:allScreensFrame];
    [connectionView setDelegate:self];
    
    // create & show the window
    desktopWindow = [[NSWindow alloc] initWithContentRect:allScreensFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [desktopWindow setContentView:connectionView];
    [desktopWindow setLevel:(kCGDesktopWindowLevel)];
    [desktopWindow setFrame:allScreensFrame display:YES];
    [desktopWindow orderFront:nil];
  }

	[self setupTimerAndHost];
}

- (void)setupTimerAndHost
{
	[checkingTimer invalidate];
	[checkingTimer autorelease];
	checkingTimer = [[NSTimer scheduledTimerWithTimeInterval:4
													  target:self 
													selector:@selector(check:) 
													userInfo:nil 
													 repeats:YES] retain];
}

- (void)check:(NSTimer *)timer
{
  // do the actual check on a thread to not hog the UI every other second
  [NSThread detachNewThreadSelector:@selector(checkOnThread) toTarget:self withObject:nil];
}

- (void)checkOnThread
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  
  // -o = wait for one packet reply, then exit
	// -t 2 = timeout of 2 secs
	NSArray *args = [NSArray arrayWithObjects:@"-o", @"-t", @"2", @"google.com", nil];
		
	NSTask *ping = [NSTask new];
  [ping setStandardError:[NSFileHandle fileHandleWithNullDevice]];
  [ping setLaunchPath:@"/sbin/ping"];
  [ping setArguments:args];
  [ping launch];
	// block until ping is finished.
	[ping waitUntilExit];
	
  // update UI
	lastCheckSuccessful = ([ping terminationStatus] == 0);
  [connectionView performSelectorOnMainThread:@selector(update:) withObject:self waitUntilDone:NO];
  
  // update dock icon
  if (lastCheckSuccessful)
    [NSApp setApplicationIconImage:[NSImage imageNamed:@"active"]];
  else
    [NSApp setApplicationIconImage:[NSImage imageNamed:@"inactive"]];
  
  [pool release];
}

- (BOOL)lastCheckSuccessful
{
	return lastCheckSuccessful;
}

@end
