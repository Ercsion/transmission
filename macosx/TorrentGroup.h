// This file Copyright © 2008-2022 Transmission authors and contributors.
// It may be used under the MIT (SPDX: MIT) license.
// License text can be found in the licenses/ folder.

#import <Foundation/Foundation.h>

@class Torrent;

@interface TorrentGroup : NSObject

- (instancetype)initWithGroup:(NSInteger)group;

@property(nonatomic, readonly) NSInteger groupIndex;
@property(nonatomic, readonly) NSInteger groupOrderValue;
@property(nonatomic, readonly) NSMutableArray<Torrent*>* torrents;

@property(nonatomic, readonly) CGFloat ratio;
@property(nonatomic, readonly) uint64_t uploadRateBps;
@property(nonatomic, readonly) uint64_t downloadRateBps;

@end
