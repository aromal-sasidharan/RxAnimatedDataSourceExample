//
//  TestStackView.swift
//  Example
//
//  Created by Aromal Sasidharan on 10/9/18.
//  Copyright © 2018 kzaher. All rights reserved.
//
public extension UIView
{
    static func loadFromXib<T>(withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
    func resetLayoutHeight(){
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.frame.size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    
}

import UIKit
import SnapKit
class TestCell:UITableViewCell{
    let childView:TestStackView = TestStackView.loadFromXib()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(childView)
        childView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            
        }
    }
}
class TestStackView: UIStackView {
    @IBOutlet weak var stackViewExpand: UIStackView!
    
    @IBOutlet weak var labelTest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

}
