//
//  AppDelegate.m
//  TuringMachine
//
//  Created by Mudit Gupta on 1/17/14.
//  Copyright (c) 2014 Mudit Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#include <unistd.h>
@implementation AppDelegate

@synthesize RunCont, RunStep, TextView, PathSet, CurrentStateLabel, PLabel, P1Label, PminusoneLabel, NewStateLabel, SQuintLabel, CheckBoxSpaces, timetaken, WildChar, window, pathSelected, circleLoading, CheckBoxSpeed, CheckBoxInst, counterLabel;
/*Linking
 xib file to the code.
 Synthesizing all buttons, textviews, textboxes, labels, windows, checkboxes*/

int i; /*counter*/
char *wildCharPointer; /*wildCharacter EXTRA FEATURE*/
NSTimer *Timer=nil; /*Timer for animation EXTRA FEATURE*/
int counterVal=-1; /*counter at the bottom EXTRA FEATURE*/
bool error; /*YES or NO for error*/

/*Creates a structure with a Junk Data element (to trash parantheses, commas, etc.)
 And to store all 5 other elements.
 Creates an array or 32768 such elements*/
struct Elements{
    char JunkData;
    int CurrentState, NewState;
    char CurrentSymbol, NewSymbol, NewPointerPosition;
}Store[32768];

char Tape[32768], WildCharCharacterVariable; /*Creates a tape that is 32768 characters long*/

int NumberOfQuints,i=0, Pointer=0, CurrentFunction, EndOfTape, h;
/*Creates variables. Number of quints is to store the total number of quintuplets. 'i' is merely a counter.
 //Pointer is for the location of the pointer. Current Function is Current State. End of Tape is the ending positions of the
 tape. 'h' is a flag variable to check for halt*/

NSString *path=@"NotSet";
/*Creates a pointer to a string, path - and sets it as NotSet initially.*/




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //This is what is to be done when the Application is launched.
    //Disable run continuously and run step buttons
    //All the "extra" feature buttons will be activate only when path is set
    //They will be enabled only once the path has been set
    RunCont.enabled=NO;
    RunStep.enabled=NO;
    CheckBoxSpeed.enabled=NO;
    CheckBoxSpaces.enabled=NO;
    CheckBoxInst.enabled=NO;
    WildChar.enabled=YES;
    
    //Calls function shakeWindow which is to shake the window! EXTRA FEATURE!
    [self shakeWindow];
    
}


/*This function shakes the window in the beginning! Simply a fun feature*/
-(void)shakeWindow{
    float Y = 200;//Sets Y as 200
    static int numberOfShakes = 4;//Sets number of shakes
    static float durationOfShake = 1.0f;//Sets Duration of the whole shake
    static float vigourOfShake = 0.09f;//Sets how far the shake is shaken.
    
    CGRect frame=[window frame];//Gets the frame(ie the origin and size of the window)
    frame.origin.y+=Y;//Sets the origin to +200 so that it doesn;'t go in the bottom
    frame.size.height = 95;//Sets height of the window so that it shows only load file
    frame.size.width = 480;//Sets the width of the window
    [window setFrame:frame display:YES animate:YES];//Animates the window with the frame specified
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];//New variable shakeanimation for shaking the window
    
    CGMutablePathRef shakePath = CGPathCreateMutable();//A graphics function to set the path of the shake
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));//Moves the window throufght the path
    int index;
    for (index = 0; index < numberOfShakes; ++index)
    {
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));//Shakes the window while creating a point in the +ve direction
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));//Shakes the window in the -ve direction
    }
    CGPathCloseSubpath(shakePath);//Closes the path created by CGMutablePathRef
    shakeAnimation.path = shakePath;//Sets the path to shake
    shakeAnimation.duration = durationOfShake;//And the duration of the shake
    
    [window setAnimations:[NSDictionary dictionaryWithObject: shakeAnimation forKey:@"frameOrigin"]];//Tells the setAnimation method that the frameorigin must change values. The frameOrigin is important
    [[window animator] setFrameOrigin:[window frame].origin];//Actual animation starts here.
}


-(void)animation:(NSView*)ThingToFade time:(float)time{// Only for fading purposes. Thingtofade is the NSview, ie, the object's view. eg : LAbel, textbox can be passed through nsview
    [NSAnimationContext beginGrouping]; {//This thing groups the animations togther between two lines : beginGrouping and endGrouping. Everything between these lines is animation.
        [[NSAnimationContext currentContext] setDuration:time];
        [[NSAnimationContext currentContext] setCompletionHandler:^(void) {//This path reverses the animation as first, the control of the begingrouping comes here after it has reached its endgrouping which is the last line of the function.
            // Here comes the code for the reverse animation.
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:time];//Sets the duration of animation
            [[ThingToFade animator] setAlphaValue:1.0f];//Sets Alpha value
            [NSAnimationContext endGrouping];//End grouping
        }];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];//Sets how the animation should go, Here it is ease out
        [ThingToFade.animator setAlphaValue:1];//Sets alpha value of the ThingToFade
        
    } [NSAnimationContext endGrouping];
    
}


/*This function is to read the values from the file into the program*/
-(int) ReadValues
{
    
    int j=0; /*Merely a counter*/
    FILE *file; /*Creates a pointer to a file, and names it file.*/
    const char *charpath=[path UTF8String];
    /*NOTE: The variable "path" is set upon loading a file. It sends that value of "path" to another pointer - charpath.*/
    file = fopen(charpath,"rb"); /*The file is opened, in rb (read binary) format*/
    
    
    /* This is to take in the data in the given format.*/
    if(file)
    {
        fscanf (file, "%d", &NumberOfQuints)    ; //To take in the number of quintuplets
        
        for(int i=0; i<NumberOfQuints; i++)
        {
            Store[i].JunkData=getc(file); //Takes in line break
            Store[i].JunkData=getc(file); //Takes in (
            fscanf (file, "%d", &Store[i].CurrentState); //Takes in current state
            
            Store[i].JunkData=getc(file); //Takes in ,
            Store[i].CurrentSymbol=getc(file);//Takes in current symbol
            Store[i].JunkData=getc(file); //takes in ,
            fscanf (file, "%d", &Store[i].NewState); //Takes in New state
            Store[i].JunkData=getc(file);//Takes in ,
            Store[i].NewSymbol=getc(file);//Takes in new symbol
            Store[i].JunkData=getc(file);//Takes in ,
            Store[i].NewPointerPosition=getc(file);//Takes in new pointer position (LHR)
            Store[i].JunkData=getc(file); //Takes in )
        }
        
        
        Store[j].JunkData=getc(file); //Takes in line break
        Store[j].JunkData=getc(file);//Takes in !
        Store[j].JunkData=getc(file);//Takes in <
        Tape[0]=getc(file);//Takes in the first element of the tape
        if(Tape[0]==' ')
            Tape[0]='_';
        Store[j].JunkData=getc(file);//Takes in >
        
        
        //To take in the rest of the tape.
        for(j=1; ;j++)
        {
            Tape[j]=getc(file);
            
            if(Tape[j]=='\n') //To ignore line breaks
                j--;
            
            if(Tape[j]==' ') //To take in spaces as underscores
                Tape[j]='_';
            
            if(Tape[j]=='!')
            {
                Tape[j]='\0'; //To end the tape
                break;
            }
        }
        
        fclose(file);
        
        
        
        NumberOfQuints--; //Since Array starts from 0, we use -- to decrease its value by one
        
    }
    
    CurrentFunction=Store[0].CurrentState; //Take in the first state (and store it in the variable CurrentFunction)
    //This is IN CASE the initial state is not 0
    
    return j; //Return the number of elements in the tape (and store it as "end of tape")
    //NOTE: j is the counter used to take in the tape. It is initialized outside the loop so as to retain the value
}


/*This function is to move the pointer either R, L, or halt. It also takes care of the "infinitely long tape" issue.*/
-(void) MovePointer
{
    if(Store[i].NewPointerPosition=='R'||Store[i].NewPointerPosition=='r') //If it is R, then move the pointer right.
    {
        if(Pointer==EndOfTape) //If the pointer is already at end of tape, then increase the end of the tape
        {
            EndOfTape++;
            Tape[EndOfTape]='_';
        }
        Pointer++;
    }
    
    
    else if(Store[i].NewPointerPosition=='L'||Store[i].NewPointerPosition=='l') //If it is L, then move the pointer left.
    {
        if(Pointer==0) //If pointer is at start, then increase the end of tape, and shift everything to one point ahead. Then decrease pointer
        {
            EndOfTape++;
            for(int j=EndOfTape; j>0; j--)
            {
                Tape[j]=Tape[j-1]; //Shift all elements
                
            }
            Tape[Pointer]='_';
            Pointer++;
        }
        Pointer--;
    }
    
    
    else if(Store[i].NewPointerPosition=='H'||Store[i].NewPointerPosition=='h') //If it is H, increase variable 'h'. 'h' is used to disable buttons and terminate the program
    {
        h++; //Flag
        return;
    }
    
}


/*This function makes sure that at any given instance, there is only 1 space at the end and beginning
 NOTE: EXTRA FEATURE #1*/
-(void) CheckEnding
{
    if(Tape[EndOfTape]=='_'&&Tape[EndOfTape-1]=='_') //If the ending has 2 spaces (basically last and second to last both are blanks, then delete one of the blanks!)
    {
        Tape[EndOfTape]='\0';
        EndOfTape--;
    }
    
    else if(Tape[0]=='_'&&Tape[1]=='_') //If the first 2 Tape characters are empty spaces, delete one of them.
    {
        for(int i=0; i<EndOfTape; i++)
            Tape[i]=Tape[i+1];
        Tape[EndOfTape]='\0';
        
        EndOfTape--;
    }
    
    
}


/*This function is to find the quintuplet to be executed. Prefer to use "Fx" in place of quintuplet.*/
-(void) FindFxToExecute
{
    
    if(wildCharPointer==NULL) //ONLY IF there is no wild char. Extra feature!
    {
        //NOTE "i" is a counter variable defined globally
        for(;i<=NumberOfQuints;i++) //To get the line in the DD array that needs to be executed
            
            
            
        {
            if (Tape[Pointer]==Store[i].CurrentSymbol&&Store[i].CurrentState==CurrentFunction) //i will be used after breaking out once the conditions are met
            {
                break;
            }
        }
        
        if (!(Tape[Pointer]==Store[i].CurrentSymbol&&Store[i].CurrentState==CurrentFunction)) //If no value is found, flag and halt
        {
            
            h++; //'h' is used to end the program
            error=YES; //Since nothing is found, there is an error! This bool is checked in execute function and TriggerExecute function
            
            
        }
    }
    
    
    //If wild char exists, stop if current function and wild char (in symbol) both are found
    else
    {
        int adjustment=0;
        {
            //NOTE "i" is a counter variable defined globally
            for(;i<=NumberOfQuints;i++) //To get the line in the DD array that needs to be executed
                
                
                
            {
                if ((Tape[Pointer]==Store[i].CurrentSymbol||Store[i].CurrentSymbol==WildCharCharacterVariable)&&Store[i].CurrentState==CurrentFunction) //i will be used after breaking out once the conditions are met
                    //will execute if either current symbol is found OR wild char is found at the current state rule
                {
                    break;
                }
            }
            
            
            /*This is necessary to counter a scenario where two quintuplets for state X exist. Suppose the quintuplet that appears first contains the wild character, and the second quintuplet contains the actual symbol under the pointer head. In this case, the loop MUST run again to determine whether adjustments need to be made. It is redundant but it is the simplest way (according to me!)*/
            if(Store[i].CurrentSymbol==WildCharCharacterVariable)
            {
                for(adjustment=NumberOfQuints; adjustment>i; adjustment--)
                {
                    if(Tape[Pointer]==Store[adjustment].CurrentSymbol&&Store[adjustment].CurrentState==CurrentFunction)
                    {
                        i=adjustment;
                    }
                }
            }
            
            if (!(Tape[Pointer]==Store[i].CurrentSymbol||Store[i].CurrentSymbol==WildCharCharacterVariable)&&Store[i].CurrentState==CurrentFunction) //If no value is found, flag and halt
            {
                h++; //'h' is used to end the program
                error=YES; //Since nothing is found, there is an error! This bool is checked in execute function and TriggerExecute function
                
            }
        }
        
    }
    
}


/*This function merely sets all labels and is self explanatory*/
-(void) Print
{
    
   
    
    
    //Blurs the labels out - if the label values are going to change
    if([NSString stringWithFormat:@"%d",Store[i].CurrentState]!=CurrentStateLabel.stringValue)
        CurrentStateLabel.alphaValue = 0;
    if([NSString stringWithFormat:@"%d",Store[i].NewState]!=NewStateLabel.stringValue)
        NewStateLabel.alphaValue = 0;
    if ([NSString stringWithFormat:@"(%d,%c,%d,%c,%c)",Store[i].CurrentState,Store[i].CurrentSymbol, Store[i].NewState, Store[i].NewSymbol, Store[i].NewPointerPosition]!=SQuintLabel.stringValue)
        SQuintLabel.alphaValue = 0;
    
    /*Now brings them back using the animation function created earlier*/
    [self animation:PLabel time:0.1];
    [self animation:P1Label time:0.1];
    [self animation:PminusoneLabel time:0.1];
    [self animation:CurrentStateLabel time:0.1];
    [self animation:NewStateLabel time:0.1];
    [self animation:SQuintLabel time:0.1];
    
    
    
    
    [CurrentStateLabel setStringValue:[NSString stringWithFormat:@"%d",Store[i].CurrentState]];//Print the current state label
    [NewStateLabel setStringValue:[NSString stringWithFormat:@"%d",Store[i].NewState]];//Print the new state label
    
    [SQuintLabel setStringValue:[NSString stringWithFormat:@"(%d,%c,%d,%c,%c)",Store[i].CurrentState,Store[i].CurrentSymbol, Store[i].NewState, Store[i].NewSymbol, Store[i].NewPointerPosition]]; //Print the quintuplet
    
    [PLabel setStringValue:[NSString stringWithFormat:@"%c",Tape[Pointer]]];//Print the pointer
    
    
    /*this entire block is to print 20 characters before the pointer*/
    NSString* Pminusone=@"";
    for(int i=Pointer-20; i<Pointer; i++)
    {
        Pminusone = [Pminusone stringByAppendingString:[NSString stringWithFormat:@"%c",Tape[i]]];
    }
    [PminusoneLabel setStringValue:[NSString stringWithFormat:@"%@",Pminusone]];
    
    
    /*this entire block is to print 15 characters after the pointer*/
    NSString* P1=@"";
    for(int i=Pointer+1; i<Pointer+20; i++)
    {
        P1 = [P1 stringByAppendingString:[NSString stringWithFormat:@"%c",Tape[i]]];
    }
    [P1Label setStringValue:[NSString stringWithFormat:@"%@",P1]];
    
    //NOTE: THE DOTS IN THE MAIN LAYOUT FILE INDICATE THAT BEYOND 20+ or - CHARACTERS, THERE MAY OR MAY NOT BE CHARACTERS IN THE TAPE
    //THE REQUIREMENTS SAY : Display a small number of characters before and after the pointer.
    //The small number is 20. Can easily be changed by changing the loop conditions
    
    
    counterLabel.stringValue=[NSString stringWithFormat:@"%i steps",++counterVal]; //update the counter val, and print (at the bottom of the layout, next to the loader circle
    
}

/*This functions act as the main function. It calls all other functions in the order they are required.*/
-(void) Execute:(int) num;
{
    
    for (int z=0;z<num;z++) //z is a counter. this loop has been created just to keep an option of doing multiple steps open
    {
        
        i=0; //Set counter 'i' = 0
        [self FindFxToExecute]; //Find the quintuplet to execute
        
        
        if(error==NO) //ONLY IF THERE IS NO ERROR COMPUTE THE REMIANING LINES!
        {
            /*update the tape[pointer] only if there IS a wild character, and if the NEW SYMBOL of current quintuplet is NOT the wild character*/
            if((!(wildCharPointer==NULL))&&(!((Store[i].NewSymbol==WildCharCharacterVariable))))
            {
                Tape[Pointer]=Store[i].NewSymbol;
            }
            
            //Otherwise if there is no wild character, always update tape[pointer]
            else if(wildCharPointer==NULL)
                Tape[Pointer]=Store[i].NewSymbol; //Once quintuplet has been found, change the value of the pointer under the tape
            
            CurrentFunction=Store[i].NewState;//And change the value of the "current function" to the one in the current quituplet
            
            
            [self MovePointer]; //Move Pointer function is called
            
            
            
            //If the Checkbox for (deleting extra spaces is ticked, then delete the spaces in the beginning and the end as the program executes! EXTRA FEATURE!
            if(CheckBoxSpaces.state==YES){
                [self CheckEnding];}
            
            //Update all the labels
            //This line is crucial because it is what connects the code to the user!
            
            [self Print];
            
            
        }
        //NOTE: if error == YES, once control moves back to the TriggerExecute, it will be handled there!
        
    }
    
    
}


/*This functions triggers (calls) the execute function*/
-(void)TriggerExecute{
    if(h==0) //Checks the flag. If NOT halted
    {
        NSTimeInterval start = CACurrentMediaTime();
        //For calculating execution time (begin) (EXTRA FEATURE)
        
        
        [self Execute:(1)]; //Execute once (call execute)
        
        
        /*For calculating execution time. end time, difference, (extra feature #1)*/
        NSTimeInterval end = CACurrentMediaTime();
        NSTimeInterval delta = end - start;
        timetaken.alphaValue=0; //Animation! EXTRA FEATURE
        [self animation:timetaken time:0.000001]; //Animation! EXTRA FEATURE.
        timetaken.stringValue = [NSString stringWithFormat:@"1. Execution took %fs.", delta];
        
    }
    
    else//If halted
    {
        [Timer invalidate]; //To stop the timer (release it)
        Timer=nil;//sets the timer to nil after releasing it
        [circleLoading stopAnimation:nil]; //stops the animation of the circle on the bottom right
        RunCont.Enabled=NO; //Disable buttons
        RunStep.Enabled=NO;
        //Print halt on the current state label
        [CurrentStateLabel setStringValue:[NSString stringWithFormat:@"Halted"]];//Change the label to halted.
        if(error==YES)//If there was an error, then use the 3 labels to print a message for the user
        {
            [CurrentStateLabel setStringValue:[NSString stringWithFormat:@"ERROR! No rule"]];
            [NewStateLabel setStringValue:[NSString stringWithFormat:@"for \"%c\" in state", Tape[Pointer]]];
            [SQuintLabel setStringValue:[NSString stringWithFormat:@"%d. Load the correct file!", CurrentFunction]];
        }
    }
    
}

/*What happens when Run Continuously is pressed*/
-(IBAction)RunContIsPressed:(id)sender
{
    RunCont.Enabled=NO; //Disable the run continuously button.
    
    [circleLoading startAnimation:nil]; //Start the circle loader animation
    
    if(CheckBoxInst.state==YES) //EXTRA FEATURE. If instant is checked, print nothing live; run a loop; compute; and then print. If error is found, triggerExecute function to take care of it.
    {
        while(h==0)
            [self Execute:(1)];
        if(error==YES)
            [self TriggerExecute];
        
    }
    
    //NOTE IF BOTH INSTANT AND INSANE SPEED ARE CHECKED, INSTANT IS GIVEN PRIORITY
    
    
    else if(CheckBoxSpeed.state==YES) //If Insane speed is checked
    {
        Timer =[NSTimer scheduledTimerWithTimeInterval:0.000000001L target:self selector:@selector(TriggerExecute) userInfo:nil repeats:YES];//Mad speed (repeat interval every 0.000000001 seconds.
        
    }
    else //Otherwise just run at normal continuous speed
    {
        Timer =[NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(TriggerExecute) userInfo:nil repeats:YES];//Reasonable speed (repeat interval every 0.05 seconds.
    }
    
    
    
    /*once run continuously has been pressed, none of these values can be changed, obviously.*/
    CheckBoxSpaces.enabled=NO;
    CheckBoxSpeed.enabled=NO;
    CheckBoxInst.enabled=NO;
    WildChar.enabled=NO;
    [self TriggerExecute]; //At the end, call TriggerExecute to deal with halt/error cases.
}


/*What happens when Run Step is pressed*/
-(IBAction)RunStepIsPressed:(id)sender
{
    [Timer invalidate]; //release the timer
    Timer=nil; //set it to nil after invalidating
    
    /*If Run cont is pressed, Runcont is disabled. Then if Run step is pressed, Run cont must be enabled again
     Similarly for the checkboxes (EXTRA FEATUREs)*/
    RunCont.Enabled=YES;
    CheckBoxSpeed.Enabled=YES;
    CheckBoxInst.Enabled=YES;
    [circleLoading startAnimation:nil]; //Start Animating the loader circle
    
    
    [self TriggerExecute]; //Call Trigger Execute function, which will call execute, which will run 1 step.
    
    [circleLoading stopAnimation:nil];//Stop animating the Loader circle
    
    
    //Once the button has been pressed, the states of these buttons cannot be changed
    CheckBoxSpaces.enabled=NO;
    WildChar.enabled=NO;
    
    
}


/*When the path is set, default all variables, the structure elements, enable all buttons, overwrite text view
NOTE: CHANGING THE PATH IS ESSENTIALLY THE SAME AS RESETTING
Changing the path enables the RunCont and RunStep buttons which are responsible for triggering everything*/
- (IBAction)Pathset:(id)sender
{
    //This is basically to create a re-loading sensation
    CGRect frame=[window frame]; //Get the window
    frame.size.height = 95; //Hide the bottom part (apart from the load file)
    frame.size.width = 480;
    [window setFrame:frame display:YES animate:YES]; //animate the window by all means
    
    for(int i=0; i<32768; i++) //Reset the structure
    {
        Store[i].CurrentState='\0';
        Store[i].NewState='\0';
        Store[i].CurrentSymbol='\0';
        Store[i].NewSymbol='\0';
        Store[i].NewPointerPosition='\0';
        Tape[i]='\0';
    }
    counterVal=-1; //Set counter to -1 (because setting the path makes it 0)
    [pathSelected setURL:PathSet.URL]; //Read the path selected
    [circleLoading startAnimation:nil]; //Start animating the circle (while the file is loaded)
    i=0, Pointer=0; //Reset all variables
    
    frame.origin.y=177;
    frame.size.height = 500; //now load the entire window
    frame.size.width = 480;
    [window setFrame:frame display:YES animate:YES]; //Animate the window by all means
    RunCont.Enabled=YES; //Enable buttons
    RunStep.Enabled=YES;
    error=NO; //No error by deafult
    NumberOfQuints=0; //Reset all variables
    CurrentFunction=0;
    EndOfTape=0;
    h=0;
    
    
    
    [Timer invalidate]; //release the timer
    Timer=nil; //set the timer to nil after invalidating
    path=PathSet.URL.path; //Set the path selected to variable path
    EndOfTape = [self ReadValues]-1; //Set end of tape (as returned from Read Values function)
    
    /*Load the contents of the file into the Textview*/
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [TextView setString:contents];
    
    CheckBoxSpeed.enabled=YES; //Enable extra features
    CheckBoxSpaces.enabled=YES;
    CheckBoxInst.enabled=YES;
    WildChar.enabled=YES;
    
    /*Everytime the path is changed, the wild character is reset.*/
    wildCharPointer=NULL;
    WildCharCharacterVariable='\0';
    WildChar.stringValue=@"";
    
    [self Print]; //Print the tape
    [circleLoading stopAnimation:nil]; //Once everything is done (in memory), stop animation of the loader
    
}

/*What happens if a user enters a wild character and presses enter*/
- (IBAction)wildCharSet:(id)sender
{
    
    wildCharPointer = [WildChar.stringValue UTF8String]; //A pointer points to the string value (which is UTF8String format)
    WildCharCharacterVariable=*wildCharPointer; //The pointer is type casted to a single character. ONLY THE FIRST CHARACTER IS TAKEN. Entering "ab" and "a" will produce the same results.
}
@end
