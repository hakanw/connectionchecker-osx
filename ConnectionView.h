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

#import <Cocoa/Cocoa.h>

@class AppController;

@interface NSObject (ConnectionViewDelegate)
- (BOOL)lastCheckSuccessful;
@end

@interface ConnectionView : NSView
{
  id delegate;
  BOOL isBeforeFirstCheck;
}
- (void)update:(id)sender;
- (void)setDelegate:(id)delegate;
@end
