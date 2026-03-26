//
//  TimeSelectView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import SnapKit

class TimeSelectView: UIView {
    
    private lazy var dayContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Day".localized
        label.textAlignment = .center
        label.textColor = UIColor.init(hexString: "#2A2A2A")
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var dayPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var monthContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var monthTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Month".localized
        label.textAlignment = .center
        label.textColor = UIColor.init(hexString: "#2A2A2A")
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var monthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        return picker
    }()
    
    private lazy var yearContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var yearTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Year".localized
        label.textAlignment = .center
        label.textColor = UIColor.init(hexString: "#2A2A2A")
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        return picker
    }()
    
    private lazy var pickerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayContainer, monthContainer, yearContainer])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    private var days: [Int] = Array(1...31)
    private var months: [Int] = Array(1...12)
    private var years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(1900...currentYear)
    }()
    
    private var selectedDay: Int = 20
    private var selectedMonth: Int = 10
    private var selectedYear: Int = 1992
    
    var onDateChanged: ((String) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dayContainer.addSubview(dayTitleLabel)
        dayContainer.addSubview(dayPicker)
        
        dayTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        dayPicker.snp.makeConstraints { make in
            make.top.equalTo(dayTitleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        monthContainer.addSubview(monthTitleLabel)
        monthContainer.addSubview(monthPicker)
        
        monthTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        monthPicker.snp.makeConstraints { make in
            make.top.equalTo(monthTitleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        yearContainer.addSubview(yearTitleLabel)
        yearContainer.addSubview(yearPicker)
        
        yearTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        yearPicker.snp.makeConstraints { make in
            make.top.equalTo(yearTitleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        bgImageView.addSubview(pickerStackView)
        
        pickerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50.pix())
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(180)
        }
        
        setDefaultDate()
    }
    
    private func setDefaultDate() {
        if let dayIndex = days.firstIndex(of: selectedDay) {
            dayPicker.selectRow(dayIndex, inComponent: 0, animated: false)
        }
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            monthPicker.selectRow(monthIndex, inComponent: 0, animated: false)
        }
        
        if let yearIndex = years.firstIndex(of: selectedYear) {
            yearPicker.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        
        updateDisplayLabel()
        
        DispatchQueue.main.async { [weak self] in
            self?.dayPicker.reloadAllComponents()
            self?.monthPicker.reloadAllComponents()
            self?.yearPicker.reloadAllComponents()
        }
    }
    
    private func updateDisplayLabel() {
        let dateString = String(format: "%02d-%02d-%04d", selectedDay, selectedMonth, selectedYear)
        onDateChanged?(dateString)
    }
    
    private func updateDaysForCurrentMonth() {
        let daysInMonth = getDaysInMonth(month: selectedMonth, year: selectedYear)
        days = Array(1...daysInMonth)
        
        dayPicker.reloadAllComponents()
        
        if selectedDay > daysInMonth {
            selectedDay = daysInMonth
        }
        
        if let dayIndex = days.firstIndex(of: selectedDay) {
            dayPicker.selectRow(dayIndex, inComponent: 0, animated: true)
        }
    }
    
    private func getDaysInMonth(month: Int, year: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 31
    }
    
    func setDate(with dateString: String) {
        let components = dateString.components(separatedBy: "-")
        guard components.count == 3,
              let day = Int(components[0]),
              let month = Int(components[1]),
              let year = Int(components[2]) else {
            print("Invalid date format. Please use format: dd-MM-yyyy")
            return
        }
        
        let daysInMonth = getDaysInMonth(month: month, year: year)
        guard day >= 1 && day <= daysInMonth,
              month >= 1 && month <= 12,
              year >= 1900 && year <= Calendar.current.component(.year, from: Date()) else {
            print("Invalid date values")
            return
        }
        
        selectedDay = day
        selectedMonth = month
        selectedYear = year
        
        updateDaysForCurrentMonth()
        
        if let dayIndex = days.firstIndex(of: selectedDay) {
            dayPicker.selectRow(dayIndex, inComponent: 0, animated: true)
        }
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            monthPicker.selectRow(monthIndex, inComponent: 0, animated: true)
        }
        
        if let yearIndex = years.firstIndex(of: selectedYear) {
            yearPicker.selectRow(yearIndex, inComponent: 0, animated: true)
        }
        
        updateDisplayLabel()
        
        DispatchQueue.main.async { [weak self] in
            self?.dayPicker.reloadAllComponents()
            self?.monthPicker.reloadAllComponents()
            self?.yearPicker.reloadAllComponents()
        }
    }
    
    func getCurrentDateString() -> String {
        return String(format: "%02d-%02d-%04d", selectedDay, selectedMonth, selectedYear)
    }
    
    func getCurrentDateComponents() -> (day: Int, month: Int, year: Int) {
        return (selectedDay, selectedMonth, selectedYear)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension TimeSelectView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case dayPicker:
            return days.count
            
        case monthPicker:
            return months.count
            
        case yearPicker:
            return years.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        switch pickerView {
        case dayPicker:
            label.text = String(format: "%02d", days[row])
            
        case monthPicker:
            label.text = String(format: "%02d", months[row])
            
        case yearPicker:
            label.text = "\(years[row])"
            
        default:
            label.text = ""
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case dayPicker:
            selectedDay = days[row]
            
        case monthPicker:
            selectedMonth = months[row]
            updateDaysForCurrentMonth()
            
        case yearPicker:
            selectedYear = years[row]
            updateDaysForCurrentMonth()
            
        default:
            break
        }
        
    }
}
