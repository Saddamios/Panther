//
//  NetworkManager.h
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkManager;

@protocol NetworkManagerDelegate <NSObject>

- (void)manager:(NetworkManager *)manager didFinishedWithData:(NSString *)data;
- (void)manager:(NetworkManager *)manager didFailedWithData:(NSString *)data;

@end

@interface NetworkManager : NSObject

@property (weak, nonatomic) id<NetworkManagerDelegate> delegate;

- (void)getServerDataWithurl:(NSString *)url andParams:(NSDictionary *)params;
- (void)postServerDataWithurl:(NSString *)url andParams:(NSDictionary *)params;

@end
