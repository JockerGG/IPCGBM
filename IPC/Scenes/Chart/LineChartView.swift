//
//  LineChartView.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import SwiftUI

struct LineChartView: View {
    @ObservedObject var data: ChartInformation = .init(values: [])
    @State private var currentPlot: String = ""
    @State private var currentLabel: String = ""
    @State private var offset: CGSize = .zero
    @State private var showPlot = false
    @State private var translation: CGFloat = 0
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let elements = data.values
                let height = proxy.size.height
                let width = (proxy.size.width / CGFloat(elements.count - 1))
                let maxPoint = Unwrapper.unwrap(elements.map { $0.y }.max(),
                                                defaultValue: 0) + 100
                let points = elements.enumerated().compactMap { (itemOffset, item) -> CGPoint in
                    let progress = item.y / maxPoint
                    let pathHeight = progress * height
                    let pathWidth = width * CGFloat(itemOffset)
                    
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
                        ZStack {
                            Capsule()
                                .frame(height: 25)
                            Text(currentPlot)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        
                        Rectangle()
                            .fill(.purple)
                            .frame(width: 1, height: 40)
                            .padding(.top)
                        
                        Circle()
                            .fill(.purple)
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(.purple)
                            .frame(width: 1, height: 50)
                        
                        ZStack {
                            Capsule()
                                .frame(height: 25)
                            Text(currentLabel)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
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
                    
                    let index = max(min(Int((translation / width).rounded(.down) + 1),
                                        elements.count - 1), 0)
                    
                    currentPlot = elements[index].y.currencyFormat()
                    currentLabel = elements[index].x
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                    
                    
                }).onEnded({ value in
                    withAnimation { showPlot = false }
                }))
            }
            .overlay(
                VStack(alignment: .leading) {
                    let max = Unwrapper.unwrap(data.values.map { $0.y } .max(), defaultValue: 0)
                    Text(max.currencyFormat())
                        .font(.caption.bold())
        
                    Spacer()
                    
                    Text("$0")
                        .font(.caption.bold())
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
            .padding(.top, 8)
            .padding(.bottom, 8)
            .padding(.leading, 2)
            .padding(.trailing, 2)
        }
        .border(.blue)
        .padding(8)
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
        let object = ChartInformation(values: [])
        let view: LineChartView = LineChartView(data: object)
        
        object.values = [.init(y: 790, x: "04/01/23"),
                         .init(y: 790, x: "04/01/23"),
                         .init(y: 989, x: "01/01/23"),
                         .init(y: 2000, x: "01/01/23")
        ]
        
        return view
    }
}
