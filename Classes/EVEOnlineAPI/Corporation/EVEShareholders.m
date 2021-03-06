//
//  EVEShareholders.m
//  EVEOnlineAPI
//
//  Created by Artem Shimanski on 7/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EVEShareholders.h"


@implementation EVEShareholdersCharactersItem
@synthesize shareholderID;
@synthesize shareholderName;
@synthesize shareholderCorporationID;
@synthesize shareholderCorporationName;
@synthesize shares;

+ (id) shareholdersCharactersItemWithXMLAttributes:(NSDictionary *)attributeDict {
	return [[[EVEShareholdersCharactersItem alloc] initWithXMLAttributes:attributeDict] autorelease];
}

- (id) initWithXMLAttributes:(NSDictionary *)attributeDict {
	if (self = [super init]) {
		self.shareholderID = [[attributeDict valueForKey:@"shareholderID"] integerValue];
		self.shareholderName = [attributeDict valueForKey:@"shareholderName"];
		self.shareholderCorporationID = [[attributeDict valueForKey:@"shareholderCorporationID"] integerValue];
		self.shareholderCorporationName = [attributeDict valueForKey:@"shareholderCorporationName"];
		self.shares = [[attributeDict valueForKey:@"shares"] integerValue];
	}
	return self;
}

- (void) dealloc {
	[shareholderName release];
	[shareholderCorporationName release];
	[super dealloc];
}

@end


@implementation EVEShareholdersCorporationsItem
@synthesize shareholderID;
@synthesize shareholderName;
@synthesize shares;

+ (id) shareholdersCorporationsItemWithXMLAttributes:(NSDictionary *)attributeDict {
	return [[[EVEShareholdersCorporationsItem alloc] initWithXMLAttributes:attributeDict] autorelease];
}

- (id) initWithXMLAttributes:(NSDictionary *)attributeDict {
	if (self = [super init]) {
		self.shareholderID = [[attributeDict valueForKey:@"shareholderID"] integerValue];
		self.shareholderName = [attributeDict valueForKey:@"shareholderName"];
		self.shares = [[attributeDict valueForKey:@"shares"] integerValue];
	}
	return self;
}

- (void) dealloc {
	[shareholderName release];
	[super dealloc];
}

@end


@implementation EVEShareholders
@synthesize characters;
@synthesize corporations;

+ (EVEApiKeyType) requiredApiKeyType {
	return EVEApiKeyTypeFull;
}

+ (id) shareholdersWithKeyID: (NSInteger) keyID vCode: (NSString*) vCode characterID: (NSInteger) characterID error:(NSError **)errorPtr {
	return [[[EVEShareholders alloc] initWithKeyID:keyID vCode:vCode characterID:characterID error:errorPtr] autorelease];
}

+ (id) shareholdersWithKeyID: (NSInteger) keyID vCode: (NSString*) vCode characterID: (NSInteger) characterID target:(id)target action:(SEL)action object:(id)object {
	return [[[EVEShareholders alloc] initWithKeyID:keyID vCode:vCode characterID:characterID target:target action:action object:object] autorelease];
}

- (id) initWithKeyID: (NSInteger) keyID vCode: (NSString*) vCode characterID: (NSInteger) characterID error:(NSError **)errorPtr {
	if (self = [super initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/corp/Shareholders.xml.aspx?keyID=%d&vCode=%@&characterID=%d", EVEOnlineAPIHost, keyID, vCode, characterID]]
					   cacheStyle:EVERequestCacheStyleModifiedShort
							error:errorPtr]) {
	}
	return self;
}

- (id) initWithKeyID: (NSInteger) keyID vCode: (NSString*) vCode characterID: (NSInteger) characterID target:(id)target action:(SEL)action object:(id)aObject {
	if (self = [super initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/corp/Shareholders.xml.aspx?keyID=%d&vCode=%@&characterID=%d", EVEOnlineAPIHost, keyID, vCode, characterID]]
					   cacheStyle:EVERequestCacheStyleModifiedShort
						   target:target
						   action:action object:aObject]) {
	}
	return self;
}

- (void) dealloc {
	[characters release];
	[corporations release];
	[super dealloc];
}

#pragma mark NSXMLParserDelegate

- (id) didStartRowset: (NSString*) rowset {
	if ([rowset isEqualToString:@"characters"]) {
		characters = [[NSMutableArray alloc] init];
		return characters;
	}
	else if ([rowset isEqualToString:@"corporations"]) {
		corporations = [[NSMutableArray alloc] init];
		return corporations;
	}
	else
		return nil;
}

- (id) didStartRowWithAttributes:(NSDictionary *) attributeDict rowset:(NSString*) rowset rowsetObject:(id) object {
	if ([rowset isEqualToString:@"characters"]) {
		EVEShareholdersCharactersItem *shareholdersCharactersItem = [EVEShareholdersCharactersItem shareholdersCharactersItemWithXMLAttributes:attributeDict];
		[object addObject:shareholdersCharactersItem];
		return shareholdersCharactersItem;
	}
	else if ([rowset isEqualToString:@"corporations"]) {
		EVEShareholdersCorporationsItem *shareholdersCorporationsItem = [EVEShareholdersCorporationsItem shareholdersCorporationsItemWithXMLAttributes:attributeDict];
		[object addObject:shareholdersCorporationsItem];
		return shareholdersCorporationsItem;
	}
	return nil;
}

@end