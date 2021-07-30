//
//  GraphDetailsViewController.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 19/03/21.
//

import UIKit
import SnapKit
import Kingfisher
import GoogleMaps


enum GraphType: String {
    case confirmed, cured, deaths, world
}

enum SleepTrrendState: String {
    case week, month
}


class GraphDetailsViewController: UIViewController, UpdateProtocol {
   
    //MARK: Outlets
    @IBOutlet weak var pagerView: UIView!
    
    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet weak var slidingViewLedingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var worldWideConfirmCasesView: UIView!
    
    @IBOutlet weak var worldCasesYAxisRangeStackView: UIStackView!
    
    @IBOutlet weak var worldCasesScrollView: UIScrollView!
    
    @IBOutlet weak var worldCasesScrollViewContainerView: UIView!
    
    @IBOutlet weak var worldCasesXAxisRangeStackView: UIStackView!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var restToCurrentRangeButton: UIButton!
    
    @IBOutlet weak var restCurrentRangeHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var totalCasesLineGraphView: UIView!
    
    @IBOutlet weak var totalCasesYAxisStackView: UIStackView!
    
    @IBOutlet weak var totalCasesScrollView: UIScrollView!
    
    @IBOutlet weak var totalCasesScrollViewContainerView: UIView!
    
    @IBOutlet weak var totalCasesXaxisStackView: UIStackView!
    
    
    @IBOutlet weak var curedCasesGraphView: UIView!
    
    @IBOutlet weak var curedCasesYAxisStackView: UIStackView!
    
    @IBOutlet weak var curedCasesScrollView: UIScrollView!
    
    @IBOutlet weak var curedCasesScrollViewContainerView: UIView!
    
    @IBOutlet weak var curedCasesXAxisStackView: UIStackView!
    
    
    @IBOutlet weak var deathCasesGraphView: UIView!
    
    @IBOutlet weak var deathCasesYAxisStackView: UIStackView!
    
    @IBOutlet weak var deathCasesScrollView: UIScrollView!
    
    @IBOutlet weak var deathCasesScrollViewContainerView: UIView!
    
    @IBOutlet weak var deathCasesXAxisStackView: UIStackView!

    //MARK: Variables
    var currentState: SleepTrrendState = .week
    var currentDate = Date()
    var currentDatesInGraph = [Date]()
    var totalCovidData = [FullData]()
    var rowHeight: CGFloat = 42
    
    // world confirm cases
    var countryConfirmCasesBarViews = [UIView]()
    var countryConfirmCasesDefaultBarViews = [UIView]()
    var flageViews = [UIView]()
    var appData = AppData.sharedInstance
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: Default Function
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setCalendarComponentsBasedOn(state: currentState, date: currentDate)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addCornerRadius(view: pagerView, radius: pagerView.frame.height/2)
        addCornerRadius(view: slidingView, radius: slidingView.frame.height/2)
        addBorder(view: pagerView, withColor: #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.262745098, alpha: 1))
        
        for view in countryConfirmCasesBarViews {
            addCornerRadius(view: view, radius: 12/2)
            view.layoutIfNeeded()
        }
        
        for view in flageViews {
            addCornerRadius(view: view, radius: 12/2)
            view.layoutIfNeeded()
        }
        
        
        for data in totalCovidData {
            for roundView in data.roundedViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
            
            for roundView in data.recoverdRoundViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
            
            for roundView in data.deathsRoundViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
        }
    }
    
    
    func setup() {
        
        worldCasesScrollView.indicatorStyle = .white
        totalCasesScrollView.indicatorStyle = .white
        deathCasesScrollView.indicatorStyle = .white
        
        totalCovidData = appData.getCovidDataFromSelectedDateRange(date: currentDate, dateType: currentState)
        
    }
    
    func showSleepTerndsBasedOn(state: SleepTrrendState) {
        currentState = state
        let leadingConstraint = state == .month ? slidingView.frame.width : 0
        self.slidingViewLedingConstraint.constant = leadingConstraint
        self.setCalendarComponentsBasedOn(state: currentState, date: currentDate)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showRestButton(enable: Bool) {
        restToCurrentRangeButton.isHidden = !enable
        restCurrentRangeHeightConstraint.constant = enable ? 30 : 0
    }
    
    func setCalendarComponentsBasedOn(state: SleepTrrendState, date: Date) {
        showRestButton(enable: !date.startOfWeek1.isEqualThanDate(dateToCompare: Date().startOfWeek1))
        
        if state == .week {
            currentDatesInGraph = getAllWeekDaysOFSelectedDate(date: currentDate)
            let startOfTheWeek = currentDatesInGraph.first!
            let endOfTheWeek = currentDatesInGraph.last!
            
            let dateString = "\(startOfTheWeek.toDayString()) - \(endOfTheWeek.toDayAndMonthString())\n\(endOfTheWeek.toYearString())"
            dateLabel.text = dateString
        }else {
            currentDatesInGraph = currentDate.getAllDays()
            dateLabel.text = "\(date.toMonthString())\n\(date.toYearString())"
        }
        
        
        self.updateCalendarDetailsBasedOnSessions()
        
    }
    
    
    func getDateLabelForGraphXPostion(text: String, numberOfLines: Int = 1, bgColor: UIColor = .clear) -> UILabel {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = numberOfLines
        label.textAlignment = .center
        label.backgroundColor = bgColor
        return label
    }
    
    
    func getRangeLabelForYAxis(text: String, width: CGFloat, height: CGFloat, tag: Int) -> UILabel {
        let label = VerticalAlignLabel()
        label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.verticalAlignment = .top
        label.tag = tag
        return label
    }
    
    
    
    func updateCalendarDetailsBasedOnSessions() {
        
        currentDatesInGraph.removeAll()
        
        if currentState == .week {
            currentDatesInGraph = getAllWeekDaysOFSelectedDate(date: currentDate)
        }else {
            currentDatesInGraph = currentDate.getAllDays()
        }
        
    
        let confirmCases = totalCovidData.compactMap({$0.TotalConfirmed})
        let worldYPositionRanges = getYAxisRange(for: confirmCases.max()!)// crash when server getting time
        let worldXAxisValues: [String] = totalCovidData.compactMap({$0.country?.ISO2!})
        let worldYAxisValues: [String] = worldYPositionRanges.compactMap({String($0)})
        loadGraphInitialAxisSetup(xAxisStackView: worldCasesXAxisRangeStackView, yAxisStackView: worldCasesYAxisRangeStackView, graphType: .world, xAxisValues: worldXAxisValues, yAxisValues: worldYAxisValues, graphView: worldWideConfirmCasesView)
        
        
        // setting up confirmed cases line graph axis
        
        let dailyCovidData: [Covid] = totalCovidData.flatMap({$0.covidData!})
        let firstFiveCases = dailyCovidData.compactMap({$0.currentConfirmed!})
        let totalCasesYPositionRanges = getYAxisRange(for: firstFiveCases.max()!)
        
        
        
        let confirmedCasesXAxisValues: [String] = currentDatesInGraph.compactMap({"\($0.toDayInWeek())\n\($0.toDayString())"})
        let confirmedCasesYAxisValues: [String] = totalCasesYPositionRanges.compactMap({String($0)})
        loadGraphInitialAxisSetup(xAxisStackView: totalCasesXaxisStackView, yAxisStackView: totalCasesYAxisStackView, graphType: .confirmed, xAxisValues: confirmedCasesXAxisValues, yAxisValues: confirmedCasesYAxisValues, graphView: totalCasesLineGraphView)
        
        
        // recover cases
        let firstFiveRecoverdCaes = dailyCovidData.compactMap({$0.currentRecovered!})
        let recoveredCasesYPoistionRanges = getYAxisRange(for: firstFiveRecoverdCaes.max()!)
        
        let recoveredCasesXAxisValues: [String] = currentDatesInGraph.compactMap({"\($0.toDayInWeek())\n\($0.toDayString())"})
        let recoveredCasesYAxisValues: [String] = recoveredCasesYPoistionRanges.compactMap({String($0)})
        loadGraphInitialAxisSetup(xAxisStackView: curedCasesXAxisStackView, yAxisStackView: curedCasesYAxisStackView, graphType: .cured, xAxisValues: recoveredCasesXAxisValues, yAxisValues: recoveredCasesYAxisValues, graphView: curedCasesGraphView)
        
        // death cases
        let firstFiveDeathCases = dailyCovidData.compactMap({$0.currentDeaths!})
        let deathsCasesYPoistionRages = getYAxisRange(for: firstFiveDeathCases.max()!)
        
        let deathsCasesXAxisValues: [String] = currentDatesInGraph.compactMap({"\($0.toDayInWeek())\n\($0.toDayString())"})
        let deathsCasesYAxisValues: [String] = deathsCasesYPoistionRages.compactMap({String($0)})
        loadGraphInitialAxisSetup(xAxisStackView: deathCasesXAxisStackView, yAxisStackView: deathCasesYAxisStackView, graphType: .deaths, xAxisValues: deathsCasesXAxisValues, yAxisValues: deathsCasesYAxisValues, graphView: deathCasesGraphView)
        
        
        
        
        self.loadGraphDetails(scrollViewContainerView: worldCasesScrollViewContainerView, covidData: totalCovidData, graphType: .world, xAxisStackView: worldCasesXAxisRangeStackView, yAxisStackView: worldCasesYAxisRangeStackView, yPositionRanges: worldYPositionRanges)
        
        self.loadGraphDetails(scrollViewContainerView: totalCasesScrollViewContainerView, covidData: totalCovidData, graphType: .confirmed, xAxisStackView: totalCasesXaxisStackView, yAxisStackView: totalCasesYAxisStackView, yPositionRanges: totalCasesYPositionRanges)
        
        self.loadGraphDetails(scrollViewContainerView: curedCasesScrollViewContainerView, covidData: totalCovidData, graphType: .cured, xAxisStackView: curedCasesXAxisStackView, yAxisStackView: curedCasesYAxisStackView, yPositionRanges: recoveredCasesYPoistionRanges)
        
        self.loadGraphDetails(scrollViewContainerView: deathCasesScrollViewContainerView, covidData: totalCovidData, graphType: .deaths, xAxisStackView: deathCasesXAxisStackView, yAxisStackView: deathCasesYAxisStackView, yPositionRanges: deathsCasesYPoistionRages)
        
        
        DispatchQueue.background(delay: 0.3, background: nil) {
            self.drawLineBetweenPoints(graphType: .confirmed, covidData: self.totalCovidData, scrollViewContainerView: self.totalCasesScrollViewContainerView)
            self.drawLineBetweenPoints(graphType: .cured, covidData: self.totalCovidData, scrollViewContainerView: self.curedCasesScrollViewContainerView)
            self.drawLineBetweenPoints(graphType: .deaths, covidData: self.totalCovidData, scrollViewContainerView: self.deathCasesScrollViewContainerView)
        }
    }
    
    
    func getYAxisRange(for highestValue: Double) -> [Int] {
        let valueString = String(Int(highestValue))
        let digitCount = valueString.count
        var rangeDiffString = "1"
        for _ in 0 ..< digitCount - 1 {
            rangeDiffString = rangeDiffString + "0"
        }
        var rangeDiff = Double(rangeDiffString)!
        
        var ceilingValue: Double = 0
        var roundedHighestValue: Double = 0
        //        if highestValue.truncatingRemainder(dividingBy: rangeDiff) == 0 {
        //            roundedHighestValue = highestValue
        //            let newDidit = digitCount - 1
        //            rangeDiff = roundedHighestValue / Double(newDidit)
        //        }else {
        ceilingValue = ceil(highestValue/rangeDiff)
        roundedHighestValue = rangeDiff * ceilingValue
        //  }
        rangeDiff = roundedHighestValue/5
        var yAxisRange = [Int]()
        //        while roundedHighestValue > 0 {
        //
        //            yAxisRange.append(roundedHighestValue)
        //        }
        
        for i in 0 ... 5 {
            let sum = Int(rangeDiff) * i
            yAxisRange.append(sum)
        }
        return yAxisRange.reversed()
    }
    
    //MARK: Actions
    @IBAction func btnOpenMapAction(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.modalPresentationStyle = .fullScreen
        vc.totalCovidData = self.totalCovidData
        vc.arrCountries = self.appData.filterdCountries
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    @IBAction func didTapOnWeek(_ sender: Any) {
        
        showSleepTerndsBasedOn(state: .week)
    }
    
    
    @IBAction func didTapOnMonth(_ sender: Any) {
        
        showSleepTerndsBasedOn(state: .month)
        
    }
    
    @IBAction func didTapOnLeftButton(_ sender: Any) {
        removeAllLayersAndRoundedViewsFromContanerView()
        if currentState == .week {
            currentDate = currentDate.startOfWeek1.addDays(days: -1).startOfWeek1
        }else {
            currentDate = currentDate.startOfMonth.addDays(days: -1).startOfMonth
        }
        totalCovidData = appData.getCovidDataFromSelectedDateRange(date: currentDate, dateType: currentState)
        if totalCovidData.count == 0 {
            return
        }
        self.setCalendarComponentsBasedOn(state: currentState, date: currentDate)
    }
    
    @IBAction func didTapOnRightButton(_ sender: Any) {
        removeAllLayersAndRoundedViewsFromContanerView()
        if currentState == .week {
            currentDate = currentDate.endOfWeek1.addDays(days: 1).startOfWeek1
        }else {
            currentDate = currentDate.endOfMonth.addDays(days: 1).startOfMonth
        }
        totalCovidData = appData.getCovidDataFromSelectedDateRange(date: currentDate, dateType: currentState)
        if totalCovidData.count == 0 {
            return
        }
        self.setCalendarComponentsBasedOn(state: currentState, date: currentDate)
    }
    
    
    @IBAction func didTapOnRestRange(_ sender: Any) {
        removeAllLayersAndRoundedViewsFromContanerView()
        self.currentDate = Date()
        totalCovidData = appData.getCovidDataFromSelectedDateRange(date: currentDate, dateType: currentState)
        if totalCovidData.count == 0 {
            return
        }
        self.setCalendarComponentsBasedOn(state: currentState, date: currentDate)
        
    }
    
    
}

// building world confirm cases view
extension GraphDetailsViewController {
    
    @objc func handleWorldGraph(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if let view = sender?.view {
            if let data = totalCovidData[safe: view.tag]  {
                
                presentPopOverView(for: data, containerView: view)
            }
        }
    }
    
    
    func presentPopOverView(for covidData: FullData, containerView: UIView) {
        let popUPVC = CovidDetailsViewController.instantiate(fromAppStoryboard: .Main)
        popUPVC.modalPresentationStyle = UIModalPresentationStyle.popover
        popUPVC.selectedCovidData = covidData
        
        let popOverVC = popUPVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = containerView
        popOverVC?.sourceRect = CGRect(x: containerView.frame.width/2, y: containerView.frame.height/2, width: 0, height: 0)
        popUPVC.preferredContentSize = CGSize(width: 200, height: 120)
        self.present(popUPVC, animated: true)
    }
}

extension GraphDetailsViewController: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


// building confirmed cases line graph
extension GraphDetailsViewController {
    
    func addDefaultAllCasesPoint(xPositionLabel: UIView) {
        let defaultBarView = UIView()
        defaultBarView.backgroundColor = .clear
        totalCasesScrollViewContainerView.addSubview(defaultBarView)
        let topView = totalCasesYAxisStackView.arrangedSubviews[0]
        defaultBarView.snp.makeConstraints { (snp) in
            snp.top.equalTo(topView)
            snp.width.equalTo(8)
            snp.centerX.equalTo(xPositionLabel)
            snp.height.equalTo(8)
        }
    }
    
    
    func drawLineBetweenPoints(graphType: GraphType, covidData: [FullData], scrollViewContainerView: UIView) {
        
        
        for data in covidData {
            
            var roundedViews = [UIView]()
            
            if graphType == .confirmed {
                roundedViews = data.roundedViews ?? []
            }else if graphType == .cured {
                roundedViews = data.recoverdRoundViews ?? []
            }else if graphType == .deaths {
                roundedViews = data.deathsRoundViews ?? []
            }
            
            for (index, view) in roundedViews.enumerated() {
                
                if let nextPointView = roundedViews[safe: index + 1] {
                    drawLine(fromPoint:  view.convert(CGPoint(x: view.bounds.midX, y: view.bounds.midY), to: scrollViewContainerView), toPoint: nextPointView.convert(CGPoint(x: nextPointView.bounds.midX, y: nextPointView.bounds.midY), to: scrollViewContainerView), data: data, graphType: graphType, scrollViewContainerView: scrollViewContainerView)
                }
            }
        }
    }
    
    
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, data: FullData, graphType: GraphType, scrollViewContainerView: UIView) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = data.graphColor?.cgColor ??  #colorLiteral(red: 0.09019607843, green: 0.5333333333, blue: 0.7647058824, alpha: 1)
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        if graphType == .confirmed {
            data.lineLayers?.append(line)
        }else if graphType == .cured {
            data.recoverdLineLayers?.append(line)
        }else if graphType == .deaths {
            data.deathsLineLayers?.append(line)
        }
        scrollViewContainerView.layer.addSublayer(line)
    }
}

//MARK: delegate call for update
extension GraphDetailsViewController{
    func dataFor(_ values: [Country]){
        if values != self.appData.filterdCountries{
            MainClass.appdelegate?.refreshData = true
            self.showProgress(message: "Refresh...")
            self.appData.filterdCountries = values
            self.appData.refreshCovidData(){
            }
        }
    }
 
}

// setting up graphs x and y axis
extension GraphDetailsViewController {
    
    func loadGraphInitialAxisSetup(xAxisStackView: UIStackView, yAxisStackView: UIStackView, graphType: GraphType, xAxisValues: [String], yAxisValues: [String], graphView: UIView) {
        
        xAxisStackView.removeAllArrangedSubviews()
        yAxisStackView.removeAllArrangedSubviews()
        
        var stackViewSpacing: CGFloat = 24
        
        if currentState == .week {
            stackViewSpacing = 24
            
        }else {
            stackViewSpacing = 4
        }
        
        // setting up xAxis
        if graphType == .world {
            xAxisStackView.spacing = 8
            for value in xAxisValues {
                let xAxisLabel = getDateLabelForGraphXPostion(text: value)
                xAxisStackView.addArrangedSubview(xAxisLabel)
            }
        }else {
            xAxisStackView.spacing = stackViewSpacing
            for value in xAxisValues {
                let xAxisLabel = getDateLabelForGraphXPostion(text: value, numberOfLines: 0, bgColor: .clear)
                xAxisStackView.addArrangedSubview(xAxisLabel)
                xAxisLabel.snp.makeConstraints { (snp) in
                    snp.height.equalTo(47)
                    snp.width.equalTo(17)
                }
            }
        }
        
        
        // setting up yAxis
        for (index, value) in yAxisValues.enumerated() {
            
            yAxisStackView.spacing = 0
            let formattedNumerText = convertNumberToFomrmatedNumerString(unformattedValue: Double(value) ?? 0)
            let yAxisLabel = getRangeLabelForYAxis(text:  formattedNumerText, width: yAxisStackView.frame.width, height: rowHeight, tag: index)
            
            yAxisStackView.addArrangedSubview(yAxisLabel)
            
            yAxisLabel.snp.makeConstraints { (snp) in
                snp.height.equalTo(rowHeight)
            }
            
        }
        
        // adding line border to graph
        
        for view in graphView.subviews {
            if let imageView = view as? UIImageView, imageView.image == UIImage(named: "graph_border_icon") {
                imageView.removeFromSuperview()
            }
        }
        
        for yAxisLabel in yAxisStackView.arrangedSubviews {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "graph_border_icon")
            imageView.contentMode = .scaleAspectFill
            graphView.insertSubview(imageView, at: 0)
            
            imageView.snp.makeConstraints { (snp) in
                snp.leading.equalTo(yAxisStackView).offset(yAxisStackView.frame.width)
                snp.trailing.equalTo(-14)
                snp.height.equalTo(1)
                snp.top.equalTo(yAxisLabel).offset(8)
            }
        }
        
        
    }
}


// plotting graph
extension GraphDetailsViewController {
    
    
    func removeAllLayersAndRoundedViewsFromContanerView() {
        
//        for view in worldWideConfirmCasesView.subviews {
//            if let imageView = view as? UIImageView, imageView.image == UIImage(named: "graph_border_icon") {
//                imageView.removeFromSuperview()
//            }
//        }
//
//        for view in totalCasesLineGraphView.subviews {
//            if let imageView = view as? UIImageView, imageView.image == UIImage(named: "graph_border_icon") {
//                imageView.removeFromSuperview()
//            }
//        }
//
//
//        for view in curedCasesGraphView.subviews {
//            if let imageView = view as? UIImageView, imageView.image == UIImage(named: "graph_border_icon") {
//                imageView.removeFromSuperview()
//            }
//        }
//
//        for view in deathCasesGraphView.subviews {
//            if let imageView = view as? UIImageView, imageView.image == UIImage(named: "graph_border_icon") {
//                imageView.removeFromSuperview()
//            }
//        }

        for data in totalCovidData {
            
            for lineView in data.lineLayers ?? [] {
                lineView.removeFromSuperlayer()
            }
            
            for roundView in data.roundedViews ?? [] {
                roundView.removeFromSuperview()
            }
            
            for roundView in data.recoverdRoundViews ?? [] {
                roundView.removeFromSuperview()
            }
            
            for roundView in data.deathsRoundViews ?? [] {
                roundView.removeFromSuperview()
            }
            
            for lineView in data.recoverdLineLayers ?? [] {
                lineView.removeFromSuperlayer()
            }
            
            for lineView in data.deathsLineLayers ?? [] {
                lineView.removeFromSuperlayer()
            }

            data.roundedViews = []
            data.lineLayers = []
            data.recoverdLineLayers = []
            data.recoverdRoundViews = []
            
            data.deathsLineLayers = []
            data.deathsRoundViews = []
            
        }
        
    }
    
    func loadGraphDetails(scrollViewContainerView: UIView, covidData: [FullData], graphType: GraphType, xAxisStackView: UIStackView, yAxisStackView: UIStackView, yPositionRanges: [Int]) {
        
        for data in covidData {
            
            if graphType == .confirmed {
                for lineView in data.lineLayers ?? [] {
                    lineView.removeFromSuperlayer()
                }
                data.roundedViews = []
                data.lineLayers = []
            }else if graphType == .cured {
                for lineView in data.recoverdLineLayers ?? [] {
                    lineView.removeFromSuperlayer()
                }
                data.recoverdLineLayers = []
                data.recoverdRoundViews = []
            }else if graphType == .deaths {
                
                for lineView in data.deathsLineLayers ?? [] {
                    lineView.removeFromSuperlayer()
                }
                data.deathsLineLayers = []
                data.deathsRoundViews = []
            }
            
        }
        
        countryConfirmCasesBarViews = []
        flageViews = []
        
        
        for view in scrollViewContainerView.subviews {
            if view as? UIStackView == nil {
                view.removeFromSuperview()
            }
        }
        
        //        for layer in scrollViewContainerView.layer.sublayers ?? [] {
        //            layer.removeFromSuperlayer()
        //        }
        
        
        if graphType == .world {
            
            for (index, countryLabel) in xAxisStackView.arrangedSubviews.enumerated() {
                
                if let data = covidData[safe: index] {
                    let barView = UIView()
                    
                    barView.backgroundColor = data.graphColor
                    barView.tag = index
                    scrollViewContainerView.addSubview(barView)
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleWorldGraph(_:)))
                    barView.isUserInteractionEnabled = true
                    barView.addGestureRecognizer(tap)
                    
                    let barWidth = 12
                    let (yPoistion, rangeIndex) = getWorldWideConfirmYPoistion(from: abs(data.TotalConfirmed!), rowHeight: rowHeight, rangeValues: yPositionRanges)
                    
                    
                    let yReferanceView = yAxisStackView.arrangedSubviews.first(where: {$0.tag == rangeIndex})!
                    let lastRanegYView = yAxisStackView.arrangedSubviews.first(where: {$0.tag == (yAxisStackView.arrangedSubviews.count - 2)})
                    
                    barView.snp.makeConstraints { (snp) in
                        snp.top.equalTo(yReferanceView.snp.bottom).offset(-yPoistion + 8)
                        snp.bottom.equalTo(lastRanegYView!).offset(8)
                        snp.width.equalTo(barWidth)
                        snp.centerX.equalTo(countryLabel)
                    }
                    
                    
                    let imageView = UIImageView(image: data.country?.countryFlag)
                    imageView.backgroundColor = .red
                    
                    barView.addSubview(imageView)
                    
                    imageView.snp.makeConstraints { (snp) in
                        snp.width.equalTo(12)
                        snp.height.equalTo(12)
                        snp.centerX.equalTo(barView)
                        snp.top.equalTo(barView)
                    }
                    
                    
                    countryConfirmCasesBarViews.append(barView)
                    
                    flageViews.append(imageView)
                }
            }
            
        }else {
            
            for data in covidData {
                
                for (index, dateLabel) in xAxisStackView.arrangedSubviews.enumerated() {
                    
                    if let date = currentDatesInGraph[safe: index], let covidData = data.covidData?.first(where: {$0.dateString == date.startDateOfTheDay().nextClassDateFormat()}) {
                        
                        let pointView = UIView()
                        pointView.backgroundColor = data.graphColor
                        scrollViewContainerView.addSubview(pointView)
                        var currentCaseValue: Double = 0
                        if graphType == .confirmed {
                            currentCaseValue = abs(covidData.currentConfirmed!)
                            print("confirmed", covidData.currentConfirmed)
                        }else if graphType == .cured {
                            currentCaseValue = abs(covidData.currentRecovered!)
                            print("cured", covidData.currentRecovered)
                        }else if graphType == .deaths {
                            currentCaseValue = abs(covidData.currentDeaths!)
                        }
                        let (yPoistion, rangeIndex) = getWorldWideConfirmYPoistion(from: currentCaseValue, rowHeight: rowHeight, rangeValues: yPositionRanges)
                        
                        let yReferanceView = yAxisStackView.arrangedSubviews.first(where: {$0.tag == rangeIndex})!
                        pointView.snp.makeConstraints { (snp) in
                            snp.bottom.equalTo(yReferanceView).offset(-yPoistion + 8)
                            snp.width.equalTo(8)
                            snp.centerX.equalTo(dateLabel)
                            snp.height.equalTo(8)
                        }
                        
                        if graphType == .confirmed {
                            data.roundedViews?.append(pointView)
                        }else if graphType == .cured {
                            data.recoverdRoundViews?.append(pointView)
                        }else if graphType == .deaths {
                            data.deathsRoundViews?.append(pointView)
                        }
                        
                    }else {
                        addDefaultAllCasesPoint(xPositionLabel: dateLabel)
                    }
                    
                }
            }
        }
        
        for view in countryConfirmCasesBarViews {
            addCornerRadius(view: view, radius: 12/2)
            view.layoutIfNeeded()
        }
        
        
        for view in flageViews {
            addCornerRadius(view: view, radius: 12/2)
            view.layoutIfNeeded()
        }
        
        
        for data in covidData {
            
            for roundView in data.roundedViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
            
            for roundView in data.recoverdRoundViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
            
            for roundView in data.deathsRoundViews ?? [] {
                addCornerRadius(view: roundView, radius: roundView.frame.height/2)
                view.layoutIfNeeded()
            }
            
        }
        
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
