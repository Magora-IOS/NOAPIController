#import <Foundation/Foundation.h>


@interface Repository : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSDate *creation;
@property (nonatomic) NSDate *lastUpdate;
@property (nonatomic) NSURL *homePage;
@property (nonatomic) BOOL privateRepo;
@property (nonatomic) NSNumber *forksCount;

@end
