#import <XCTest/XCTest.h>

#import "NOAPIMapper.h"
#import "Repository.h"


@interface NOAPIControllerTests : XCTestCase

@property (nonatomic) NOAPIMapper *mapper;

@end


@implementation NOAPIControllerTests

- (void)setUp {
    [super setUp];
	
	NSDictionary *map = @{
			NSStringFromClass([Repository class]): @{
				@"title": @{
					@"key": NSStringFromSelector(@selector(title)),
					@"type": NSStringFromClass([NSString class]),
				},
				
				@"private": @{
					@"key": NSStringFromSelector(@selector(privateRepo)),
					@"type": NSStringFromClass([NSNumber class]),
					@"validators": @[NSStringFromSelector(@selector(validateNumberToBeBool:))],
				},
				
				@"forksCount": @{
					@"key": NSStringFromSelector(@selector(forksCount)),
					@"type": NSStringFromClass([NSNumber class]),
					@"validators": @[
							NSStringFromSelector(@selector(validateNumberToBeInteger:)),
							NSStringFromSelector(@selector(validateNumberToBeNotNegative:)),
						]
				},				
			}
		};
	
	self.mapper = [[NOAPIMapper alloc] initWithFieldsMap:map transformer:self validator:self];
	
}

- (NSNumber *)validateNumberToBeBool:(NSNumber *)number {
	if (number == nil) {
		return @YES;
	}

	NSString *type = NSStringFromClass([number class]);
	NSString *expectedType = NSStringFromClass([@(number.boolValue) class]);
	
	BOOL correctType = [type isEqualToString:expectedType];
	return @(correctType);
}

- (NSNumber *)validateNumberToBeInteger:(NSNumber *)number {
	if (number == nil) {
		return @YES;
	}

	CFNumberType type = CFNumberGetType((CFNumberRef)number);
	
	BOOL correctType =
		type == kCFNumberSInt8Type ||
		type == kCFNumberSInt16Type ||
		type == kCFNumberSInt32Type ||
		type == kCFNumberSInt64Type ||
		type == kCFNumberShortType ||
		type == kCFNumberIntType ||
		type == kCFNumberLongType ||
		type == kCFNumberLongLongType ||
		type == kCFNumberNSIntegerType;
	
	return @(correctType);
}

- (NSNumber *)validateNumberToBeNotNegative:(NSNumber *)number {
	if (number == nil) {
		return @YES;
	}
	
	BOOL correctValue = number.integerValue >= 0;
	
	return @(correctValue);
}

- (void)testStringPropertyPositiveCase {
	NSString *title = @"My shiny repo";

	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"title": title
		}];

	XCTAssertTrue([repository.title isEqualToString:title], @"Title expected to be equal '%@'.", title);
}

- (void)testStringPropertyToBeNil {
	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"title": [NSNull null]
		}];

	XCTAssertNil(repository.title, @"Title expected to be nil.");
}

- (void)testNumberPropertyToBeIncorrectTypeCase1 {
	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"private": @(1)
		}];

	XCTAssertEqual(repository.privateRepo, NO, @"PrivateRepo expected to be boolean.");
}

- (void)testBoolNumberPropertyPositiveCase1 {
	BOOL privateRepo = YES;

	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"private": @(privateRepo)
		}];

	XCTAssertEqual(repository.privateRepo, privateRepo, @"PrivateRepo expected to be equal '%@'.", @(privateRepo));
}

- (void)testBoolNumberPropertyPositiveCase2 {
	BOOL privateRepo = NO;

	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"private": @(privateRepo)
		}];

	XCTAssertEqual(repository.privateRepo, privateRepo, @"PrivateRepo expected to be equal '%@'.", @(privateRepo));
}

- (void)testNumberPropertyToBeIncorrectTypeCase2 {
	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"forksCount": @(4.2)
		}];

	XCTAssertNil(repository.forksCount, @"ForksCount expected to be not-negative integer.");
}

- (void)testNumberPropertyToBeIncorrectValue {
	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"forksCount": @(-42)
		}];

	XCTAssertNil(repository.forksCount, @"ForksCount expected to be not-negative integer.");
}

- (void)testNumberPropertyToBePositiveCase1 {
	NSInteger forksCount = 42;

	Repository *repository = [self.mapper objectOfType:[Repository class] fromDictionary:@{
			@"forksCount": @(forksCount)
		}];

	XCTAssertEqual(repository.forksCount.integerValue, forksCount,
		@"ForksCount expected to be equal '%@'.", @(forksCount));
}

@end
