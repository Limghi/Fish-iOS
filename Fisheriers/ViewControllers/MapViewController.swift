//
//  MapViewController.swift
//  Fisheriers
//
//  Created by Lost on 17/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//


class MapViewController: UIViewController,BMKGeoCodeSearchDelegate{

    @IBOutlet weak var mapView: BMKMapView!
    var city : String?
    var address : String?
    var searchTitle : String?
    var latitude : Double = 116.427287
    var longitude : Double = 39.904983
    
    var viewController: NaviViewController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let point = BMKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(longitude,latitude)
        point.title = title
        mapView.addAnnotation(point)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false);

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if latitude == 0
        {
            latitude = 116.427287
        }
        if longitude == 0
        {
            longitude = 39.904983
        }
         //hidesBottomBarWhenPushed = true
        
        let search = BMKGeoCodeSearch()
        search.delegate = self
        let searchOption = BMKReverseGeoCodeOption()
        searchOption.reverseGeoPoint = CLLocationCoordinate2DMake(longitude,latitude)
        let flag = search.reverseGeoCode(searchOption)
        if flag
        {
            NSLog("百度地图发送成功")
        }
        else
        {
            NSLog("百度地图发送失败")
            
        }
        
//        let geoCodeSearchOption = BMKGeoCodeSearchOption()
//        geoCodeSearchOption.city = city
//        geoCodeSearchOption.address = address
//        geoCodeSearchOption.rever
        
        /*
        let flag = search.geoCode(geoCodeSearchOption)
        if flag
        {
            NSLog("百度地图发送成功")
        }
        else
        {
            NSLog("百度地图发送失败")

        }
         */
    }
    
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
    }
    
    func goNavi()
    {
        viewController = NaviViewController(nibName: nil, bundle: nil)
        
        viewController!.title = "导航"
        let endPoint = AMapNaviPoint.locationWithLatitude(CGFloat(latitude), longitude: CGFloat(longitude))
        viewController!.endPoint = endPoint
        viewController!.endLoc = CLLocationCoordinate2DMake(longitude,latitude)
        navigationController?.pushViewController(viewController!, animated: true)
    }
    @IBAction func naviButtonClicked(sender: AnyObject) {
        goNavi()
    }
    
}
