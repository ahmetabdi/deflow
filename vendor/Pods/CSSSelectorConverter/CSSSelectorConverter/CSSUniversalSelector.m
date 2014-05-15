//
//  CSSUniversalSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSUniversalSelector.h"
#import "CoreParse.h"

@implementation CSSUniversalSelector

- (id)initWithSyntaxTree:(CPSyntaxTree *)syntaxTree {
    return [self init];
}

- (id)init {
    self = [super init];
    self.name = @"*";
    return self;
}
    
+(instancetype) selector {
    return [self selectorWithName:@"*"];
}

-(NSString*) description {
    return @"<UniversalSelector>";
}

@end
