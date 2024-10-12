//
//  ViewModelType.swift
//  ListContacts
//
//  Created by Kevin on 10/12/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input, cancelBag: CancelBag) -> Output
}
