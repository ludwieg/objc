//
//  LudwiegTests.m
//  LudwiegTests
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Ludwieg/Ludwieg.h>
#import "DeallocationExpectationFulfiller.h"
#import "NSObject+DeallocationExpectationFulfiller.h"

@interface LUDCustomType : NSObject<LUDSerializable>
@property (nullable, nonatomic, retain) LUDTypeString *fieldV;
@end

@implementation LUDCustomType
+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[
             [LUDTypeAnnotation annotationWithName:@"fieldV" andType:LUDProtocolTypeString],
             ];
}
@end

@interface LUDTestSubOther : NSObject<LUDSerializable>
@property (nullable, nonatomic, retain) LUDTypeString *fieldL;
@end

@implementation LUDTestSubOther
+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[
             [LUDTypeAnnotation annotationWithName:@"fieldL" andType:LUDProtocolTypeString],
             ];
}
@end

@interface LUDTestSub : NSObject<LUDSerializable>
@property (nullable, nonatomic, retain) LUDTypeString *fieldJ;
@property (nullable, nonatomic, retain) LUDTestSubOther *fieldK;
@end

@implementation LUDTestSub
+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[
             [LUDTypeAnnotation annotationWithName:@"fieldJ" andType:LUDProtocolTypeString],
             [LUDTypeAnnotation annotationWithName:@"fieldK" andType:LUDProtocolTypeStruct],
             ];
}
@end

@interface LUDTest : NSObject <LUDSerializablePackage>
@property (nullable, nonatomic, retain) LUDTypeUint8 *fieldA;
@property (nullable, nonatomic, retain) LUDTypeUint32 *fieldB;
@property (nullable, nonatomic, retain) LUDTypeUint64 *fieldC;
@property (nullable, nonatomic, retain) LUDTypeFloat64 *fieldD;
@property (nullable, nonatomic, retain) LUDTypeString *fieldE;
@property (nullable, nonatomic, retain) LUDTypeBlob *fieldF;
@property (nullable, nonatomic, retain) LUDTypeBool *fieldG;
@property (nullable, nonatomic, retain) LUDTypeUUID *fieldH;
@property (nullable, nonatomic, retain) LUDTypeAny *fieldY;
@property (nullable, nonatomic, retain) NSArray<LUDTypeString *> *fieldZ;
@property (nullable, nonatomic, retain) NSArray<LUDCustomType *> *fieldZA;
@property (nullable, nonatomic, retain) LUDTestSub *fieldI;
@end

@implementation LUDTest
+ (uint8_t)ludwiegID { return 0x01; };
+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[
             [LUDTypeAnnotation annotationWithName:@"fieldA" andType:LUDProtocolTypeUint8],
             [LUDTypeAnnotation annotationWithName:@"fieldB" andType:LUDProtocolTypeUint32],
             [LUDTypeAnnotation annotationWithName:@"fieldC" andType:LUDProtocolTypeUint64],
             [LUDTypeAnnotation annotationWithName:@"fieldD" andType:LUDProtocolTypeFloat64],
             [LUDTypeAnnotation annotationWithName:@"fieldE" andType:LUDProtocolTypeString],
             [LUDTypeAnnotation annotationWithName:@"fieldF" andType:LUDProtocolTypeBlob],
             [LUDTypeAnnotation annotationWithName:@"fieldG" andType:LUDProtocolTypeBool],
             [LUDTypeAnnotation annotationWithName:@"fieldH" andType:LUDProtocolTypeUUID],
             [LUDTypeAnnotation annotationWithName:@"fieldY" andType:LUDProtocolTypeAny],
             [LUDTypeAnnotation arrayAnnotationWithName:@"fieldZ" type:LUDProtocolTypeString andArraySize:@"*"],
             [LUDTypeAnnotation arrayAnnotationWithName:@"fieldZA" userType:[LUDCustomType class] andArraySize:@"*"],
             [LUDTypeAnnotation annotationWithName:@"fieldI" andType:LUDProtocolTypeStruct],
             ];
}
@end




@interface LudwiegTests : XCTestCase

@end

@implementation LudwiegTests

- (void)testInlineMemoryLeak {
    @autoreleasepool {
        LUDTypeUint8 *test = LUDUint8(0x10);
        XCTAssert(!test.isEmpty);
        XCTAssert(test.value == 0x10);
        test.deallocFulfiller = [[DeallocationExpectationFulfiller alloc] initWithExpectation:[self expectationWithDescription:@"object was released"]];
        test = nil;
    }
    [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testSerialization {
    LUDTest *test = [[LUDTest alloc] init];
    test.fieldA = LUDUint8(27);
    test.fieldB = LUDUint32(28);
    test.fieldC = LUDUint64(29);
    test.fieldD = LUDFloat64(30.2);
    test.fieldE = LUDString(@"String");
    uint8_t bytes[3] = { 0x27, 0x24, 0x50 };
    test.fieldF = LUDBlob([NSData dataWithBytes:bytes length:3]);
    test.fieldG = LUDBool(YES);
    test.fieldH = LUDUUID(@"3232ee42c2f24baf841318335b4d5640");
    test.fieldY = LUDAny(LUDString(@"Any field retaining a string"));
    test.fieldZ = @[LUDString(@"Robin"), LUDString(@"Tom")];
    {
        LUDTestSub *sub = [[LUDTestSub alloc] init];
        sub.fieldJ = LUDString(@"Structure");
        test.fieldI = sub;

        LUDTestSubOther *other = [[LUDTestSubOther alloc] init];
        other.fieldL = LUDString(@"Other Structure");
        sub.fieldK = other;
    }


    NSError *error;
    NSData *result = [LUDSerializer serializePackage:test withMessageID:0x01 andError:&error];
    XCTAssertNil(error);

    uint8_t expectBytes[155] = {
        0x27, 0x24, 0x50, 0x01, 0x01, 0x01, 0x01, 0x93, 0x04, 0x1B, 0x08, 0x1C,
        0x00, 0x00, 0x00, 0x0C, 0x1D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x10, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3E, 0x40, 0x15, 0x01, 0x06,
        0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x19, 0x01, 0x03, 0x27, 0x24, 0x50,
        0x1C, 0x01, 0x24, 0x32, 0x32, 0xEE, 0x42, 0xC2, 0xF2, 0x4B, 0xAF, 0x84,
        0x13, 0x18, 0x33, 0x5B, 0x4D, 0x56, 0x40, 0x29, 0x01, 0x1F, 0x15, 0x01,
        0x1C, 0x41, 0x6E, 0x79, 0x20, 0x66, 0x69, 0x65, 0x6C, 0x64, 0x20, 0x72,
        0x65, 0x74, 0x61, 0x69, 0x6E, 0x69, 0x6E, 0x67, 0x20, 0x61, 0x20, 0x73,
        0x74, 0x72, 0x69, 0x6E, 0x67, 0x21, 0x01, 0x0C, 0x15, 0x01, 0x02, 0x01,
        0x05, 0x52, 0x6F, 0x62, 0x69, 0x6E, 0x01, 0x03, 0x54, 0x6F, 0x6D, 0x2D,
        0x01, 0x21, 0x15, 0x01, 0x09, 0x53, 0x74, 0x72, 0x75, 0x63, 0x74, 0x75,
        0x72, 0x65, 0x2D, 0x01, 0x12, 0x15, 0x01, 0x0F, 0x4F, 0x74, 0x68, 0x65,
        0x72, 0x20, 0x53, 0x74, 0x72, 0x75, 0x63, 0x74, 0x75, 0x72, 0x65
    };
    NSData *expect = [NSData dataWithBytes:expectBytes length:155];
    XCTAssert([expect isEqualToData:result]);
    NSLog(@"%@", result);
}

- (void)testPerformance {
    [self measureBlock:^{
        LUDTest *test = [[LUDTest alloc] init];
        test.fieldA = LUDUint8(27);
        test.fieldB = LUDUint32(28);
        test.fieldC = LUDUint64(29);
        test.fieldD = LUDFloat64(30.2);
        test.fieldE = LUDString(@"String");
        uint8_t bytes[3] = { 0x27, 0x24, 0x50 };
        test.fieldF = LUDBlob([NSData dataWithBytes:bytes length:3]);
        test.fieldG = LUDBool(YES);
        test.fieldH = LUDUUID(@"3232ee42c2f24baf841318335b4d5640");
        test.fieldY = LUDAny(LUDString(@"Any field retaining a string"));
        test.fieldZ = @[LUDString(@"Robin"), LUDString(@"Tom")];
        {
            LUDTestSub *sub = [[LUDTestSub alloc] init];
            sub.fieldJ = LUDString(@"Structure");
            test.fieldI = sub;

            LUDTestSubOther *other = [[LUDTestSubOther alloc] init];
            other.fieldL = LUDString(@"Other Structure");
            sub.fieldK = other;
        }


        NSError *error;
        [LUDSerializer serializePackage:test withMessageID:0x01 andError:&error];
    }];
}

- (void)testDeserialize {
    uint8_t expectBytes[281] = {
        0x27, 0x24, 0x50, 0x01, 0x01, 0x01, 0x01, 0xae, 0x04, 0x1b, 0x08, 0x1c,
        0x00, 0x00, 0x00, 0x0c, 0x1d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x10, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3e, 0x40, 0x15, 0x01, 0x06,
        0x53, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x19, 0x01, 0x03, 0x27, 0x24, 0x50,
        0x1c, 0x01, 0x24, 0x32, 0x32, 0xee, 0x42, 0xc2, 0xf2, 0x4b, 0xaf, 0x84,
        0x13, 0x18, 0x33, 0x5b, 0x4d, 0x56, 0x40, 0x29, 0x01, 0x1f, 0x15, 0x01,
        0x1c, 0x41, 0x6e, 0x79, 0x20, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x20, 0x72,
        0x65, 0x74, 0x61, 0x69, 0x6e, 0x69, 0x6e, 0x67, 0x20, 0x61, 0x20, 0x73,
        0x74, 0x72, 0x69, 0x6e, 0x67, 0x21, 0x01, 0x0c, 0x15, 0x01, 0x02, 0x01,
        0x05, 0x52, 0x6f, 0x62, 0x69, 0x6e, 0x01, 0x03, 0x54, 0x6f, 0x6d, 0x21,
        0x01, 0x15, 0x2d, 0x01, 0x02, 0x01, 0x08, 0x15, 0x01, 0x05, 0x68, 0x65,
        0x6c, 0x6c, 0x6f, 0x01, 0x09, 0x15, 0x01, 0x06, 0x66, 0x72, 0x69, 0x65,
        0x6e, 0x64, 0x2d, 0x01, 0x21, 0x15, 0x01, 0x09, 0x53, 0x74, 0x72, 0x75,
        0x63, 0x74, 0x75, 0x72, 0x65, 0x2d, 0x01, 0x12, 0x15, 0x01, 0x0f, 0x4f,
        0x74, 0x68, 0x65, 0x72, 0x20, 0x53, 0x74, 0x72, 0x75, 0x63, 0x74, 0x75,
        0x72, 0x65
    };

    [LUDDeserializer registerPackage:[LUDTest class] withIdentifier:0x01];
    LUDDeserializer *d = [LUDDeserializer deserializer];
    LUDMessageMeta *meta;
    id value;
    BOOL ok = NO;
    for(int i = 0; i < 281; i++) {
        if([d read:expectBytes[i] intoMessageMeta:&meta andTarget:&value]) {
            ok = YES;
            break;
        }
    }
    if(!ok) {
        XCTFail("Deserialization failed");
    }
    NSLog(@"%@", value);
}

@end
