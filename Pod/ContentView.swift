//
//  ContentView.swift
//  Pod
//
//  Created by Levent on 29.05.2023.
//

import SwiftUI

struct ContentView: View {
    // Animation properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    var body: some View {
        
        // tab view
        TabView {
            ListenNow()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Listen Now")
                }
            // changing tab background color
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            // Hiding tab bar when sheet is extended
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            
            SampleTab("Listen Now", "play.circle.fill")
            SampleTab("Browse", "square.grid.2x2.fill")
            SampleTab("Radio", "dot.radiowaves.left.and.right")
            SampleTab("Music", "play.circle.fill")
            SampleTab("Search", "magnifyingglass")
        }
        // Changing Tab indicator color
        .tint(.red)
        .safeAreaInset(edge: .bottom) {
            CustomBottomSheet()
        }
        .overlay(content: {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                
                // transition for more flluent animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        })
    }
    // Custom listen now view
    @ViewBuilder
    func ListenNow() -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ZStack {
                        Image("AppleMusicBG")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                        
                        Image("AppleMusic")
                            .resizable()
                            .scaledToFit()
                        VStack {
                            Text("100 million songs to play or download. All ad-free")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                            Spacer()
                            HStack {
                                Text("Try it now")
                                    .bold()
                                
                                Image(systemName: "chevron.right.circle.fill")
                            }
                        }
                        .padding()
                        .padding(.vertical)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
//                    .background(Color("BG"))
                    .cornerRadius(16)
                    .padding()
                    
                }
                VStack(spacing: 20) {
                    ZStack {
                        
                        Image("OutofStock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        VStack {
                            Text("Get 1 month free to explore Apple Music Inc.")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                            Spacer()
                            HStack {
                                Text("Try it now")
                                    .bold()
                                
                                Image(systemName: "chevron.right.circle.fill")
                            }
                        }
                        .padding()
                        .padding(.vertical)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .background(.green.opacity(0.22))
                    .cornerRadius(16)
                    .padding()
                    
                }

            }
        }
        .navigationTitle("Listen Now")
    }
    
    
    // Custom bottom sheet
    @ViewBuilder
    func CustomBottomSheet() -> some View {
        // animating sheet background ( to look ilek it's expending from the bottom)
        
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        // Music Info
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                    })
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: 70)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .offset(y: -5)
        })
        .offset(y: -49)
    }
    
    @ViewBuilder
    func SampleTab(_ title: String, _ icon: String) -> some View {
        Text(title)
            .tabItem {
                Image(systemName: icon)
                Text(title)
            }
        // changing tab background color
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        // Hiding tab bar when sheet is extended
            .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Reusuable File
struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    var body: some View {
        HStack(spacing: 0) {
            // adding match geomerty effect (hero animation)
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        
                        Image("bagirdir")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "bagirdir", in: animation)
                }
            }
            .frame(width: 45, height: 45)
            
            Text("OUt of Stock")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            // expending bottom sheet
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}
