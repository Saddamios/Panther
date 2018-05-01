//
//  NetworkManager.m
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "NetworkManager.h"
#import "Utility.h"
#import "Constants.h"

@implementation NetworkManager

- (void)getServerDataWithurl:(NSString *)url andParams:(NSDictionary *)params {

    if(![Utility isNullOrEmptyString:url]) {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    //create the Method "GET"
    [urlRequest setHTTPMethod:kAPIMethodTypeGET];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         NSError *parseError = nil;
        if(httpResponse.statusCode == 200)
        {

            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
        }
        else
        {
            [self.delegate manager:self didFinishedWithData:parseError.localizedDescription];
        }
    }];
    [dataTask resume];

    }
    else {
        [self.delegate manager:self didFailedWithData:@"Incorrect Base URL"];
    }
}

- (void)postServerDataWithurl:(NSString *)url andParams:(NSDictionary *)params {

}
@end
