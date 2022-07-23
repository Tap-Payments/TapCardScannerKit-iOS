//
//  CoreGraphicsFixes.m
//  TapSwiftFixes
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@import CoreGraphics.CGBitmapContext;

#import "CoreGraphicsFixes.h"

CGContextRef __nullable CGContextCreate(void * __nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef cg_nullable space, uint32_t bitmapInfo)
{
    return CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);
}
