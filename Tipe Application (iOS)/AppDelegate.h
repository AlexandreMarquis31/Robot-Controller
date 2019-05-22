//
//  AppDelegate.h
//  Tipe Application (iOS)
//
//  Created by Alexandre Marquis on 24/12/2017.
//  Copyright © 2017 Alexandre Marquis. All rights reserved.
//
#define largeur [[UIScreen mainScreen]bounds].size.height
#define longueur [[UIScreen mainScreen]bounds].size.width

#import "SocketRocket.h"
@import UIKit;
@import CoreBluetooth;
@import QuartzCore;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,SRWebSocketDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *BLEPeripheral;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UISwitch *connectedSwitch;
@property (nonatomic, strong) UILabel *RSSINumber;
@property (nonatomic, strong) CBCharacteristic* BLECharacteristic;
@property (nonatomic, strong) SRWebSocket *websocket;
@property (nonatomic,strong) UILabel *RSSIText;
@property (nonatomic,strong) NSTimer*timer;
@property (nonatomic, strong) UISegmentedControl* connectionSegment;
@end

