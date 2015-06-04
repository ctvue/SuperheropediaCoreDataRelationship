//
//  Team.h
//  SuperheropediaCoreData
//
//  Created by Chee Vue on 6/3/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Superhero;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * textDescription;
@property (nonatomic, retain) NSSet *superheroes;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addSuperheroesObject:(Superhero *)value;
- (void)removeSuperheroesObject:(Superhero *)value;
- (void)addSuperheroes:(NSSet *)values;
- (void)removeSuperheroes:(NSSet *)values;

@end
