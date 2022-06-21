//
//  UIImage+SMSGLExtend.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import "UIImage+SMSGLExtend.h"

@implementation UIImage (SMSGLExtend)

- (CVPixelBufferRef)SMS_BGRAPixelBuffer {
    OSType format = kCVPixelFormatType_32BGRA;
    CGImageRef cgImage = self.CGImage;
    CVPixelBufferRef pixelBuffer = NULL;
    const size_t width = CGImageGetWidth(cgImage);
    const size_t height = CGImageGetHeight(cgImage);
    CFDictionaryRef empty;
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    __unused CVReturn err = CVPixelBufferCreate(kCFAllocatorDefault, width, height, format, attrs, &pixelBuffer);
    CFRelease(attrs);
    CFRelease(empty);
    NSAssert(err == kCVReturnSuccess, @"创建PixelBuffer不成功 :%d", err);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *rasterData = CVPixelBufferGetBaseAddress(pixelBuffer);
    const size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    const size_t bitsPerComponent = 8;
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    if (format == kCVPixelFormatType_32BGRA) {
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
        bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGImageByteOrder32Little;
    } else if (format == kCVPixelFormatType_OneComponent8) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = (CGBitmapInfo)kCGImageAlphaOnly;
        if (CGImageGetAlphaInfo(cgImage) == kCGImageAlphaNone) {
            bitmapInfo = (CGBitmapInfo)kCGImageAlphaNone;
        }
    } else {
        assert(NO);
    }
    CGContextRef context = CGBitmapContextCreate(rasterData, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    return pixelBuffer;
}

@end
