//
//  ChartView.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import UIKit
import SwiftUI

final class ChartView: BaseView<ChartView.UIModel, ChartView.Actions> {
    enum Actions { }
    
    struct UIModel {
        let data: [ChartData]
    }
    
    private lazy var chartInformation: ChartInformation = {
        .init(values: [])
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutolayout()
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: nil)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.text = "chart-view-title".localized
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var chartView: UIView = {
        let vc = UIHostingController(rootView: LineChartView(data: chartInformation))
        guard let view = vc.view else {
            fatalError()
        }
        
        view.prepareForAutolayout()
        
        return view
    }()
    
    override func addSubviews() {
        self.backgroundColor = .white
        addSubview(titleLabel)
        addSubview(chartView)
    }
    
    override func setConstraints() {
        let labelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 24)
        ]
        
        let chartViewConstraints = [
            chartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 16),
            chartView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            chartView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        NSLayoutConstraint.activate(labelConstraints + chartViewConstraints)
    }
    
    override func updateUI() {
        guard let uiModel else { return }
        chartInformation.values = uiModel.data
    }
}
