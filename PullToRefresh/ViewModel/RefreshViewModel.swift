//
//  RefreshViewModel.swift
//  PullToRefresh
//
//  Created by Akhilgov Magomed Abdulmazhitovich on 08.08.2022.
//

import SwiftUI

class RefreshViewModel: ObservableObject {
    @Published var started: Bool
    @Published var released: Bool
    @Published var invalid: Bool = false
    
    var posts: [String] =  ["New post", "New post"]
    
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    
    init(
        startOffset: CGFloat = 0,
        offset: CGFloat = 0,
        started: Bool,
        released: Bool,
        invalid: Bool = false
    ) {
        self.startOffset = startOffset
        self.offset = offset
        self.started = started
        self.released = released
        self.invalid = invalid
    }
    
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.linear) {
                if self.startOffset == self.offset {
                    self.released = false
                    self.started = false
                    self.posts.append("New post")
                } else {
                    self.invalid = true
                }
            }
        }
    }
}

