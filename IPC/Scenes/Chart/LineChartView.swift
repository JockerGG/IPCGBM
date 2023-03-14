//
//  LineChartView.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import SwiftUI

struct ChartData {
    let y: CGFloat
    let x: String
}

struct LineChartView: View {
    var elements: [ChartData] = []
    private var data: [CGFloat] {
        elements.map { $0.y }
    }
    
    private var labels: [String] {
        elements.map { $0.x }
    }
    
    @State private var currentPlot: String = ""
    @State private var currentLabel: String = ""
    @State private var offset: CGSize = .zero
    @State private var showPlot = false
    @State private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width / CGFloat(data.count - 1))
            let maxPoint = Unwrapper.unwrap(data.max(),
                                            defaultValue: 0) + 100
            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5,
                                         lineCap: .round,
                                         lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color.black,
                        Color.black
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                fillBG()
                
                    .clipShape(
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(points)
                            path.addLine(to: .init(x: proxy.size.width,
                                                   y: height))
                            path.addLine(to: .init(x: 0,
                                                   y: height))
                        }
                    )
                //                .padding(.top, 12)
            }
            .overlay(
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.indigo, in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color.indigo)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(Color.indigo)
                        .frame(width: 1, height: 50)
                    
                    Text(currentLabel)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.indigo, in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                }
                    .frame(width: 80, height: 150)
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }
                translation = value.location.x - 40
                
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                currentLabel = labels[index]
                
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                
                
            }).onEnded({ value in
                withAnimation { showPlot = false }
            }))
        }
        .overlay(
            VStack(alignment: .leading) {
                let max = Unwrapper.unwrap(data.max(), defaultValue: 0)
                Text("\(max)")
                    .font(.caption.bold())
    
                Spacer()
                
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func fillBG() -> some View {
        let gradientArray: [Color] = [
            Color.blue.opacity(0.3),
            Color.blue.opacity(0.2),
            Color.blue.opacity(0.1),
        ]
        
        let repeatedArray: [Color] = Array(repeating: Color.blue.opacity(0.1),
                                           count: 4)
        let repeatedClearArray: [Color] = Array(repeating: Color.clear,
                                                count: 2)
        
        LinearGradient(colors:  gradientArray + repeatedArray + repeatedClearArray, startPoint: .top, endPoint: .bottom)
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(elements: [
            .init(y: 989, x: "01/01/2023"),
                .init(y: 1200, x: "02/01/23"),
                .init(y: 750, x: "03/01/23"),
                .init(y: 790, x: "04/01/23"),
                .init(y: 650, x: "04/01/23"),
                .init(y: 950, x: "04/01/23"),
                .init(y: 1200, x: "04/01/23"),
                .init(y: 600, x: "04/01/23"),
                .init(y: 500, x: "04/01/23"),
                .init(y: 600, x: "04/01/23"),
                .init(y: 890, x: "04/01/23"),
                .init(y: 1203, x: "04/01/23"),
                .init(y: 1400, x: "04/01/23"),
                .init(y: 900, x: "04/01/23"),
                .init(y: 1250, x: "04/01/23"),
                .init(y: 1600, x: "04/01/23"),
                .init(y: 1200, x: "04/01/23")
        ])
        .frame(height: 250)
    }
}
