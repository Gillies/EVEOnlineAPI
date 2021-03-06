//
//  EVEAllianceList.m
//  EVEOnlineAPI
//
//  Created by Artem Shimanski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EVEAllianceList.h"


@implementation EVEAllianceListItem
@synthesize name;
@synthesize shortName;
@synthesize allianceID;
@synthesize executorCorpID;
@synthesize memberCount;
@synthesize startDate;
@synthesize memberCorporations;

+ (id) allianceListItemWithXMLAttributes:(NSDictionary *)attributeDict {
	return [[[EVEAllianceListItem alloc] initWithXMLAttributes:attributeDict] autorelease];
}

- (id) initWithXMLAttributes:(NSDictionary *)attributeDict {
	if (self = [super init]) {
		self.name = [attributeDict valueForKey:@"name"];
		self.shortName = [attributeDict valueForKey:@"shortName"];
		self.allianceID = [[attributeDict valueForKey:@"allianceID"] integerValue];
		self.executorCorpID = [[attributeDict valueForKey:@"executorCorpID"] integerValue];
		self.memberCount = [[attributeDict valueForKey:@"memberCount"] integerValue];
		self.startDate = [[NSDateFormatter eveDateFormatter] dateFromString:[attributeDict valueForKey:@"startDate"]];
	}
	return self;
}

- (void) dealloc {
	[name release];
	[shortName release];
	[memberCorporations release];
	[startDate release];
	[super dealloc];
}

@end


@implementation EVEAllianceListMemberCorporationsItem
@synthesize corporationID;
@synthesize startDate;


+ (id) allianceListMemberCorporationsItemWithXMLAttributes:(NSDictionary *)attributeDict {
	return [[[EVEAllianceListMemberCorporationsItem alloc] initWithXMLAttributes:attributeDict] autorelease];
}

- (id) initWithXMLAttributes:(NSDictionary *)attributeDict {
	if (self = [super init]) {
		self.corporationID = [[attributeDict valueForKey:@"allianceID"] corporationID];
		self.startDate = [[NSDateFormatter eveDateFormatter] dateFromString:[attributeDict valueForKey:@"startDate"]];
	}
	return self;
}

- (void) dealloc {
	[startDate release];
	[super dealloc];
}

@end


@implementation EVEAllianceList
@synthesize alliances;
@synthesize alliancesMap;

+ (EVEApiKeyType) requiredApiKeyType {
	return EVEApiKeyTypeNone;
}

+ (id) allianceListWithError:(NSError **)errorPtr {
	return [[[EVEAllianceList alloc] initWithError:errorPtr] autorelease];
}

+ (id) allianceListWithTarget:(id)target action:(SEL)action object:(id)aObject {
	return [[[EVEAllianceList alloc] initWithTarget:target action:action object:aObject] autorelease];
}

- (id) initWithError:(NSError **)errorPtr {
	if (self = [super initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/eve/AllianceList.xml.aspx", EVEOnlineAPIHost]]
					   cacheStyle:EVERequestCacheStyleModifiedShort
							error:errorPtr]) {
	}
	return self;
}

- (id) initWithTarget:(id)target action:(SEL)action object:(id)aObject {
	if (self = [super initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/eve/AllianceList.xml.aspx", EVEOnlineAPIHost]]
					   cacheStyle:EVERequestCacheStyleModifiedShort
						   target:target
						   action:action object:aObject]) {
	}
	return self;
}

- (void) dealloc {
	[alliances release];
	[alliancesMap release];
	[super dealloc];
}

- (void) cacheData {
	self.cachedUntil = [self.currentTime dateByAddingTimeInterval:3600 * 24];
	[super cacheData];
}

- (NSDictionary*) alliancesMap {
	if (!alliancesMap) {
		alliancesMap = [[NSMutableDictionary alloc] initWithCapacity:alliances.count];
		for (EVEAllianceListItem* item in alliances)
			[alliancesMap setValue:item forKey:[NSString stringWithFormat:@"%d", item.allianceID]];
	}
	return alliancesMap;
}

#pragma mark NSXMLParserDelegate

- (id) didStartRowset: (NSString*) rowset {
	if ([rowset isEqualToString:@"alliances"]) {
		alliances = [[NSMutableArray alloc] init];
		return alliances;
	}
	else if ([rowset isEqualToString:@"memberCorporations"]) {
		NSMutableArray *memberCorporations = [[[NSMutableArray alloc] init] autorelease];
		[self.currentRow setMemberCorporations:memberCorporations];
		return memberCorporations;
	}
	else
		return nil;
}

- (id) didStartRowWithAttributes:(NSDictionary *) attributeDict rowset:(NSString*) rowset rowsetObject:(id) object {
	if ([rowset isEqualToString:@"alliances"]) {
		EVEAllianceListItem *allianceListItem = [EVEAllianceListItem allianceListItemWithXMLAttributes:attributeDict];
		[object addObject:allianceListItem];
		return allianceListItem;
	}
	else if ([rowset isEqualToString:@"memberCorporations"]) {
		EVEAllianceListMemberCorporationsItem *allianceListMemberCorporationsItem = [EVEAllianceListMemberCorporationsItem allianceListMemberCorporationsItemWithXMLAttributes:attributeDict];
		[object addObject:allianceListMemberCorporationsItem];
		return allianceListMemberCorporationsItem;
	}
	
	return nil;
}
@end