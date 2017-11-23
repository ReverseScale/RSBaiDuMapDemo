//
//  SimpleMapViewController.swift
//  SwiftBaiduMapDemo
//
//  Created by WhatsXie on 2017/11/23.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit

class SimpleMapViewController: UIViewController, BMKMapViewDelegate {
    @IBOutlet var mapView: BMKMapView!
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupMapView() {
        segment.selectedSegmentIndex = 0
        mapView.isTrafficEnabled = false
        mapView.isBuildingsEnabled = true
        mapView.isBaiduHeatMapEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self
        // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil
        // 不用时，置nil
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        let index: Int = segment.selectedSegmentIndex
        switch index {
        case 0:
            mapView.mapType = UInt(BMKMapTypeStandard)
        case 1:
            mapView.mapType = UInt(BMKMapTypeSatellite)
        default:
            break
        }
    }
    @IBAction func switchValueChanged(_ sender: Any) {
        let switchControl = sender as? UISwitch
        let isOn: Bool? = switchControl?.isOn
        switch switchControl?.tag {
        case 0?:
            mapView.isTrafficEnabled = isOn!
        case 1?:
            mapView.isBuildingsEnabled = isOn!
        case 2?:
            mapView.isBaiduHeatMapEnabled = isOn!
        case 3?:
            mapView.showMapPoi = isOn!
        case 4?:
            showMapScaleBaris(on: isOn!)
        default:
            break
        }
    }
    
    func showMapScaleBaris(on isOn: Bool) {
        mapView.showMapScaleBar = isOn
        //自定义比例尺的位置
        mapView.mapScaleBarPosition = CGPoint(x: mapView.frame.size.width - 70, y: mapView.frame.size.height - 45)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
