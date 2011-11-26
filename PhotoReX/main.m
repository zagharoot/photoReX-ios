//
//  main.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
 
    @autoreleasepool {
        //This is the first entry to the application. mark the time
        [AppDelegate setApplicationStartTime:[[NSDate date] timeIntervalSince1970]]; 

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
