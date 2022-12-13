//
//  DetailWriteFormCellViewModel.swift
//  RxStudyWithForm
//
//  Created by leejungchul on 2022/12/13.
//

import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    // view -> viewModel
    let contentValue = PublishRelay<String?>()
}
