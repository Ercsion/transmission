// This file Copyright © 2007-2022 Transmission authors and contributors.
// It may be used under the MIT (SPDX: MIT) license.
// License text can be found in the licenses/ folder.

#import "BadgeView.h"
#import "NSStringAdditions.h"

#define BETWEEN_PADDING 2.0

@interface BadgeView ()

@property(nonatomic, readonly) tr_session* fLib;

@property(nonatomic) NSMutableDictionary* fAttributes;

@property(nonatomic) uint64_t fDnRateBps;
@property(nonatomic) uint64_t fUpRateBps;

- (void)badge:(NSImage*)badge string:(NSString*)string atHeight:(CGFloat)height;

@end

@implementation BadgeView

- (instancetype)initWithLib:(tr_session*)lib
{
    if ((self = [super init]))
    {
        _fLib = lib;

        _fDnRateBps = 0;
        _fUpRateBps = 0;
    }
    return self;
}

- (BOOL)setRatesWithDownload:(uint64_t)dnRateBps upload:(uint64_t)upRateBps
{
    //only needs update if the badges were displayed or are displayed now
    if (self.fDnRateBps == dnRateBps && self.fUpRateBps == upRateBps)
    {
        return NO;
    }

    self.fDnRateBps = dnRateBps;
    self.fUpRateBps = upRateBps;
    return YES;
}

- (void)drawRect:(NSRect)rect
{
    [NSApp.applicationIconImage drawInRect:rect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];

    BOOL const upload = self.fUpRateBps >= 0;
    BOOL const download = self.fDnRateBps >= 0;
    CGFloat bottom = 0.0;
    if (upload)
    {
        NSImage* uploadBadge = [NSImage imageNamed:@"UploadBadge"];
        [self badge:uploadBadge string:[NSString stringForSpeedAbbrev:self.fUpRateBps] atHeight:bottom];

        if (download)
        {
            bottom += uploadBadge.size.height + BETWEEN_PADDING; //download rate above upload rate
        }
    }
    if (download)
    {
        [self badge:[NSImage imageNamed:@"DownloadBadge"] string:[NSString stringForSpeedAbbrev:self.fDnRateBps] atHeight:bottom];
    }
}

- (void)badge:(NSImage*)badge string:(NSString*)string atHeight:(CGFloat)height
{
    if (!self.fAttributes)
    {
        NSShadow* stringShadow = [[NSShadow alloc] init];
        stringShadow.shadowOffset = NSMakeSize(2.0, -2.0);
        stringShadow.shadowBlurRadius = 4.0;

        self.fAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];
        self.fAttributes[NSForegroundColorAttributeName] = NSColor.whiteColor;
        self.fAttributes[NSShadowAttributeName] = stringShadow;
    }

    NSRect badgeRect;
    badgeRect.size = badge.size;
    badgeRect.origin.x = 0.0;
    badgeRect.origin.y = height;

    [badge drawInRect:badgeRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];

    //make sure text fits on the badge
    CGFloat fontSize = 26.0;
    NSSize stringSize;
    do
    {
        self.fAttributes[NSFontAttributeName] = [NSFont boldSystemFontOfSize:fontSize];
        stringSize = [string sizeWithAttributes:self.fAttributes];
        fontSize -= 1.0;
    } while (NSWidth(badgeRect) < stringSize.width);

    //string is in center of image
    NSRect stringRect;
    stringRect.origin.x = NSMidX(badgeRect) - stringSize.width * 0.5;
    stringRect.origin.y = NSMidY(badgeRect) - stringSize.height * 0.5 + 1.0; //adjust for shadow
    stringRect.size = stringSize;

    [string drawInRect:stringRect withAttributes:self.fAttributes];
}

@end
