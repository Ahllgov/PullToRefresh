//
//  Home.swift
//  PullToRefresh
//
//  Created by Akhilgov Magomed Abdulmazhitovich on 08.08.2022.
//

import SwiftUI

struct Home: View {
    
    @State var newPost = ["New post", "New post", "New post", "New post", "New post", "New post"]
    @State var refresh = Refresh(started: false, released: false)
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("News")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.indigo)
                
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea(.all, edges: .top))
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                GeometryReader { reader -> AnyView in
                        
                    DispatchQueue.main.async {
                        if refresh.startOffset == 0 {
                            refresh.startOffset = reader.frame(in: .global).minY
                        }
                        refresh.offset = reader.frame(in: .global).minY
                        
                        if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                            refresh.started = true
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                            withAnimation(Animation.linear) { refresh.released = true }
                            updateData()
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                            refresh.invalid = false
                            updateData()
                        }
                    }
                    
                    return AnyView(Color.black.frame(width: 0, height: 0))
                }
                .frame(width: 0, height: 0)
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    if refresh.started && refresh.released {
                        ProgressView()
                            .offset(y: -35)
                    } else {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                            .animation(.easeIn)
                            .offset(y: -25)
                    }
                    
                    VStack {
                        ForEach(newPost, id: \.self) { post in
                            HStack {
                                Text(post)
                                    Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                        }
                    }
                    .padding(.top)
                    .background(Color.white)
                }
                .offset(y: refresh.released ? 40 : -10)
            }
            
            Spacer()
        }
        .background(Color.gray.opacity(0.06))
    }
    
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset {
                    refresh.released = false
                    refresh.started = false
                    newPost.append("New post")
                } else {
                    refresh.invalid = true
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}
