//
//  Superhero.h
//  SuperheropediaCoreData
//
//  Created by Ben Bueltmann on 3/25/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetiredSuperhero : NSObject
@property NSString *name;
@property NSString *textDescription;
@property NSString *urlString;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(void)getImageWithCompletion:(void(^)(NSData *))complete;
+(void)retrieveSuperheroesWithCompletion:(void(^)(NSArray*))complete;

@end
