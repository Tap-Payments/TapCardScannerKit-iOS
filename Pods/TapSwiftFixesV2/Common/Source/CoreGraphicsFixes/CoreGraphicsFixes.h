//
//  CoreGraphicsFixes.h
//  TapSwiftFixes
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@import CoreGraphics.CGContext;

extern CGContextRef __nullable CGContextCreate(void * __nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef __nullable space, uint32_t bitmapInfo);
