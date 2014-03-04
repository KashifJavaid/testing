//
//  WEWebAPIClient.m
//  WEShopping
//
//  Created by Unbounded on 2/17/14.
//  Copyright (c) 2014 Unbounded. All rights reserved.
//

#import "WEWebAPIClient.h"
#import "WEAppDelegate.h"
@implementation WEWebAPIClient
-(void) postRequest:(NSString*)CategoryName Item:(NSString*)itemName
{
    NSError *error;
    WEAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    if ((appDelegate.internetConnnectionStatus || appDelegate.wifiConnectionStatus)&&appDelegate.hostReachabilityStatus)
    {
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"name", CategoryName, @"category", nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
        NSURL *url = [NSURL URLWithString: @"https://cmshopper.herokuapp.com/items.json"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setValue:@"a14ab7992ba34ac038be02954e99e1f5" forHTTPHeaderField:@"X-CM-Authorization"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:jsonData];
        self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if ( self.connection )
        {
            self.downloadData = [[NSMutableData alloc]init];
            
        }
        else
        {
            [self.delegate webServiceData:NO date:nil webID:nil];
        }

    }
    else
    {
        [self.delegate webServiceData:NO date:nil webID:nil];
    }
}
-(BOOL) deleteRequest:(NSString*)itemID
{
    WEAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    if ((appDelegate.internetConnnectionStatus || appDelegate.wifiConnectionStatus)&&appDelegate.hostReachabilityStatus)
    {
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"https://cmshopper.herokuapp.com/items/%@.json",itemID]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setValue:@"a14ab7992ba34ac038be02954e99e1f5" forHTTPHeaderField:@"X-CM-Authorization"];
        [theRequest setHTTPMethod:@"DELETE"];
        self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if ( self.connection ) {
            self.downloadData = [[NSMutableData alloc]init];
            
        }
        else
        {
            return NO;
        }
        return YES;
    }
    return NO;

}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.downloadData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dicAlbumsData=[NSJSONSerialization JSONObjectWithData:self.downloadData options:0 error:nil];
    [self.delegate webServiceData:YES date:[dicAlbumsData objectForKey:@"updated_at"] webID:[dicAlbumsData objectForKey:@"id"] ];

    
}
@end
