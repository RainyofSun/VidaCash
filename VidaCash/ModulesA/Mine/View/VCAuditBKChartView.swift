//
//  VCAuditBKChartView.swift
//  VidaCash
//
//  Created by Yu Chen  on 2025/3/22.
//
/**
 https://blog.csdn.net/weixin_41355810/article/details/107559498
 https://blog.csdn.net/weixin_41355810/category_10230094.html
 */
import UIKit
import DGCharts

class VCAuditBKChartView: UIView {
    
    private lazy var graidentView: VCAPPGradientView = {
        let view = VCAPPGradientView(frame: CGRectZero)
        view.createGradient(gradientColors: [UIColor.init(white: 1, alpha: 0.56), UIColor.white, UIColor.hexStringColor(hexString: "#FFE0D4", alpha: 0.05)])
        return view
    }()
    
    private lazy var totalLab: UILabel = UILabel.buildVdidaCashNormalLabel(font: UIFont.specialFont(26), labelColor: UIColor.hexStringColor(hexString: "#1C1B1F"))
    
    //折线图
    private lazy var chartView: LineChartView = LineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        chartView.xAxis.labelPosition = .bottom //x轴显示在下方
        chartView.xAxis.labelTextColor = UIColor.hexStringColor(hexString: "#3C3C43") //刻度文字颜色
        chartView.xAxis.labelFont = .systemFont(ofSize: 9) //刻度文字大小
        chartView.xAxis.gridLineDashLengths = [4,2] //虚线各段长度
        chartView.xAxis.forceLabelsEnabled = true
        chartView.xAxis.granularityEnabled = true
        chartView.rightAxis.enabled = false //禁用右侧的Y轴
        chartView.leftAxis.axisMinimum = 0 //最小刻度值
        chartView.leftAxis.axisMaximum = 1000000 //最大刻度值
        chartView.leftAxis.granularity = 5000 //最小间隔
        chartView.leftAxis.labelTextColor = UIColor.hexStringColor(hexString: "#3C3C43") //刻度文字颜色
        chartView.leftAxis.labelFont = .systemFont(ofSize: 9) //刻度文字大小
        chartView.leftAxis.gridLineDashLengths = [4,2] //虚线各段长度
//        let formatter = NumberFormatter() //自定义格式
//        formatter.positiveSuffix = "K" //数字前缀
//        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        
        // 修改图例
        chartView.legend.enabled = false
        chartView.delegate = self
        // 动画效果
        chartView.animate(yAxisDuration: 3, easingOption: .easeOutCubic)
        
        self.addSubview(self.graidentView)
        self.addSubview(self.totalLab)
        self.addSubview(self.chartView)
        
        self.graidentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview()
        }
        
        self.totalLab.snp.makeConstraints { make in
            make.left.equalTo(self.graidentView).offset(PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(PADDING_UNIT * 6)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.graidentView).inset(PADDING_UNIT * 4)
            make.top.equalTo(self.totalLab.snp.bottom).offset(PADDING_UNIT * 3)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.graidentView.bounds != .zero {
            self.graidentView.jk.addCorner(conrners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    public func reloadChartSource(_ values: [Double], xValues: [String]) {
        let _total = values.map {$0}.reduce(0, +)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2 // 保留两位小数
         
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: _total)) {
            self.totalLab.text = formattedNumber
        }
        
        var dataEntries = [ChartDataEntry]()
        values.enumerated().forEach { (idx: Int, item: Double) in
            let entry = ChartDataEntry.init(x: Double(idx), y: item)
            dataEntries.append(entry)
        }
        
        //这10条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "图例1")
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        chartDataSet.mode = .horizontalBezier //贝塞尔曲线
        chartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
        //将线条颜色设置为橙色
        chartDataSet.colors = [RED_COLOR_F21915]
        //修改线条大小
        chartDataSet.lineWidth = 2
        //设置折线图数据
        chartView.data = chartData
        //自定义刻度标签文字
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        chartView.xAxis.labelCount = xValues.count
        chartView.xAxis.granularity = 1
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = Double(xValues.count - 1)
    }
}

extension VCAuditBKChartView: ChartViewDelegate {
    //折线上的点选中回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("选中了一个数据")
        //显示该点的MarkerView标签
        self.showMarkerView(value: "\(entry.y)")
    }
    
    //显示MarkerView标签
    func showMarkerView(value:String){
        let marker = MarkerView(frame: CGRect(x: 20, y: 20, width: 80, height: 20))
        marker.chartView = self.chartView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        label.text = "data：\(value)"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        marker.addSubview(label)
        self.chartView.marker = marker
    }
    
    //折线上的点取消选中回调
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("取消选中的数据")
    }
    
    //图表通过手势缩放后的回调
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("图表缩放了")
    }
    
    //图表通过手势拖动后的回调
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("图表移动了")
    }
}

class CustomValueFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        VCAPPCocoaLog.debug(" ------- \n \(value) \n -------")
        
        return String(format: "%fK", value)
    }
}
