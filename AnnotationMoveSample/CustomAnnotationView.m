//
//  CustomAnnotationView.m
//  AnnotationMoveSample
//
//  Created by Masamichi Ueta on 12/06/27.
//  Copyright (c) 2012年 The University of Tokyo. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"


@implementation CustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.image = [UIImage imageNamed:@"symbol-moving-annotation.png"];
    return self;
}

@end
