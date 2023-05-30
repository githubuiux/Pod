//
//  ExpandedBottomSheet.swift
//  Pod
//
//  Created by Levent on 29.05.2023.
//  07:58'de kaldım, oradan devam edilecek, setır 13

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    //View Properties
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                // Making it as rounded
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        Rectangle()
                        //.fill(Color("BG"))
                            .fill(.gray.opacity(0.4))
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                        // Disabling interaction (since its not necessary here)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                VStack(spacing: 15) {
                    // Grab indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    // Matching with slide animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    // artwork hero view
                    GeometryReader {
                        let size = $0.size
                        
                        Image("bagirdir")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        // for smoother travel the source view corner radius is updated from 5 to 15 in order to match the destination view corner radius which is 15
                            .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                        
                    }
                    .matchedGeometryEffect(id: "bagirdir", in: animation)
                    // for square artwork image
                    .frame(height: size.width - 50)
                    // for smaller device the paddign will be 10 and larger devices th epaddign will be 30
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    // player View
                    
                    PlayerView(size)
                    // moving it from bottom
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                // for testing UI
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        expandSheet = false
                        animateContent = false
                    }
                }
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)){
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        
        .onAppear() {
            withAnimation(.easeOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            // Dynamic spacing using available height
            let spacing = size.height * 0.04
            
            // Sizing it for more copact look
            VStack(spacing: spacing, content: {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15){
                        VStack(alignment: .leading) {
                            Text("Out of stock")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Jordan Mitxa")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    // Timing indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    // Timing View
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("3:33")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                // Moving it to top
                .frame(height: size.height / 2.5, alignment: .top)
                
                // playback controls
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                        // dynamic sizing for smaller
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    // Making play/pause little biggle
                    Button {
                        
                    } label: {
                        Image(systemName: "pause.fill")
                        // dynamic sizing for smaller
                            .font(size.height < 300 ? .title3 : .system(size: 50))
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                        // dynamic sizing for smaller
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }.foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                
                // Volume and Other
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speacker.fill")
                            .foregroundColor(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        Button {
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        
                        VStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            }
                            Text("Jet's Airpods")
                                .font(.caption)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                }
                // Moving it to the bottom
                .frame(height: size.height / 2.5, alignment: .bottom)
                
            })
        }
    }
}

struct ExpandedBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            
            return 0
        }
        return 0
    }
}
