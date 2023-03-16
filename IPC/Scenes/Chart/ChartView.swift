//
//  ChartView.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import UIKit
import SwiftUI
import Charts

final class ChartView: BaseView<ChartView.UIModel, ChartView.Actions> {
    /// Notify to the view controller that the user has interacted with the view.
    enum Actions {
        /// Notify the view controller the value of the switch has changed.
        case valueChanged(on: Bool)
    }
    
    struct UIModel {
        let data: [ChartUIData]
        let simulationEnabled: Bool
    }
    
    private lazy var chartInformation: ChartInformation = {
        .init(values: [])
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.prepareForAutolayout()
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.prepareForAutolayout()
        
        return view
    }()
    
    private lazy var chartView: UIView = {
        let vc = UIHostingController(rootView: LineUIChartView(data: chartInformation))
        guard let view = vc.view else {
            fatalError()
        }
        
        view.prepareForAutolayout()
        
        return view
    }()
    
    private lazy var lineChartView: LineChartView = {
        let view = LineChartView()
        view.marker = nil
        view.prepareForAutolayout()
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutolayout()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var switchLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "chart-data-simulate-real-time".localized
        
        return label
    }()
    
    private lazy var realTimeSwitch: UISwitch = {
        let view = UISwitch()
        view.prepareForAutolayout()
        view.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        return view
    }()
    
    override func addSubviews() {
        self.backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(chartView)
        contentView.addSubview(lineChartView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(switchLabel)
        stackView.addArrangedSubview(realTimeSwitch)
    }
    
    override func setConstraints() {
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ]
        
        let chartViewConstraints = [
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 16),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let lineChartViewConstraints = [
            lineChartView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 8),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: lineChartView.trailingAnchor, constant: 16),
            lineChartView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 8),
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints
                                    + contentViewConstraints
                                    + chartViewConstraints
                                    + lineChartViewConstraints
                                    + stackViewConstraints
        )
    }
    
    override func updateUI() {
        guard let uiModel else { return }
        realTimeSwitch.setOn(uiModel.simulationEnabled, animated: true)
        chartInformation.values = uiModel.data
        lineChartView.data = transform(data: uiModel.data)
    }
    
    private func transform(data: [ChartUIData]) -> ChartData {
        let entries = data.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element.y) }
        let dataSet = LineChartDataSet(entries: entries, label: "IPC")
        dataSet.setColor(.black)
        dataSet.lineWidth = 2
        dataSet.formLineWidth = 2
        dataSet.circleRadius = 0
        
        let chartData = LineChartData(dataSet: dataSet)
        chartData.setDrawValues(false)
        
        return chartData
    }
    
    @objc
    func switchValueChanged() {
        actionHandler?(.valueChanged(on: realTimeSwitch.isOn))
    }
                       
}
