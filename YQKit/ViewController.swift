//
//  ViewController.swift
//  YQKit
//
//  Created by sungrow on 2018/7/21.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let arr: [String] = ["1123", "324234", "123123"]
        let pickerVC = SinglePickerController(pickerTitle: "标题", dataSource: arr, selectIndex: 0) { (index) -> String in
            return arr[index]
        }
        pickerVC.singlePickerView.titleSelectedColor = UIColor.red
        pickerVC.singlePickerView.titleDeSelectedColor = UIColor.lightGray
        pickerVC.singlePickerView.confirmBtn.setTitleColor(UIColor.green, for: .normal)
        pickerVC.showPickerView(for: self)
    }


}

