//
//  Home.swift
//  PullToRefresh
//
//  Created by Akhilgov Magomed Abdulmazhitovich on 08.08.2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var refresh = RefreshViewModel(started: false, released: false)
    
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
                            refresh.updateData()
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                            refresh.invalid = false
                            refresh.updateData()
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
                        ForEach(refresh.posts, id: \.self) { post in
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
