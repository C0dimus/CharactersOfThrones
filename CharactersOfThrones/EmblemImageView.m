//
//  EmblemImageView.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 29/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "EmblemImageView.h"
#import "Consts.h"
#import <QuartzCore/QuartzCore.h>

@implementation EmblemImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:[self maskImage:image]];
}

- (UIImage*) maskImage:(UIImage *) image {
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = [UIImage imageNamed:@"emblem_mask"].CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL,
                                             YES
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

@end
