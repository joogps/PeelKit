//
//  ContentView.swift
//  PeelKit
//
//  Created by João Gabriel Pozzobon dos Santos on 28/04/24.
//

import SwiftUI

struct ContentView: View {
    @State var amount = 0.0
    
    var a: CGFloat {
        amount+100.0
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ZStack {
                Color.orange
                    .overlay(LinearGradient(colors: [.init(white: 0.2), .init(white: 0.5)], startPoint: .top, endPoint: .bottom).blendMode(.overlay))
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .clipShape(PeelMask(peelAmount: a))
                
                GeometryReader { geo in
                    let angle = min(25+a/5, 90)-0.01
                    let x = a*tan(angle/180.0*Double.pi)
                    
                    let unitPoint = UnitPoint(x: x/2/geo.size.width, y: a/2/geo.size.height)
                    
                    Color.red
                        .overlay(LinearGradient(colors: [.init(white: 0.3), .init(white: 0.8)], startPoint: .top, endPoint: .bottom).blendMode(.overlay))
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .clipShape(TabMask(peelAmount: a))
                        .rotationEffect(.degrees(180.0-angle*2), anchor: unitPoint)
                        .offset(y: geo.size.height-a)
                        .shadow(color: .red, radius: 10)
                }
            }
            .padding(32)
        }
        .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let distance = sqrt(pow(value.translation.width, 2)+pow(value.translation.height, 2))
                        amount = max(0, CGFloat(distance*2))
                    }
            .onEnded { _ in
                amount = 0
            })
        
    }
}

struct PeelMask: Shape {
    var peelAmount: CGFloat
    
    var animatableData: Double {
        get { peelAmount }
        set { peelAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            
            let a = min(25+peelAmount/5, 90)-0.01
            let x = peelAmount*tan(a/180.0*Double.pi)
            
            path.addLine(to: CGPoint(x: x, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height-peelAmount))
        }
    }
}

struct TabMask: Shape {
    var peelAmount: CGFloat
    
    var animatableData: Double {
        get { peelAmount }
        set { peelAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let a = min(25+peelAmount/5, 90)-0.01
            let x = peelAmount*tan(a/180.0*Double.pi)
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: 0, y: peelAmount))
        }
    }
}


#Preview {
    ContentView()
}
