//
//  ChartViewSwiftIUI.swift
//  StockAppDemo
//
//  Created by Suppanat Chinthumrucks on 15/11/2567 BE.
//

import Charts
import SwiftUI

// MARK: ChartType

public enum ChartType {
    case line
    case bar
    case pie
}

// MARK: ChartView

@available(iOS 16.0, *)
public struct ChartView: View {
    var width: CGFloat
    var height: CGFloat
    var type: ChartType
    var data: [ChartViewData]

    public init(width: CGFloat, height: CGFloat, type: ChartType, data: [ChartViewData]) {
        self.width = width
        self.height = height
        self.type = type
        self.data = data
    }

    public var body: some View {
        switch type {
        case .line:
            return LineChartView(width: width,
                                 height: height)
        default:
            return LineChartView(width: width,
                                 height: height)
        }
    }
}

// MARK: LineChart

@available(iOS 16.0, *)
public struct LineChartView: View {
    let data: [ChartViewData] = ChartViewDataModel.mockChartData()
    let width: CGFloat
    let height: CGFloat

    public var body: some View {
        let maxPriceData = self.data.max(by: { $0.price < $1.price })
        let minPriceData = self.data.min(by: { $0.price < $1.price })
        let maxPrice = maxPriceData?.price ?? 0.00
        let minPrice = minPriceData?.price ?? 0.00
        let yLabel = [minPrice, (maxPrice + minPrice)/2 ,maxPrice]

        ZStack {
            // New
            Chart {
                // Create Line Chart
                ForEach(self.data, id: \.id) { value in
                    LineMark(x: .value("", value.date),
                             y: .value("", value.price))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(.green)

                PointMark(x: .value("", maxPriceData?.date ?? ""),
                          y: .value("", maxPriceData?.price ?? 0.00))
                    .annotation(position: .top) {
                        Text("\(maxPriceData?.price ?? 0.00, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .symbolSize(0)

                PointMark(x: .value("", minPriceData?.date ?? ""),
                          y: .value("", minPriceData?.price ?? 0.00))
                    .annotation(position: .bottom) {
                        Text("\(minPriceData?.price ?? 0.00, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .symbolSize(0)
            }
            .chartYScale(domain: minPrice...maxPrice)
            .chartYAxis {
                AxisMarks(position: .leading, values: yLabel) { value in
                    AxisValueLabel {
                        if let price = value.as(Double.self) {
                            Text(String(format: "%.2f", price))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { _ in }
            }
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .padding()
        .frame(width: width, height: height)
    }
}

// MARK: Chart Data Model

public struct ChartViewDataModel: Identifiable {
    public let id = UUID()
    public var data: [ChartViewData]

    static func mockChartData() -> [ChartViewData] {
        return [
            ChartViewData(date: "1", price: 10.00),
            ChartViewData(date: "2", price: 11.00),
            ChartViewData(date: "3", price: 10.00),
            ChartViewData(date: "4", price: 13.00),
            ChartViewData(date: "5", price: 12.00),
            ChartViewData(date: "6", price: 17.00),
            ChartViewData(date: "7", price: 15.00),
            ChartViewData(date: "8", price: 13.00),
            ChartViewData(date: "9", price: 11.00),
            ChartViewData(date: "10", price: 10.00)
        ]
    }
}

public struct ChartViewData {
    public let id = UUID()
    public var date: String
    public var price: Double

    init(date: String, price: Double) {
        self.date = date
        self.price = price
    }
}
