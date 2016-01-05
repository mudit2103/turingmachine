//
//  AppDelegate.h
//  mmmm
//
//  Created by Mudit Gupta on 1/18/14.
//  Copyright (c) 2014 Mudit Gupta. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>




@property (weak) IBOutlet NSPathControl *pathSelected; //Path selector



- (IBAction)wildCharSet:(id)sender; //Action associated with wild character text feild

@property (assign) IBOutlet NSWindow *window; //Main window



@property (weak, nonatomic) IBOutlet NSButton *RunStep; //Run step button
- (IBAction)RunStepIsPressed:(id)sender; //Action when run step is pressed
@property (weak, nonatomic) IBOutlet NSButton *RunCont; //Run continuous button
- (IBAction)RunContIsPressed:(id)sender; //Action when run continuous is pressed

@property(weak, nonatomic) IBOutlet NSButton *CheckBoxSpaces; //Check box for "delete extra spaces" EXTRA FEATURE
@property(weak, nonatomic) IBOutlet NSButton *CheckBoxSpeed;//Check box for "super speed" EXTRA FEATURE

@property(weak, nonatomic) IBOutlet NSButton *CheckBoxInst; //Check box for "instant computation" EXTRA FEATURE




@property (unsafe_unretained) IBOutlet NSTextView *TextView; //Textview for the contents of the file


@property (weak) IBOutlet NSTextField *CurrentStateLabel; //Label to print the current state
@property (weak) IBOutlet NSTextField *NewStateLabel;//Label to print the new state
@property (weak) IBOutlet NSTextField *SQuintLabel;//Label to print successful quintuplet

@property (weak) IBOutlet NSTextField *PLabel; //Label to print what is under the pointer
@property (weak) IBOutlet NSTextField *P1Label; //Label to print what is after the pointer

@property (weak) IBOutlet NSTextField *PminusoneLabel; //Label to print what is before the pointer


@property (weak) IBOutlet NSTextField *timetaken;//Execution time label

@property (weak) IBOutlet NSTextField *counterLabel; //Counter label

@property (weak) IBOutlet NSTextField *WildChar;//Textfeild to take in wild char

@property (nonatomic, retain) IBOutlet NSPathControl *PathSet; //Path setter

- (IBAction)Pathset:(id)sender;//Action for what to do after setting path





@property (weak) IBOutlet NSProgressIndicator *circleLoading; //Progress bar indicator


@end
