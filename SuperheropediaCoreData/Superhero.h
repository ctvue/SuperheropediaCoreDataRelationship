//
//  Superhero.h
//  SuperheropediaCoreData
//
//  Created by Chee Vue on 6/3/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;
//@class NSManagedObject;

@interface Superhero : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * textDescription;
@property (nonatomic, retain) NSSet *teams;
@end

@interface Superhero (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(NSManagedObject *)value;
- (void)removeTeamsObject:(NSManagedObject *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
