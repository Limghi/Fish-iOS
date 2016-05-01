
import UIKit
import KVNProgress

class NaviViewController: UIViewController ,MAMapViewDelegate,AMapNaviManagerDelegate,AMapNaviViewControllerDelegate{
//    /,IFlySpeechSynthesizerDelegate
    var endLoc : CLLocationCoordinate2D?
    var annotations: NSArray?
    var calRouteSuccess: Bool?
    var polyline: MAPolyline?
    var startPoint: AMapNaviPoint?
    var endPoint: AMapNaviPoint?
    var mapView: MAMapView?
    //var iFlySpeechSynthesizer: IFlySpeechSynthesizer?
    var naviManager: AMapNaviManager?
    var naviViewController: AMapNaviViewController?
    
    var isSim = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNaviManager()
        initMapView()
        startPoint = AMapNaviPoint.locationWithLatitude(39.989614, longitude: 116.481763);
        endPoint = AMapNaviPoint.locationWithLatitude(CGFloat(endLoc!.latitude), longitude: CGFloat(endLoc!.longitude))

        // Do any additional setup after loading the view.
        
        //navigationController?.toolbar.barStyle = UIBarStyle.Black
        
        //navigationController?.toolbar.translucent = true
        
        //navigationController?.setToolbarHidden(false, animated: true);
        
        //hidesBottomBarWhenPushed = false
        //initToolBar()
        
       
        //AMapNaviLocation.
                //self.locationMnager.set
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        //locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，可修改，最小2s
        //self.locationManager.locationTimeout = 3;
        //   逆地理请求超时时间，可修改，最小2s
        //self.locationManager.reGeocodeTimeout = 3;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
          endPoint = AMapNaviPoint.locationWithLatitude(CGFloat(endLoc!.latitude), longitude: CGFloat(endLoc!.longitude))
        configMapView()
        initAnnotations()
        //navigationController?.toolbar.barStyle = UIBarStyle.Black
        //navigationController?.setToolbarHidden(true, animated: true);
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        navigationController?.toolbar.barStyle = UIBarStyle.Default
        navigationController?.setToolbarHidden(true, animated: true);
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        
        startPoint = AMapNaviPoint.locationWithLatitude(39.989614, longitude: 116.481763);
        endPoint = AMapNaviPoint.locationWithLatitude(39.983456, longitude: 116.315495)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    func  configSubViews() {
        
        var startPointLabel = UILabel(frame: CGRectMake(0, 100, 320, 20))
        
        startPointLabel.textAlignment = NSTextAlignment.Center
        startPointLabel.font = UIFont.systemFontOfSize(14)
        let startLatitude = startPoint?.latitude.description
        let startLongitude = startPoint?.longitude.description
        startPointLabel.text = "起点:" + startLatitude! + "," + startLongitude!
        
        view.addSubview(startPointLabel)
        
        
        var endPointLabel = UILabel(frame: CGRectMake(0, 130, 320, 20))
        
        endPointLabel.textAlignment = NSTextAlignment.Center
        endPointLabel.font = UIFont.systemFontOfSize(14)
        let endLatitude = endPoint?.latitude.description
        let endLongitude = endPoint?.longitude.description
        endPointLabel.text = "终点:" + endLatitude! + "," + endLongitude!
        view.addSubview(endPointLabel)
        
        
        let startBtn = UIButton.init(type:UIButtonType.Custom) as UIButton
        startBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        startBtn.layer.borderWidth = 0.5
        startBtn.layer.cornerRadius = 5
        
        startBtn.frame = CGRectMake(60, 160, 200, 30)
        startBtn.setTitle("模拟导航", forState: UIControlState.Normal)
        startBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        startBtn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        startBtn.addTarget(self, action: #selector(NaviViewController.startSimuNavi), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(startBtn)
        
    }
    
    
    func initAnnotations(){
        let star = MAPointAnnotation()
        star.coordinate = CLLocationCoordinate2DMake(39.989614,116.481763)
        star.title = "Start"
        
        //mapView!.addAnnotation(star)
        
        let end = MAPointAnnotation()
        end.coordinate = endLoc!
        end.title = title
        
        mapView!.addAnnotation(end)
        annotations = [end]

       // annotations = [end]
    }
    
    func initToolBar()
    {
        let flexbleItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        
        let calcroute: UIBarButtonItem = UIBarButtonItem(title: "路径规划", style: .Plain, target: self, action: #selector(NaviViewController.calculateRoute))
        
        let startnavi: UIBarButtonItem = UIBarButtonItem(title: "开始导航", style: .Plain, target: self, action: #selector(NaviViewController.startGps))
        
        let simunavi: UIBarButtonItem = UIBarButtonItem(title: "模拟导航", style: .Plain, target: self, action: #selector(NaviViewController.startSimuNavi))
        
        setToolbarItems([flexbleItem,calcroute,startnavi,simunavi,flexbleItem], animated: false)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)!
    }
    
    func initMapView()
    {
        mapView = MAMapView(frame: self.view.bounds)
        
        mapView!.delegate = self
        
        view.insertSubview(mapView!, atIndex: 0)
        
        if calRouteSuccess == true {
            mapView!.addOverlay(polyline)
            
        }
    }
    
    
    func configMapView(){
        
        
        //mapView!.removeAnnotations(<#T##annotations: [AnyObject]!##[AnyObject]!#>)
        if(annotations?.count > 0){
            mapView!.addAnnotations(annotations! as [AnyObject])
        }
    }
    
    func initIFlySpeech(){
       // iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as? IFlySpeechSynthesizer
        
      //  iFlySpeechSynthesizer?.delegate = self
        
    }
    
    func initNaviManager(){
        if (naviManager == nil) {
            naviManager = AMapNaviManager()
            
            naviManager?.delegate = self
        }
    }
    
    
    func initNaviViewController(){
        if(naviViewController == nil){
            naviViewController = AMapNaviViewController(mapView: mapView!, delegate: self)
        }
    }
    
    
    // 模拟导航
    func startSimuNavi()
    {
        isSim = true
        if (calRouteSuccess == true) {
            
            initNaviViewController()
            
            naviManager?.presentNaviViewController(naviViewController!, animated: true)
            
        }
        else {
            
            let alert = UIAlertView(title: "请先进行路线规划", message: nil, delegate: nil, cancelButtonTitle: "确定")
            
            alert.show()
            
        }
    }
    
    
    // 导航
    func startGps()
    {
        isSim = false
        if (calRouteSuccess == true) {
            
            initNaviViewController()
            
            naviManager?.presentNaviViewController(naviViewController!, animated: true)
            
        }
        else {
            
            let alert = UIAlertView(title: "请先进行路线规划", message: nil, delegate: nil, cancelButtonTitle: "确定")
            
            alert.show()
            
        }
    }
    
    // 路径规划
    func calculateRoute(){
        KVNProgress.showWithStatus("正在计算线路")
        var startPoints = [AMapNaviPoint]()
        
        var endPoints = [AMapNaviPoint]()
        
        startPoints.append(startPoint!)
        
        endPoints.append(endPoint!)
        
        var count1 = startPoints.count

           naviManager?.calculateDriveRouteWithEndPoints(endPoints, wayPoints: nil, drivingStrategy: AMapNaviDrivingStrategy.Default)
        // 步行路径规划
        // naviManager?.calculateWalkRouteWithStartPoints(startPoints, endPoints: endPoints)
        
        // 驾车路径规划
        //naviManager?.calculateDriveRouteWithStartPoints(startPoints, endPoints: endPoints, wayPoints: nil, drivingStrategy: AMapNaviDrivingStrategy.Default)
        
        
    }
    
    func naviManager(naviManager: AMapNaviManager!, onCalculateRouteFailure error: NSError!) {
         KVNProgress.dismiss()
        KVNProgress.showErrorWithStatus("规划路线失败")
    }
    
    // 展示规划路径
    func showRouteWithNaviRoute(naviRoute: AMapNaviRoute)
    {
        KVNProgress.dismiss()
        if polyline != nil {
            mapView!.removeOverlay(polyline!)
            polyline = nil
        }
        
        let coordianteCount: Int = naviRoute.routeCoordinates.count
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        for i in 0 ..< coordianteCount {
            let aCoordinate: AMapNaviPoint = naviRoute.routeCoordinates[i] as AMapNaviPoint
            
            coordinates.append(CLLocationCoordinate2DMake(Double(aCoordinate.latitude), Double(aCoordinate.longitude)))
        }
        
        
        polyline = MAPolyline(coordinates:&coordinates, count: UInt(coordianteCount))
        
        mapView!.addOverlay(polyline)
        
    }
    
    // MAMapViewDelegate
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
        if overlay.isKindOfClass(MAPolyline) {
            let polylineView: MAPolylineView = MAPolylineView(overlay: overlay)
            polylineView.lineWidth = 5.0
            polylineView.strokeColor = UIColor.redColor()
            return polylineView
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "annotationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        return nil
    }
    
    
    // AMapNaviManagerDelegate
    // 算路成功回调
    func naviManagerOnCalculateRouteSuccess(naviManager: AMapNaviManager!) {
        print("success")
        
        showRouteWithNaviRoute(naviManager.naviRoute);
        
        calRouteSuccess = true
        startGps()
        
    }
    @IBAction func startNavi(sender: AnyObject) {
        calculateRoute()
    }
    
    // 展示导航视图回调
    func naviManager(naviManager: AMapNaviManager!, didPresentNaviViewController naviViewController: UIViewController!) {
        print("success")
        //initIFlySpeech()
        if isSim
        {
            naviManager.startEmulatorNavi()
        }
        else
        {
            naviManager.startGPSNavi()
        }
    }
    
    // 导航播报信息回调
    func naviManager(naviManager: AMapNaviManager!, playNaviSoundString soundString: String!, soundStringType: AMapNaviSoundType) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),{
            //self.iFlySpeechSynthesizer?.startSpeaking(soundString)
            print("start speak");
        });
        
    }
    
    
    // AMapNaviViewControllerDelegate
    // 导航界面关闭按钮点击的回调
    func naviViewControllerCloseButtonClicked(naviViewController: AMapNaviViewController!) {
        //iFlySpeechSynthesizer?.stopSpeaking()
        //iFlySpeechSynthesizer?.delegate = nil
        //iFlySpeechSynthesizer = nil
        naviManager?.stopNavi()
        naviManager?.dismissNaviViewControllerAnimated(true)
        
        configMapView()
    }
    
    // 导航界面更多按钮点击的回调
    func naviViewControllerMoreButtonClicked(naviViewController: AMapNaviViewController!) {
        if naviViewController.viewShowMode == AMapNaviViewShowMode.CarNorthDirection {
            naviViewController.viewShowMode = AMapNaviViewShowMode.MapNorthDirection
            
        }
        else {
            naviViewController.viewShowMode = AMapNaviViewShowMode.CarNorthDirection
        }
    }
    
    // 导航界面转向指示View点击的回调
    func naviViewControllerTurnIndicatorViewTapped(naviViewController: AMapNaviViewController!){
        naviManager?.readNaviInfoManual()
    }
    
    // IFlySpeechSynthesizerDelegate
    //func onCompleted(error: IFlySpeechError!) {
       // println("IFly error\(error)")
    //}
    
}