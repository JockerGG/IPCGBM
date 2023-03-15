//
//  ChartView.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import UIKit
import SwiftUI

final class ChartView: BaseView<ChartView.UIModel, ChartView.Actions> {
    enum Actions {
        case valueChanged(value: Int)
    }
    
    struct UIModel {
        let data: [ChartData]
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
        addSubview(scrollView)
        addSubview(titleLabel)
        scrollView.addSubview(contentView)
        contentView.addSubview(chartView)
    }
    
    override func setConstraints() {
        let labelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 24)
        ]
        
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
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
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        NSLayoutConstraint.activate(labelConstraints
                                    + scrollViewConstraints
                                    + contentViewConstraints
                                    + chartViewConstraints)
    }
    
    override func updateUI() {
        guard let uiModel else { return }
        chartInformation.values = uiModel.data
    }

}
