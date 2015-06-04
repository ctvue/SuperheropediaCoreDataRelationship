//
//  Superhero.m
//  SuperheropediaCoreData
//
//  Created by Ben Bueltmann on 3/25/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RetiredSuperhero.h"

@implementation RetiredSuperhero

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.textDescription = [dictionary objectForKey:@"description"];
        self.urlString = [dictionary objectForKey:@"avatar_url"];
    }
    return self;
}

-(void)getImageWithCompletion:(void (^)(NSData *))complete{
    NSURL *url = [NSURL URLWithString:self.urlString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        complete(data);
    }];
}

+(void)retrieveSuperheroesWithCompletion:(void (^)(NSArray *))complete{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/superheroes.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *superheroes = [NSMutableArray arrayWithCapacity:results.count];
        for (NSDictionary *dict in results) {
            [superheroes addObject:[[RetiredSuperhero alloc]initWithDictionary:dict]];
        }
        complete([NSArray arrayWithArray:superheroes]);
    }];
}
@end
