//
//  XYPlotPlotModel.swift
//  XYPlotForSwift
//
//  Created by Jim Hanson on 4/9/21.
//

import SwiftUI
import Wacoma

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

    public mutating func selectLayer(_ index: Int) {
        for idx in layers.indices {
            layers[idx].showing = false
        }
        layers[index].showing = true
    }

    public mutating func selectLayer(withName name: String) -> Bool {
        for idx in layers.indices {
            if layers[idx].name == name {
                selectLayer(idx)
                return true
            }
        }
        return false
    }

    public mutating func selectLayer(withTitle title: String) -> Bool {
        for idx in layers.indices {
            if layers[idx].title == title {
                selectLayer(idx)
                return true
            }
        }
        return false
    }

    public func getCaption(forLayerWithName name: String) -> String {
        for idx in layers.indices {
            if layers[idx].name == name {
                return layers[idx].caption
            }
        }
        return ""
    }

    public mutating func setCaption(forLayerWithName name: String, _ caption: String) {
        for idx in layers.indices {
            if layers[idx].name == name {
                layers[idx].caption = caption
            }
        }
    }
}

public struct XYLayer {

    public let name: String

    public var title: String {
        return "\(yAxisLabels.name) vs. \(xAxisLabels.name)"
    }

    public var xAxisLabels: AxisLabels

    public var yAxisLabels: AxisLabels

    public var lines = [XYLine]()

    public var caption: String = ""

    public var showing: Bool

    var lineColors: PresetColorIterator

    var fallbackLineColor: Color = .gray

    public init(_ dataSource: XYDataSource, _ showing: Bool) {
        self.name = dataSource.name
        self.xAxisLabels = XYLayer.makeXAxisLabels(dataSource)
        self.yAxisLabels = XYLayer.makeYAxisLabels(dataSource)
        self.showing = showing
        self.lineColors = PresetColorSequence().makeIterator()
        for dataSet in dataSource.dataSets {
            lines.append(XYLine(dataSet, makeStyle(dataSet)))
        }
    }

    private static func makeXAxisLabels(_ dataSource: XYDataSource) -> AxisLabels {
        return AxisLabels(name: dataSource.xAxisName, units: dataSource.xAxisUnits)
    }

    private static func makeYAxisLabels(_ dataSource: XYDataSource) -> AxisLabels {
        return AxisLabels(name: dataSource.yAxisName, units: dataSource.yAxisUnits)

    }

    private mutating func makeStyle(_ dataSet: XYDataSet) -> XYLineStyle {
        if let color = dataSet.color {
            return XYLineStyle(color: color)
        }
        else {
            return XYLineStyle(color: lineColors.next() ?? fallbackLineColor)
        }
    }
}

public struct XYLine {

    var label: String {
        return dataSet.name ?? ""
    }

    var color: Color {
        return style.color
    }
    
    public var dataSet: XYDataSet

    public var style: XYLineStyle

    public init(_ dataSet: XYDataSet, _ style: XYLineStyle) {
        self.dataSet = dataSet
        self.style = style
    }
}

public struct XYLineStyle {

    public var color = Color.white
}

public struct AxisLabels {

    public var name: String

    public var units: String?

    init(name: String, units: String? = nil) {
        self.name = name
        self.units = units
    }

    func makeLabel(_ exponent: Int) -> String {
        if let units = units {
            if exponent == 0 {
                return "\(name) (\(units))"
            }
            else if exponent == 1 {
                return "\(name) (\(units) x 10)"
            }
            else {
                return "\(name) (\(units) x 10^\(exponent))"
            }
        }
        else {
            if exponent == 0 {
                return name
            }
            else if exponent == 1 {
                return "\(name) (x 10)"
            }
            else {
                return "\(name) (x 10^\(exponent))"
            }
        }
    }
}

