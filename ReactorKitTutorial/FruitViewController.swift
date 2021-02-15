//
//  FruitViewController.swift
//  ReactorKitTutorial
//
//  Created by Dustin on 2021/02/15.
//

import UIKit
import ReactorKit
import RxCocoa


class FruitViewController : UIViewController {
    
    //MARK: - Properties
    
    private lazy var appleButton : UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("사과", for: .normal)
        return bt
    }()
    
    private lazy var bananaButton : UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("바나나", for: .normal)
        return bt
    }()
    
    private lazy var grapesButton : UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle("포도", for: .normal)
        return bt
    }()
    
    
    private lazy var selectedLabel : UILabel = {
        let lb = UILabel()
        lb.text = "선택되어진 과일 없음"
        return lb
    }()
    
    
    private lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appleButton,bananaButton,grapesButton,selectedLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    //MARK: - Binding Properties
    let disposeBag = DisposeBag()
    let fruitReact = FruitReactor()
    
    
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(reactor: fruitReact)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func bind(reactor:FruitReactor) {
        appleButton.rx.tap.map {
            FruitReactor.Action.apple
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        bananaButton.rx.tap.map {
            FruitReactor.Action.banana
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        grapesButton.rx.tap.map {
            FruitReactor.Action.grapes
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state.map {
            $0.fruitName
        }.distinctUntilChanged()
        .map { $0 }
        .subscribe(onNext : {
            val in
            self.selectedLabel.text = val
        })
        .disposed(by: disposeBag)
        
        reactor.state.map {
            $0.isLoading
        }.distinctUntilChanged()
        .map { $0 }
        .subscribe(onNext: {
            val in
            if val == true {
                self.selectedLabel.text = "로딩 중 입니다."
            }
        }).disposed(by: disposeBag)
    }
    
    
}
