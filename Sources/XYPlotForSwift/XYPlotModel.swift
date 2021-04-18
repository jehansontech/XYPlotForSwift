//
//  XYPlotConfig.swift
//  ArcWorld
//
//  Created by Jim Hanson on 4/9/21.
//

import SwiftUI


public struct XYLineStyle {

    public var color = Color.white
}

public struct AxisLabels {

    public var name: String
}

public struct XYLine {

    public var dataSet: XYDataSet

    public var style: XYLineStyle

    public init(_ dataSet: XYDataSet, _ style: XYLineStyle) {
        self.dataSet = dataSet
        self.style = style
    }
}

public struct XYLayer {

    public var title: String {
        return "\(yAxisLabels.name) vs. \(xAxisLabels.name)"
    }

    public var xAxisLabels: AxisLabels

    public var yAxisLabels: AxisLabels

    public var lines = [XYLine]()

    public var showing: Bool

    public init(_ dataSource: XYDataSource, _ showing: Bool) {
        self.xAxisLabels = XYLayer.makeXAxisLabels(dataSource)
        self.yAxisLabels = XYLayer.makeYAxisLabels(dataSource)
        self.showing = showing

        for dataSet in dataSource.dataSets {
            lines.append(XYLine(dataSet, makeStyle(dataSet)))
        }
    }

    private static func makeXAxisLabels(_ dataSource: XYDataSource) -> AxisLabels {
        return AxisLabels(name: dataSource.xAxisName)
    }

    private static func makeYAxisLabels(_ dataSource: XYDataSource) -> AxisLabels {
        return AxisLabels(name: dataSource.yAxisName)

    }

    private func makeStyle(_ dataSet: XYDataSet) -> XYLineStyle {
        if let color = dataSet.color {
            return XYLineStyle(color: color)
        }
        else {
            return XYLineStyle()
        }
    }
}

public struct XYPlotModel {

    public var layers = [XYLayer]()

    public init(_ dataSource: XYDataSource) {
        layers.append(XYLayer(dataSource, true))
    }

    public init(_ dataSources: [XYDataSource]) {
        var showing = true
        for dataSource in dataSources {
            layers.append(XYLayer(dataSource, showing))
            showing = false
        }
    }
 }