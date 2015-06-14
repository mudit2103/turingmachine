//
//  AppDelegate.h
//  mmmm
//
//  Created by Mudit Gupta on 1/18/14.
//  Copyright (c) 2014 Mudit Gupta. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;


@property (weak, nonatomic) IBOutlet NSButton *LoadFile;
- (IBAction)LoadFileButtonIsPressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSButton *RunStep;
- (IBAction)RunStepIsPressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSButton *RunCont;
- (IBAction)RunContIsPressed:(id)sender;

//@property (weak, nonatomic) IBOutlet NSView *TapeLabel;


@end
