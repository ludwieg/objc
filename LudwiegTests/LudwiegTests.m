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
@property (nullable, nonatomic, retain) LUDTypeDouble *fieldD;
@property (nullable, nonatomic, retain) LUDTypeString *fieldE;
@property (nullable, nonatomic, retain) LUDTypeBlob *fieldF;
@property (nullable, nonatomic, retain) LUDTypeBool *fieldG;
@property (nullable, nonatomic, retain) LUDTypeUUID *fieldH;
@property (nullable, nonatomic, retain) LUDTypeAny *fieldY;
@property (nullable, nonatomic, retain) NSArray<LUDTypeString *> *fieldZ;
@property (nullable, nonatomic, retain) NSArray<LUDCustomType *> *fieldZA;
@property (nullable, nonatomic, retain) LUDTestSub *fieldI;
@property (nullable, nonatomic, retain) LUDTypeDynInt *fieldJ;
@end

@implementation LUDTest
+ (uint8_t)ludwiegID { return 0x01; };
+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[
             [LUDTypeAnnotation annotationWithName:@"fieldA" andType:LUDProtocolTypeUint8],
             [LUDTypeAnnotation annotationWithName:@"fieldB" andType:LUDProtocolTypeUint32],
             [LUDTypeAnnotation annotationWithName:@"fieldC" andType:LUDProtocolTypeUint64],
             [LUDTypeAnnotation annotationWithName:@"fieldD" andType:LUDProtocolTypeDouble],
             [LUDTypeAnnotation annotationWithName:@"fieldE" andType:LUDProtocolTypeString],
             [LUDTypeAnnotation annotationWithName:@"fieldF" andType:LUDProtocolTypeBlob],
             [LUDTypeAnnotation annotationWithName:@"fieldG" andType:LUDProtocolTypeBool],
             [LUDTypeAnnotation annotationWithName:@"fieldH" andType:LUDProtocolTypeUUID],
             [LUDTypeAnnotation annotationWithName:@"fieldY" andType:LUDProtocolTypeAny],
             [LUDTypeAnnotation arrayAnnotationWithName:@"fieldZ" type:LUDProtocolTypeString andArraySize:@"*"],
             [LUDTypeAnnotation arrayAnnotationWithName:@"fieldZA" userType:[LUDCustomType class] andArraySize:@"*"],
             [LUDTypeAnnotation annotationWithName:@"fieldI" andType:LUDProtocolTypeStruct],
             [LUDTypeAnnotation annotationWithName:@"fieldJ" andType:LUDProtocolTypeDynInt],
             ];
}
@end

@interface LUDFieldless : NSObject <LUDSerializablePackage>
@end

@implementation LUDFieldless

+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta { return @[]; }
+ (uint8_t)ludwiegID { return 0x02; }

@end


@interface LUDAnyTest : NSObject <LUDSerializablePackage>
@property (nullable, nonatomic, retain) LUDTypeAny *fieldP;
@end

@implementation LUDAnyTest

+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta {
    return @[[LUDTypeAnnotation annotationWithName:@"fieldP" andType:LUDProtocolTypeAny] ];
}

+ (uint8_t)ludwiegID { return 0x03; }

@end



@interface LudwiegTests : XCTestCase

@end

@implementation LudwiegTests

- (void)setUp {
    [LUDDeserializer registerPackages:[LUDTest class], [LUDFieldless class], [LUDAnyTest class], nil];
}

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
    test.fieldD = LUDDouble(30.2);
    test.fieldE = LUDString(@"String");
    uint8_t bytes[3] = { 0x27, 0x24, 0x50 };
    test.fieldF = LUDBlob([NSData dataWithBytes:bytes length:3]);
    test.fieldG = LUDBool(YES);
    test.fieldH = LUDUUID(@"3232ee42c2f24baf841318335b4d5640");
    test.fieldY = LUDAny(LUDString(@"Any field retaining a string"));
    test.fieldZ = @[LUDString(@"Robin"), LUDString(@"Tom")];
    test.fieldJ = LUDDynInt(27);
    {
        LUDTestSub *sub = [[LUDTestSub alloc] init];
        sub.fieldJ = LUDString(@"Structure");
        test.fieldI = sub;

        LUDTestSubOther *other = [[LUDTestSubOther alloc] init];
        other.fieldL = LUDString(@"Other Structure");
        sub.fieldK = other;
    }
    {
        LUDCustomType *hello = [[LUDCustomType alloc] init];
        hello.fieldV = LUDString(@"hello");

        LUDCustomType *friend = [[LUDCustomType alloc] init];
        friend.fieldV = LUDString(@"friend");

        test.fieldZA = @[hello, friend];
    }

    NSError *error;
    NSData *result = [LUDSerializer serializePackage:test withMessageID:0x01 andError:&error];
    XCTAssertNil(error);

    uint8_t expectBytes[185] = {
        0x27, 0x24, 0x50, 0x01, 0x01, 0x01, 0x01, 0xB1, 0x04, 0x1B, 0x08, 0x1C,
        0x00, 0x00, 0x00, 0x0C, 0x1D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x10, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3E, 0x40, 0x15, 0x01, 0x06,
        0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x19, 0x01, 0x03, 0x27, 0x24, 0x50,
        0x1C, 0x01, 0x24, 0x32, 0x32, 0xEE, 0x42, 0xC2, 0xF2, 0x4B, 0xAF, 0x84,
        0x13, 0x18, 0x33, 0x5B, 0x4D, 0x56, 0x40, 0x29, 0x01, 0x1F, 0x15, 0x01,
        0x1C, 0x41, 0x6E, 0x79, 0x20, 0x66, 0x69, 0x65, 0x6C, 0x64, 0x20, 0x72,
        0x65, 0x74, 0x61, 0x69, 0x6E, 0x69, 0x6E, 0x67, 0x20, 0x61, 0x20, 0x73,
        0x74, 0x72, 0x69, 0x6E, 0x67, 0x21, 0x01, 0x0C, 0x15, 0x01, 0x02, 0x01,
        0x05, 0x52, 0x6F, 0x62, 0x69, 0x6E, 0x01, 0x03, 0x54, 0x6F, 0x6D, 0x21,
        0x01, 0x15, 0x2D, 0x01, 0x02, 0x01, 0x08, 0x15, 0x01, 0x05, 0x68, 0x65,
        0x6C, 0x6C, 0x6F, 0x01, 0x09, 0x15, 0x01, 0x06, 0x66, 0x72, 0x69, 0x65,
        0x6E, 0x64, 0x2D, 0x01, 0x21, 0x15, 0x01, 0x09, 0x53, 0x74, 0x72, 0x75,
        0x63, 0x74, 0x75, 0x72, 0x65, 0x2D, 0x01, 0x12, 0x15, 0x01, 0x0F, 0x4F,
        0x74, 0x68, 0x65, 0x72, 0x20, 0x53, 0x74, 0x72, 0x75, 0x63, 0x74, 0x75,
        0x72, 0x65, 0x30, 0x01, 0x1B
    };
    NSData *expect = [NSData dataWithBytes:expectBytes length:185];
    XCTAssert([expect isEqualToData:result]);

}

- (void)testPerformance {
    [self measureBlock:^{
        LUDTest *test = [[LUDTest alloc] init];
        test.fieldA = LUDUint8(27);
        test.fieldB = LUDUint32(28);
        test.fieldC = LUDUint64(29);
        test.fieldD = LUDDouble(30.2);
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
    uint8_t expectBytes[185] = {
        0x27, 0x24, 0x50, 0x01, 0x01, 0x01, 0x01, 0xB1, 0x04, 0x1B, 0x08, 0x1C,
        0x00, 0x00, 0x00, 0x0C, 0x1D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x10, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3E, 0x40, 0x15, 0x01, 0x06,
        0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x19, 0x01, 0x03, 0x27, 0x24, 0x50,
        0x1C, 0x01, 0x24, 0x32, 0x32, 0xEE, 0x42, 0xC2, 0xF2, 0x4B, 0xAF, 0x84,
        0x13, 0x18, 0x33, 0x5B, 0x4D, 0x56, 0x40, 0x29, 0x01, 0x1F, 0x15, 0x01,
        0x1C, 0x41, 0x6E, 0x79, 0x20, 0x66, 0x69, 0x65, 0x6C, 0x64, 0x20, 0x72,
        0x65, 0x74, 0x61, 0x69, 0x6E, 0x69, 0x6E, 0x67, 0x20, 0x61, 0x20, 0x73,
        0x74, 0x72, 0x69, 0x6E, 0x67, 0x21, 0x01, 0x0C, 0x15, 0x01, 0x02, 0x01,
        0x05, 0x52, 0x6F, 0x62, 0x69, 0x6E, 0x01, 0x03, 0x54, 0x6F, 0x6D, 0x21,
        0x01, 0x15, 0x2D, 0x01, 0x02, 0x01, 0x08, 0x15, 0x01, 0x05, 0x68, 0x65,
        0x6C, 0x6C, 0x6F, 0x01, 0x09, 0x15, 0x01, 0x06, 0x66, 0x72, 0x69, 0x65,
        0x6E, 0x64, 0x2D, 0x01, 0x21, 0x15, 0x01, 0x09, 0x53, 0x74, 0x72, 0x75,
        0x63, 0x74, 0x75, 0x72, 0x65, 0x2D, 0x01, 0x12, 0x15, 0x01, 0x0F, 0x4F,
        0x74, 0x68, 0x65, 0x72, 0x20, 0x53, 0x74, 0x72, 0x75, 0x63, 0x74, 0x75,
        0x72, 0x65, 0x30, 0x01, 0x1B
    };

    LUDDeserializer *d = [LUDDeserializer deserializer];
    LUDMessageMeta *meta;
    id value;
    for(int i = 0; i < 185; i++) {
        if([d read:expectBytes[i] intoMessageMeta:&meta andTarget:&value]) {
            return;
        }
    }

    XCTFail("Deserialization failed");
}

- (void)testFieldless {
    LUDFieldless *f = [[LUDFieldless alloc] init];
    NSError *error;
    NSData *result = [LUDSerializer serializePackage:f withMessageID:0x66 andError:&error];
    XCTAssertNil(error);
    uint8_t buf[result.length];
    int dummy = 0;
    [result readLength:(int)result.length into:buf withOffset:&dummy];

    LUDDeserializer *d = [LUDDeserializer deserializer];
    id value;
    LUDMessageMeta *meta;
    for(int i = 0; i < result.length; i++) {
        if([d read:buf[i] intoMessageMeta:&meta andTarget:&value]) {
            NSLog(@"%@", value);
            return;
        }
    }

    XCTFail("Deserialization failed");
}

- (void)testDynIntCoersion {
    LUDTypeDynInt *instance = [[LUDTypeDynInt alloc] init];
    LUDTypeDynIntKind kind;
    double v;
    [instance coerceValue:27.0000000002 toKind:&kind andValue:&v];
    XCTAssertEqual(v, 27);
    XCTAssertEqual(kind, LUDTypeDynIntKindUint8);
}

@end
