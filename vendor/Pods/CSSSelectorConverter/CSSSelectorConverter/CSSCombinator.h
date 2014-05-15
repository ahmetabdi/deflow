//
//  CSSCombinator.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"
#import "CPParser.h"

typedef NS_ENUM(NSInteger, CSSCombinatorType) {
    CSSCombinatorTypeNone = 0,
    CSSCombinatorTypeDescendant,
    CSSCombinatorTypeAdjacent,
    CSSCombinatorTypeGeneralSibling
};

@interface CSSCombinator : CSSBaseSelector <CPParseResult>

@property (nonatomic, assign) CSSCombinatorType type;

+(CSSCombinator*) noneCombinator;

@end
