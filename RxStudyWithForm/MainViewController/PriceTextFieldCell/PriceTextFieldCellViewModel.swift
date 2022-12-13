//
//  PriceTextFieldCellViewModel.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    
    // ViewModel -> View
    let showFreeShareBtn: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    // UI변경이 일어나기 때문에 relay로 작성
    let priceValue = PublishRelay<String?>()
    let freeShareBtnTapped = PublishRelay<Void>()
    
    init() {
        self.showFreeShareBtn = Observable
            .merge(
                // priceValue가 0 인경우
                priceValue.map { $0 ?? "" == "0" },
                // freeShareBtnTapped가 눌렸을 때인 경우
                freeShareBtnTapped.map { _ in false }
            )
            .asSignal(onErrorJustReturn: false)
        // freeShareBtnTapped를 눌렀을 경우 리셋
        self.resetPrice = freeShareBtnTapped
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
