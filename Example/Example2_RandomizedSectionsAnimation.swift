//
//  ViewController.swift
//  Example
//
//  Created by Krunoslav Zaher on 1/1/16.
//  Copyright © 2016 kzaher. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import CoreLocation
class IntItem1 {
    let number: Int
    init(number: Int) {
        self.number = number
        
    }
}
extension IntItem1
    : IdentifiableType
, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return number
    }
}

// equatable, this is needed to detect changes
func == (lhs: IntItem1, rhs: IntItem1) -> Bool {
    return lhs.number == rhs.number
}


extension IntItem1
    : CustomDebugStringConvertible {
    var debugDescription: String {
        return "IntItem(number: \(number)"
    }
}

extension IntItem1
    : CustomStringConvertible {

    var description: String {
        return "\(number)"
    }
}

class NumberCell : UICollectionViewCell {
    @IBOutlet var value: UILabel?
}

class NumberSectionView : UICollectionReusableView {
    @IBOutlet weak var value: UILabel?
}

class PartialUpdatesViewController: UIViewController {
    typealias SectionType = AnimatableSectionModel<String,IntItem1>
    @IBOutlet weak var animatedTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animatedCollectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    let data:Variable<[SectionType]> = Variable([SectionType(model: "section 1", items: `$`([1, 2, 3])),
                                                   SectionType(model: "section 2", items: `$`([4, 5, 6,7,8,9,10])),
                                                  ])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatedTableView.estimatedRowHeight = 500
        animatedTableView.rowHeight = UITableViewAutomaticDimension
        animatedTableView.separatorStyle = .none
//        animatedTableView.allowsSelection = false
        animatedTableView.register(TestCell.self, forCellReuseIdentifier: "TestCell")
        data.asObservable().subscribe { (event) in
            print("Data Changed")
            }.disposed(by: disposeBag)
        let tvAnimatedDataSource = RxTableViewSectionedAnimatedDataSource<SectionType>(
            configureCell:  { (_, tv, ip, i) in
                let cell = tv.dequeueReusableCell(withIdentifier: "TestCell") as? TestCell
                cell?.childView.labelTest.text = "\(i)"
                cell?.childView.stackViewExpand.isHidden = (i.number%2) == 0
                return cell!
        }
        )
//        tvAnimatedDataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .middle, deleteAnimation: .fade)
        
        
        data.asObservable()
            .bind(to: self.animatedTableView.rx.items(dataSource: tvAnimatedDataSource))
            .disposed(by: disposeBag)
        
        
        // touches
        refreshButton.rx.tap.bind{
//            self.data.value[0].numbers.append(IntItem(number: 1000, date: Date()))
            let lower : UInt32 = 1000
            let upper : UInt32 = 1020
            let randomNumber = arc4random_uniform(upper - lower) + lower
            self.data.value[1].items[0]=IntItem1(number: Int(randomNumber))
            }.disposed(by: disposeBag)
        Observable.of(
           
            animatedTableView.rx.modelSelected(IntItem1.self)
           
            )
            .merge()
            .subscribe(onNext: { item in
                  self.data.value[0].items[0]=IntItem1(number: 400)
                print("Let me guess, it's .... It's \(item), isn't it? Yeah, I've got it.")
            })
            .disposed(by: disposeBag)
    }
}



func `$`(_ numbers: [Int]) -> [IntItem1] {
    return numbers.map { IntItem1(number: $0) }
}

