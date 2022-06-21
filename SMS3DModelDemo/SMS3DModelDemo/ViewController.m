//
//  ViewController.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "ViewController.h"

#import "SMSGLContext.h"
#import "SMSGLDevice.h"
#import "SMSGLFilter.h"
#import "SMSGLBGRATexture.h"

@interface ViewController ()

@property (nonatomic) SMSGLContext *context;
@property (nonatomic) SMSGLFilter *filter;
@property (nonatomic) id<SMSGLTexture> iChannel0;

@end

@implementation ViewController

#pragma mark - dealloc
- (void)dealloc {
    [_iChannel0 releaseResource];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SMSGLContext *context = [[SMSGLContext alloc] initWithDevice:[[SMSGLDevice alloc] init]];
    self.context = context;

    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"SMSGLVertex.glsl" ofType:nil];
    NSString *fragementPath = [[NSBundle mainBundle] pathForResource:@"SMSGLPasstroughFragment.glsl" ofType:nil];
    NSString *vertex = [NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:nil];
    NSString *fragment = [NSString stringWithContentsOfFile:fragementPath encoding:NSUTF8StringEncoding error:nil];

    SMSGLProgram *program = [context programWithVertexShaderString:vertex fragmentShaderString:fragment];
    SMSGLFilter *filter = [[SMSGLFilter alloc] initWithProgram:program context:context];
    self.filter = filter;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_3902.JPG" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    [image drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CVPixelBufferRef pixelBuffer = [image SMS_BGRAPixelBuffer];
    id<SMSGLTexture> iChannel0 = [context makeBGRATextureWithPixelBuffer:pixelBuffer];
    self.iChannel0 = iChannel0;
    CVPixelBufferRelease(pixelBuffer);
}

- (IBAction)onBtn:(id)sender {
    id<SMSGLTexture> canvas = [self.context makeEmptyBGRATextureWithSize:[self.iChannel0 size]];
    [self.filter drawTexture:@[self.iChannel0] onCanvas:canvas];
    glFinish();
    [canvas releaseResource];
}

@end
