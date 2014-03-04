//
//  WEWebAPIClient.h
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WebServiceDelegate
-(void)webServiceData:(BOOL)executed date:(NSString*)dateUpdated webID:(NSNumber*)webID;
@end
@interface WEWebAPIClient : NSObject<NSURLConnectionDataDelegate>
@property (strong) id delegate;
@property (strong)NSURLConnection *connection;
@property (strong)NSMutableData *downloadData;
-(void) postRequest:(NSString*)CategoryName Item:(NSString*)itemName;
-(BOOL) deleteRequest:(NSString*)itemID;
@end
