//
//  AppDelegate.m
//  Tipe Application (iOS)
//
//  Created by Alexandre Marquis on 24/12/2017.
//  Copyright © 2017 Alexandre Marquis. All rights reserved.
//
#import "AppDelegate.h"
int wifiType;
int wifiData;

@implementation AppDelegate
@synthesize window;
@synthesize centralManager;
@synthesize connectedSwitch;
@synthesize BLEPeripheral;
@synthesize RSSINumber;
@synthesize BLECharacteristic;
@synthesize websocket;
@synthesize RSSIText;
@synthesize timer;
@synthesize connectionSegment;

bool canSend = NO;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    window.backgroundColor= [UIColor whiteColor];
    window.userInteractionEnabled=YES;
    window.rootViewController=[[UIViewController alloc]init];
    [window makeKeyAndVisible];
    
    connectedSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(longueur/3,largeur/10+(largeur/5),longueur/10,largeur/10)];
    [connectedSwitch setUserInteractionEnabled:NO];
    [window addSubview:connectedSwitch];
    
    UILabel *deviceInfo = [[UILabel alloc]initWithFrame:CGRectMake(longueur/20,largeur/50,longueur/2,largeur/10)];
    deviceInfo.text=@"Informations :";
    [deviceInfo setFont:[UIFont boldSystemFontOfSize:20]];
    [window addSubview:deviceInfo];
    
    UILabel *connectedText = [[UILabel alloc]initWithFrame:CGRectMake(longueur/20,largeur/10+(largeur/5),longueur/4,largeur/10)];
    connectedText.text=@"Connection";
    [connectedText setFont:[UIFont systemFontOfSize:20]];
    [window addSubview:connectedText];
    
    UILabel *typeText = [[UILabel alloc]initWithFrame:CGRectMake(longueur/20,largeur/20+(largeur/10),longueur/4,largeur/10)];
    typeText.text=@"Type";
    [typeText setFont:[UIFont systemFontOfSize:20]];
    [window addSubview:typeText];
    
    RSSIText = [[UILabel alloc]initWithFrame:CGRectMake(longueur/2,largeur/10+(largeur/5),longueur/4,largeur/10)];
    RSSIText.text=@"RSSI :";
    [RSSIText setFont:[UIFont systemFontOfSize:20]];
    [window addSubview:RSSIText];
    RSSIText.alpha=0.0;
    
    RSSINumber = [[UILabel alloc]initWithFrame:CGRectMake(longueur/1.5,largeur/10+(largeur/5),longueur/10,largeur/10)];
    RSSINumber.text=@"0";
    [RSSINumber setFont:[UIFont boldSystemFontOfSize:20]];
    [window addSubview:RSSINumber];
    RSSINumber.alpha=0.0;
    
    UISlider *speedSlider = [[UISlider alloc]initWithFrame:CGRectMake(longueur/2,largeur/10,largeur-(largeur/6),longueur/17)];
    speedSlider.center=CGPointMake(longueur-(longueur/10)+longueur/34,largeur/10+((largeur-(largeur/10))/2));
    speedSlider.minimumValue= 0.0;
    speedSlider.maximumValue= 200.0;
    speedSlider.tag=254;
    [speedSlider setValue:100.0 animated:NO];
    speedSlider.continuous=YES;
    [speedSlider addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventValueChanged];
    [speedSlider addTarget:self action:@selector(resetSlider:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    speedSlider.minimumTrackTintColor=[UIColor lightGrayColor];
    speedSlider.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [window addSubview:speedSlider];
    
    UISlider *rotationSlider = [[UISlider alloc]initWithFrame:CGRectMake(longueur/20,largeur-(4*largeur/20),longueur/2,largeur/10)];
    rotationSlider.minimumValue= 0.0;
    rotationSlider.maximumValue= 200.0;
    rotationSlider.tag=250;
    [rotationSlider setValue:100.0 animated:NO];
    rotationSlider.continuous=YES;
    [rotationSlider addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventValueChanged];
    [rotationSlider addTarget:self action:@selector(resetSlider:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    rotationSlider.minimumTrackTintColor=[UIColor lightGrayColor];
    [window addSubview:rotationSlider];
    
    UILabel *speedSliderName = [[UILabel alloc]initWithFrame:CGRectMake(longueur-(longueur/10),largeur/30,longueur/12,largeur/10)];
    speedSliderName.text=@"Vit.";
    speedSliderName.backgroundColor=[UIColor clearColor];
    [window addSubview:speedSliderName];
    
    UILabel *rotationSliderName = [[UILabel alloc]initWithFrame:CGRectMake(longueur/4,largeur-(6*largeur/20),longueur/5,largeur/10)];
    rotationSliderName.text=@"Rotation";
    rotationSliderName.backgroundColor = [UIColor clearColor];
    [window addSubview:rotationSliderName];
    
    UISlider *cameraSlider = [[UISlider alloc]initWithFrame:CGRectMake(longueur/20,largeur-(9*largeur/20),longueur/2,largeur/10)];
    cameraSlider.minimumValue= 0.0;
    cameraSlider.maximumValue= 200.0;
    cameraSlider.tag=253;
    [cameraSlider setValue:100.0 animated:NO];
    cameraSlider.continuous=YES;
    [cameraSlider addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventValueChanged];
    [cameraSlider addTarget:self action:@selector(resetSlider:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    cameraSlider.minimumTrackTintColor=[UIColor lightGrayColor];
    [window addSubview:cameraSlider];
    
    UILabel *cameraSliderName = [[UILabel alloc]initWithFrame:CGRectMake(longueur/4,largeur-(11*largeur/20),longueur/5,largeur/10)];
    cameraSliderName.text=@"Caméra";
    cameraSliderName.backgroundColor = [UIColor clearColor];
    [window addSubview:cameraSliderName];
    
    connectionSegment =[[UISegmentedControl alloc]initWithItems:@[@"Bluetooth",@"Wifi"]];
    connectionSegment.frame=CGRectMake(longueur/3,largeur/20+(largeur/10),longueur/4,largeur/10);
    [window addSubview:connectionSegment];
    [connectionSegment addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
    
    connectionSegment.selectedSegmentIndex=0;
    [self typeChanged:connectionSegment];
    return YES;
}

-(void)typeChanged:(UISegmentedControl*)segment{
    [connectedSwitch setOn:NO animated:YES];
    if ([segment selectedSegmentIndex]==0){    //bluetooth selectionné
        RSSINumber.alpha=1.0;
        RSSIText.alpha=1.0;
        if (websocket != nil){
            [websocket close];
        }
        if (BLEPeripheral.state == CBPeripheralStateConnected){
            [connectedSwitch setOn:YES animated:YES];
            
        }
         timer=nil;
    }
    else if ([segment selectedSegmentIndex]==1){  //wifi selectionné
        RSSINumber.alpha=0.0;
        RSSIText.alpha=0.0;
        websocket = [[SRWebSocket alloc]initWithURLRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.1.94:81/"]]];
        websocket.delegate=self;
        [websocket open];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(allowSend) userInfo:nil repeats:YES];
    }
}
-(void)allowSend{
    if (websocket.readyState == SR_OPEN){
        [websocket send:[NSData dataWithBytes:&wifiType length:1]];
        [websocket send:[NSData dataWithBytes:&wifiData length:1]];
    }
}
-(void)sendData:(UISlider*)sender{
    if (BLEPeripheral.state == CBPeripheralStateConnected && BLECharacteristic!=nil && [connectionSegment selectedSegmentIndex]==0){
        char byte[2]={(uint8_t)sender.tag,(uint8_t)sender.value};
        [BLEPeripheral writeValue:[NSData dataWithBytes:&byte length:2] forCharacteristic:BLECharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
    if (websocket.readyState == SR_OPEN && [connectionSegment selectedSegmentIndex]==1){
        wifiType = (uint8_t)sender.tag;
        wifiData = (uint8_t)sender.value;
    }
}

-(void)resetSlider:(UISlider*)sender{
    [sender setValue:((sender.maximumValue-sender.minimumValue)/2) animated:YES];
    [self sendData:sender];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [NSTimer scheduledTimerWithTimeInterval:1 target:peripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];
    [connectedSwitch setOn:YES animated:YES];
    NSLog(@"peripheral connected");
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"FFE0"]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError*) error{
        [connectedSwitch setOn:NO animated:YES];
        RSSINumber.text=@"0";
        [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFE0"]] options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([[advertisementData valueForKey:@"kCBAdvDataLocalName"] isEqualToString:@"TIPERobot"]){
        [central stopScan];
        BLEPeripheral = peripheral;
        peripheral.delegate = self;
        [central connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if ([centralManager state] == CBCentralManagerStatePoweredOn){
        [centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFE0"]] options:nil];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"FFE1"]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics){
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]){
            BLECharacteristic = characteristic;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber*)RSSI error:(NSError*)error{
    RSSINumber.text= [RSSI stringValue];
    if (connectedSwitch.isOn != YES && connectionSegment.selectedSegmentIndex==0) {
        [connectedSwitch setOn:YES animated:YES];
    }
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Socket open\n\n\n");
    [connectedSwitch setOn:YES animated:YES];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string{
    NSLog(@"string");
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data{
    NSLog(@"data");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"Erreur socket %@",error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Erreur socket");
    [connectedSwitch setOn:NO animated:YES];
    websocket =nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"message");
}

@end
