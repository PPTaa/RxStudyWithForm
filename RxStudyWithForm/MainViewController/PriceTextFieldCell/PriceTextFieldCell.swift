//
//  PriceTextFieldCell.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    let freeShareBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel) {
        // ViewModel -> View
        viewModel.showFreeShareBtn
            .map { !$0 }
            .emit(to: freeShareBtn.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.resetPrice
            .map { _ in "" }
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        // View -> ViewModel
        
        priceInputField.rx.text
            .bind(to: viewModel.priceValue)
            .disposed(by: disposeBag)
        
        freeShareBtn.rx.tap
            .bind(to: viewModel.freeShareBtnTapped)
            .disposed(by: disposeBag)
        
        
    }
    
    private func layout() {
        [freeShareBtn, priceInputField].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        freeShareBtn.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
        
        
        
    }
    
    private func attribute() {
        freeShareBtn.setTitle("무료나눔", for: .normal)
        freeShareBtn.setTitleColor(.red, for: .normal)
        freeShareBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeShareBtn.titleLabel?.font = .systemFont(ofSize: 18)
        freeShareBtn.tintColor = .orange
        freeShareBtn.backgroundColor = .lightGray
        freeShareBtn.isHidden = false
        freeShareBtn.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
        
        
    }
}
