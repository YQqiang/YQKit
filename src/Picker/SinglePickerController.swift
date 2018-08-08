//
//  SinglePickerController.swift
//  YQKit
//
//  Created by sungrow on 2018/7/21.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import UIKit

class SinglePickerController: UIViewController {
    
    var confirmClosure: ((_ value: Any, _ index: Int) -> Void)?
    
    fileprivate var stringForRowClosure: ((Int) -> String)
    fileprivate var dataSource: [Any] = []
    fileprivate var selectIndex: Int = -1
    fileprivate var pickerTitle: String = ""
    
    private(set) lazy var singlePickerView: SinglePickerView = {
        let pickerV = SinglePickerView(pickerTitle:self.pickerTitle, dataSource: self.dataSource, selectIndex: self.selectIndex, stringForRow: self.stringForRowClosure)
        pickerV.cancelClosure = {[weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        pickerV.confirmClosure = {[weak self] (_, obj, index) in
            if let closure = self?.confirmClosure {
                closure(obj, index)
            }
            self?.dismiss(animated: true, completion: nil)
        }
        return pickerV
    }()
    
    init(pickerTitle: String, dataSource: [Any], selectIndex: Int, stringForRow: @escaping ((Int) -> String)) {
        self.pickerTitle = pickerTitle
        self.dataSource = dataSource
        self.selectIndex = selectIndex
        self.stringForRowClosure = stringForRow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .overFullScreen }
        set {}
    }
    
    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { return SlowlyShowTransition() }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(singlePickerView)
        singlePickerView.translatesAutoresizingMaskIntoConstraints = false
        singlePickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        singlePickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        singlePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.singlePickerView.pickerView.reloadAllComponents()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPicker(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showPicker(false)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    private func showPicker(_ show: Bool) {
        view.layoutIfNeeded()
        let height = self.singlePickerView.frame.height
        let screenHeight = UIScreen.main.bounds.height
        let showY = screenHeight - height
        let hiddenY = screenHeight
        self.singlePickerView.frame.origin.y = show ? hiddenY : showY
        UIView.animate(withDuration: 0.25) {
            self.singlePickerView.frame.origin.y = show ? showY : hiddenY
        }
    }
    
    func showPickerView(for responder: UIResponder) {
        responder.recentlyViewController?.present(self, animated: true, completion: nil)
    }
}

final class SinglePickerView: UIView {
    
    var cancelClosure: ((UIButton) -> Void)?
    var confirmClosure: ((_ sender: UIButton, _ value: Any, _ index: Int) -> Void)?
    var stringForRowClosure: ((Int) -> String)?
    var titleSelectedColor: UIColor = UIColor.blue
    var titleDeSelectedColor: UIColor = UIColor.black
    
    fileprivate var dataSource: [Any] = []
    fileprivate var selectIndex: Int = -1
    fileprivate var pickerTitle: String = ""
    
    init(pickerTitle: String, dataSource: [Any], selectIndex: Int, stringForRow: @escaping ((Int) -> String)) {
        self.pickerTitle = pickerTitle
        self.dataSource = dataSource
        self.selectIndex = selectIndex
        self.stringForRowClosure = stringForRow
        super.init(frame: CGRect.zero)
        createView()
    }
    
    private(set) lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("取消", comment: "取消"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        btn.contentHorizontalAlignment = .left
        btn.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        return btn
    }()
    
    private(set) lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("确定", comment: "确定"), for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        btn.contentHorizontalAlignment = .right
        btn.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        return btn
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.text = self.pickerTitle
        return label;
    }()
    
    fileprivate lazy var pickerView: UIPickerView = {
        let pickerV = UIPickerView()
        pickerV.delegate = self
        pickerV.dataSource = self
        return pickerV
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createView()
    }
}

extension SinglePickerView {
    fileprivate func createView() {
        let superView = self
        superView.backgroundColor = UIColor.white
        
        superView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        superView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        superView.addSubview(confirmBtn)
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        confirmBtn.topAnchor.constraint(equalTo: cancelBtn.topAnchor).isActive = true
        confirmBtn.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        confirmBtn.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        
        superView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cancelBtn.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cancelBtn.bottomAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: cancelBtn.rightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: confirmBtn.leftAnchor).isActive = true
        
        choosePicker()
    }
    
    /// 反向根据当前值设置到pickerView上
    fileprivate func choosePicker() {
        if selectIndex >= 0, selectIndex < dataSource.count {
            pickerView.selectRow(selectIndex, inComponent: 0, animated: false)
        }
    }
}

// MARK: - UIPickerViewDelegate
extension SinglePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
}

// MARK: - UIPickerViewDataSource
extension SinglePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFont(ofSize: 18)
        pickerLabel.textAlignment = .center
        var color: UIColor!
        if pickerView.selectedRow(inComponent: component) == row {
            color = titleSelectedColor
        } else {
            color = titleDeSelectedColor
        }
        pickerLabel.textColor = color
        var title = ""
        if let closure = stringForRowClosure {
            title = closure(row)
        }
        pickerLabel.text = title
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

// MARK: - private func
extension SinglePickerView {
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        if let closure = cancelClosure {
            closure(sender)
        }
    }
    
    @objc fileprivate func confirmAction(_ sender: UIButton) {
        if anySubViewScrolling(view: pickerView) {
            cancelAction(cancelBtn)
            return
        }
        if let closure = confirmClosure {
            let row = pickerView.selectedRow(inComponent: 0)
            closure(sender, dataSource[row], row)
        }
    }
    
    /// 返回一个视图上是否有滑动视图正在滑动
    ///
    /// - Parameter view: View
    /// - Returns: 是否正在滑动
    private func anySubViewScrolling(view: UIView) -> Bool {
        if let scrollView = view as? UIScrollView {
            if scrollView.isDragging || scrollView.isDecelerating {
                return true
            }
        }
        for subV in view.subviews {
            if anySubViewScrolling(view: subV) {
                return true
            }
        }
        return false
    }
}

