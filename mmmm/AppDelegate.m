//
//  AppDelegate.m
//  TuringMachine
//
//  Created by Mudit Gupta on 1/17/14.
//  Copyright (c) 2014 Mudit Gupta. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize LoadFile, RunCont, RunStep;//, TapeLabel;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
}





struct Elements{
   char JunkData;
    int CurrentState, NewState;
    char CurrentSymbol, NewSymbol, NewPointerPosition;
}Store[32000];

char Tape[32000];
int Occurances[32000][2];
int NumberOfFunctions;
int i=0, Pointer=0, CurrentFunction;
int StartOfTape=0, EndOfTape;




-(int) ReadValues
{
    int j=0;
    FILE *file;
    file = fopen("/Users/muditgupta/Desktop/;/;/hello.txt","rb");
    
    if(file)
    {
        fscanf (file, "%d", &NumberOfFunctions)    ;
        
        for(int i=0; i<NumberOfFunctions; i++)
        {
            Store[i].JunkData=getc(file);
            Store[i].JunkData=getc(file);
            fscanf (file, "%d", &Store[i].CurrentState);
            
            Store[i].JunkData=getc(file);
            Store[i].CurrentSymbol=getc(file);
            Store[i].JunkData=getc(file);
            fscanf (file, "%d", &Store[i].NewState);
            Store[i].JunkData=getc(file);
            Store[i].NewSymbol=getc(file);
            Store[i].JunkData=getc(file);
            Store[i].NewPointerPosition=getc(file);
            Store[i].JunkData=getc(file);
        }
        
        
        Store[j].JunkData=getc(file);
        Store[j].JunkData=getc(file);
        Store[j].JunkData=getc(file);
        Tape[0]=getc(file);
        Store[j].JunkData=getc(file);
        
        
        
        for(j=1; ;j++)
        {
            Tape[j]=getc(file);
            if(Tape[j]=='!')
            {
                Tape[j]='\0';
                break;
            }
        }
        
        NumberOfFunctions--;
        
    }
    
    return j;
}

-(void) MovePointer
{
    if(Store[i].NewPointerPosition=='R') //If it is R, then move the pointer right. If we need to go beyond the end... then do it!
    {
        if(Pointer==EndOfTape)
        {
            EndOfTape++;
            Tape[EndOfTape]='_';
        }
        Pointer++;
    }
    
    
    else if(Store[i].NewPointerPosition=='L') //If it is L, then move the pointer left. If we must change the starting point, do it, and shift the elements to the right!
    {
        if(Pointer==StartOfTape)
        {
            EndOfTape++;
            for(int j=EndOfTape; j>0; j--)
                Tape[i]=Tape[i-1];
        }
        Pointer--;
    }
    
    
    else if(Store[i].NewPointerPosition=='H') //If it is H, terminate.
    {
        
        exit(0);
    }
    
}


-(void) CheckEnding
{
    if(Tape[EndOfTape]=='_'&&Tape[EndOfTape-1]=='_') //If the ending has 2 spaces (basically last and second to last both are blanks, then delete one of the blanks!)
    {
        Tape[EndOfTape]='\0';
        EndOfTape--;
    }
}

-(void) FindFxToExecute
{
    
    for(;;i++) //To get the line in the DD array that needs to be executed
    {
        if (Tape[Pointer]==Store[i].CurrentSymbol&&Store[i].CurrentState==CurrentFunction)
        {
            break;
        }
    }
}

-(void) Print
{
  NSLog([NSString stringWithFormat:@"%s", Tape]);
    //[TapeLabel setValue:[NSString stringWithFormat:@"%s",Tape]];
    
    
    
}



-(void) Execute:(int) num;
{
    for (int z=0;z<num;z++)
    {
        //i=ReturnI(CurrentFunction); //Get the first occurance using a function
        i=0;
        [self CheckEnding];
       
        
        
        [self FindFxToExecute];
        Tape[Pointer]=Store[i].NewSymbol; //Changing the values in the strip
        CurrentFunction=Store[i].NewState; //Changing the value of the function variable (-48 because character to int)
       [self MovePointer];
        [self Print];
    }
    
}



-(IBAction)LoadFileButtonIsPressed:(id)sender
{
    EndOfTape = [self ReadValues]-1;

}


-(IBAction)RunContIsPressed:(id)sender
{
    [self Execute:(INFINITY)];
}

-(IBAction)RunStepIsPressed:(id)sender
{
    [self Execute:(1)];
    
}

@end
