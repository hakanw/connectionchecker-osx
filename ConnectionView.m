/* -*- Mode: Objective-C; tab-width: 2; c-basic-offset: 2 -*-  */
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

#import "ConnectionView.h"
#import "AppController.h"

@implementation ConnectionView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		isBeforeFirstCheck = YES;
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	NSColor *theColor;
	if (isBeforeFirstCheck)
		theColor = [NSColor grayColor];
	else {
		BOOL success = [delegate lastCheckSuccessful];
		theColor = success ? [NSColor greenColor] : [NSColor redColor];
	}
	[theColor setFill];
	[NSBezierPath fillRect:[self bounds]];
}

- (void)update:(id)sender
{
	isBeforeFirstCheck = NO;
	[self setNeedsDisplay:YES];
}

- (void)setDelegate:(id)newDelegate
{
	delegate = newDelegate;
}

@end
