#import "Bugsnag.h"
#import "RNErrorManager.h"

@implementation NSArray (Map)

- (NSArray *)rnfs_mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [result addObject:block(obj, idx)];
  }];

  return result;
}

@end

@implementation RNErrorManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setIdentifier:(NSDictionary*)attributes)
{
#ifdef DEBUG
  return;
#endif
  [[Bugsnag configuration] setUser:attributes[@"id"] withName:attributes[@"email"] andEmail:attributes[@"full_name"]];
}

RCT_EXPORT_METHOD(getSourceMaps:(RCTResponseSenderBlock)callback)
{
  NSString *filePath = [NSString stringWithFormat:@"%@/sourcemap.js", [[NSBundle mainBundle] bundlePath]];
  NSData *content = [[NSFileManager defaultManager] contentsAtPath:filePath];
  NSString *base64Content = [content base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

  if (!base64Content) {
    callback(@[]);
    return;
  }

  callback(@[base64Content]);
}

RCT_EXPORT_METHOD(reportException:(NSString *)message
                  stack:(NSArray<NSDictionary *> *)stack
                  exceptionId:(nonnull NSNumber *)exceptionId
                  errorData:(NSDictionary *)errorData
                  callback:(RCTResponseSenderBlock)callback)
{
#ifdef DEBUG
  callback(@[]);
  return;
#endif
  NSMutableArray *stringFrameArray = [[NSMutableArray alloc] init];

  for (NSDictionary *stackFrame in stack) {
    NSString *fileName = [NSString stringWithFormat:@"%@ @ %zd:%zd",
                          [stackFrame[@"file"] lastPathComponent],
                          [stackFrame[@"lineNumber"] integerValue],
                          [stackFrame[@"column"] integerValue]];

    [stringFrameArray addObject:[NSString stringWithFormat:@"%@ %@", fileName, stackFrame[@"methodName"]]];
  }

  NSDictionary *userInfo = @{
                             NSLocalizedDescriptionKey: NSLocalizedString([stringFrameArray componentsJoinedByString:@"\n"], nil),
                             };

  NSMutableDictionary *allErrorData = [errorData mutableCopy];
  [allErrorData addEntriesFromDictionary:@{@"Stacktrace": [stringFrameArray componentsJoinedByString:@"\n"]}];

  [Bugsnag notify:[NSException exceptionWithName:message reason:[stringFrameArray componentsJoinedByString:@"\n"] userInfo:userInfo]
         withData:allErrorData atSeverity:BugsnagSeverityError];

  callback(@[]);
}

RCT_EXPORT_METHOD(crash)
{
#ifdef DEBUG
  return;
#endif
}

@end
  