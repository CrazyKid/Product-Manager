//
//  ProductCell.m
//  库存管理
//
//  Created by Macx on 16/3/16.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ProductCell.h"
#import "Model.h"

@interface ProductCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *keyNum;


@end

@implementation ProductCell

- (void)setModel:(Model *)model {

    _model = model;
    
    _keyNum.text = [NSString stringWithFormat:@"产品编号:%@",_model.productID];
    _name.text = [NSString stringWithFormat:@"产品名称:%@",_model.productName];
    _type.text = [NSString stringWithFormat:@"产品类型:%@",_model.productType];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
