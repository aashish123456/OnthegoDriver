//
//  HomeViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 08/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox
import AVFoundation
import MessageUI


//private let kOpenInMapsSampleURLScheme: String = "NikkosDriver://"

class HomeViewController: UIViewController,SWRevealViewControllerDelegate,MKMapViewDelegate,EDStarRatingProtocol,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    @IBOutlet weak var btnAvailableForNextTrip: UIButton!
    @IBOutlet weak var lblRateCustomer: UILabel!
    @IBOutlet weak var lblFareSummary: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var statusButton: UIBarButtonItem!
    
    var profileModel : ProfileModel!
    var loginObj:LoginModal!
    var tripId: String!
    var annonationId : Int = 1
    
    //Accept timer view
    @IBOutlet var gifView: UIView!
    @IBOutlet var lblCircle: UILabel!
    @IBOutlet var circlePV: CircleProgressView!
    @IBOutlet var acceptTimerView: UIView!
    @IBOutlet var imgGif: UIImageView!
    @IBOutlet var lblPickUpLocationOfCustomer: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblEtaTime: UILabel!
    
    
    var timer:Timer!
    var counterFlag: Int!
    var player : AVAudioPlayer!
    var imagesLoop: [UIImage] = []
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    var selectedCellAsClient : BookNowTripRequestDetail!
    var address : String!
    let custNav = CustomNavigationController()
    var arrRequest : NSMutableArray = NSMutableArray()
    var countDownTime : Int!
    //Arriverd View
    @IBOutlet var arrivedView: UIView!
    @IBOutlet var imgCustomerArrived: UIImageView!
    @IBOutlet var lblCustomerNameArrived: UILabel!
    @IBOutlet var lblPickupLocationArrived: UILabel!
    @IBOutlet var lblEtaArrived: UILabel!
    
    
    //Reason View
    @IBOutlet var popupView: ReasonView!
    @IBOutlet var reasonTblView: UITableView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var reasonTbleHight: NSLayoutConstraint!
    
    var selectedReasonCellIndex : Int = -1
    //Cancel trip
    var arrAllReasonData : NSMutableArray = NSMutableArray()
    var arrReasonId : NSMutableArray = NSMutableArray()
    var cancelReason : CancelReasonModel!
    
    //Start trip view
    @IBOutlet var startCancelTripView: UIView!
    @IBOutlet var lblCustomerNameStart: UILabel!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var lblPickUpLocationStart: UILabel!
    @IBOutlet var lblDropOfLocationStart: UILabel!
    
    //End Open trip view
    @IBOutlet var endOpenView: UIView!
    @IBOutlet var imgCustomerEnd: UIImageView!
    @IBOutlet var lblCustomerNameEnd: UILabel!
    @IBOutlet var lblPickUpLocationEnd: UILabel!
    @IBOutlet var lblDropUpLocationEnd: UILabel!
    @IBOutlet var btnChangeToOpen: UIButton!
    
    
    //End Trip with rating
    @IBOutlet var endTripView: UIView!
    @IBOutlet var totalAmount: UILabel!
    @IBOutlet var starRatingEnd: EDStarRating!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var billAmountLbl: UILabel!
    
    @IBOutlet var btnGoOffline: UIButton!
    var Rating : String = "-1"
    
    //Access
    @IBOutlet var accessView: UIView!
    @IBOutlet var accessTableView: UITableView!
    @IBOutlet var accessViewHeight: NSLayoutConstraint!
    @IBOutlet var accessViewBottom: NSLayoutConstraint!
    var isAccessRequest : Bool!
    var indexForAccess : Int = 0
    
    //Open Map
    var latMap : String!
    var longMap : String!
    
    var latDropMap : String!
    var longDropMap : String!
    
    var model : LoginModal!
    //tripInfo popup
    var tripInfo : TripInfoModel!
    
    var isRideStart : Bool = false
    
    @IBOutlet var infoView: InfoView!
    
    @IBOutlet var driverInfoImg: UIImageView!
    @IBOutlet var lblDriverNameInfo: UILabel!
    @IBOutlet var lblDriverNo: UILabel!
    @IBOutlet var lblLincesNoInfo: UILabel!
    @IBOutlet var lblVehicleNoInfo: UILabel!
    @IBOutlet var lblVtcInfo: UILabel!
    @IBOutlet var lblDriverCompInfo: UILabel!
    @IBOutlet var lblPickUpInfo: UILabel!
    @IBOutlet var lblDropOfInfo: UILabel!
    @IBOutlet var ImgClientInfo: UIImageView!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblClientnoInfo: UILabel!
    
    
    var isFromAnotherTab : Bool =  false
    var indexPathForAccess : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        mapView.delegate=self
        self.title = NikkosDriverManager.GetLocalString("Home")
        lblFareSummary.text=NikkosDriverManager.GetLocalString("Fare_Summary")
        lblRateCustomer.text=NikkosDriverManager.GetLocalString("Rate_Customer")
        btnAvailableForNextTrip.setTitle(NikkosDriverManager.GetLocalString("Available_For_Next_Trip"), for: UIControlState())
        btnGoOffline.setTitle(NikkosDriverManager.GetLocalString("Go_Offline"), for: UIControlState())
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        popupView.frame = self.view.frame
        infoView.frame = self.view.frame
        
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        
        
        //for update location of driver
        let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        locManager.startUpdateingLocation()
        
        
        if locManager.isAlreadyUpdatingLocation == false {
        
            let alert = UIAlertController(title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplicationOpenSettingsURLString)!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        mapView.delegate = self
        mapView.userLocation.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions.old, context: nil)
        
        //Reset Page
        ResetPage()
        // notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fresh), name: NSNotification.Name(rawValue: "bookingRequest"), object: nil)
        
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        
        //For Show address on google application
//        STMapWrapper.sharedInstance().callbackURL = NSURL(string: kOpenInMapsSampleURLScheme)
//        STMapWrapper.sharedInstance().fallbackStrategy = kGoogleMapsFallbackChromeThenAppleMaps
        
        
        
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    // Check the status of ride and show view accordingly
    func fresh(_ notification: Notification)
    {
        let dict = notification.object as! NSDictionary
        if (appDelegate.isFromDidFinishLaunch == true){
            let tripID = SharedStorage.getTripId()
            tripId  = String(format:"%@", tripID)
        }else{
            tripId  = String(dict["PrimaryId"] as! Int)
            let tripID : NSNumber = Int(tripId)! as NSNumber
            SharedStorage.setTripId(tripID)
        }
        let type = dict["MsgType"] as! String
        print(type)
        
        if type == "BookingRequest"{
            SharedStorage.setAccessTypeRequest(false)
            isAccessRequest = false
            self.BookNowTripRequestDetailForDriver()
        }
        else if type == "CancelRide"{
            ResetPage()
            CIError("Ride cancel by client!")
            if timer != nil{
                timer.invalidate()
                timer = nil
                self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
            }
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.removeAnnotaion()
            
            if self.bookTripRequestDeatil.passengerCount > 0{
                self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
            }
        }
        else if type == "GoOffLine"{
            self.ResetPage()
            SharedStorage.setIsOnlineOffine(false)
            self.custNav.StatusButtonMethod(self.statusButton)
        }
        else if type == "AccessBookingRequest"{
            ResetPage()
            SharedStorage.setAccessTypeRequest(true)
            isAccessRequest = true
            // reasonTblView.reloadData()
            self.BookNowTripRequestDetailForDriver()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromAnotherTab == false{
            self.DriverCurrentStatusDetail(true, selectedIndex: indexPathForAccess)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        self.navigationController?.isNavigationBarHidden = false
        removeAnnotaion()
        
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "bookingRequest"), object: nil)
    }
    func removeAnnotaion(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let alloverlays = self.mapView.overlays
        self.mapView.removeOverlays(alloverlays)
    }
    
    
    //---------------Main Map View---------------//
    // MARK :- map
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let locManager :AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        let center = locManager.myLocation   //mapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        if annonationId > 0 {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    deinit {
        do {
            mapView.userLocation.removeObserver(self, forKeyPath: "location")
        } catch let anException {
            print(anException)
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
        mapView.removeFromSuperview()
        // release crashes app
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // for drop pin on map (annotation)
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "MKAnnotationView"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //pinView?.image = UIImage(named:"pinred.png")
        }
        pinView!.canShowCallout = true
        
        pinView!.image = UIImage(named: ((annotation.title)! as String?)!)
        //pinred
        let annonation1 = annotation as! DriverAnnonation
        //annonation1.image = UIImage(named:"pinred.png")
        if annonation1.course.count > 0
        {
            if (annonation1.course as NSString).doubleValue > 0.0
            {
                pinView?.transform = CGAffineTransform(rotationAngle: CGFloat( M_PI * (Double(annonation1.course))! / 180.0));
            }
        }
        return pinView
        
    }
    //show route on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    @IBAction func ShowMapBtnPress(_ sender: AnyObject) {
        let btn  = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected == true{
            annonationId = 0
        }else{
            //show location with zoom
            annonationId = 1
            let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
            let center = locManager.myLocation
            let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func ResetPage(){
        if self.acceptTimerView != nil{
            self.acceptTimerView.isHidden = true
        }
        if self.arrivedView != nil{
            self.arrivedView.isHidden = true
        }
        if  self.startCancelTripView != nil{
            self.startCancelTripView.isHidden = true
        }
        if self.endOpenView != nil{
            self.endOpenView.isHidden = true
        }
        if self.accessView != nil{
            self.accessView.isHidden = true
        }
        if self.endTripView != nil{
            self.endTripView.isHidden = true
        }
        isRideStart = false
    }
    //  Get driver detail:-
    func DriverCurrentStatusDetail(_ isFirstTime : Bool ,selectedIndex : Int){
        
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            "DeviceToken" : SharedStorage.getDeviceToken() as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "DriverCurrentStatusDetail"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.isAccessRequest = false
                    self.ResetPage()
                    
                    self.arrRequest .removeAllObjects()
                    let bookTripRequestData = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = bookTripRequestData.value(forKey: "List") as! NSArray
                    for  object  in arrList{
                        let getDetail  =  BookNowTripRequestDetail(fromDictionary: object as! NSDictionary)
                        self.arrRequest .add(getDetail)
                    }
                    self.accessTableView.reloadData()
                    
                    //
                    if self.arrRequest.count == 1{
                        
                        let getDetailForNonAccess  =  self.arrRequest.object(at: 0) as! BookNowTripRequestDetail
                        self.bookTripRequestDeatil = getDetailForNonAccess
                        
                    }else{
                        
                        if isFirstTime == true{
                            self.bookTripRequestDeatil  =  self.arrRequest.object(at: 0) as! BookNowTripRequestDetail
                        }else{
                            self.bookTripRequestDeatil  =  self.arrRequest.object(at: selectedIndex) as! BookNowTripRequestDetail
                        }
                        if self.bookTripRequestDeatil.passengerCount > 0{
                            self.accessTableView.isHidden = false
                            self.accessViewBottom.constant = 0
                        }
                    }
                    //logout
                    if String(self.bookTripRequestDeatil.deviceToken) != ""{
                    if String(self.bookTripRequestDeatil.deviceToken) !=  SharedStorage.getDeviceToken(){
                        SharedStorage.setIsRememberMe(false)
                        SharedStorage.setDriverId(0)
                        UserDefaults.standard.set("", forKey: "NC_user")
                        UserDefaults.standard.synchronize()
                        SharedStorage.setUnderCapaDriverId(0)
                        self.appDelegate.loadSignInViewController()
                    }
                    }
                    
                    if self.bookTripRequestDeatil.isDriverActive == false{
                        if self.bookTripRequestDeatil.hasVehicleAdded == false ||  self.bookTripRequestDeatil.hasDriverDocAdded == false{
                           CIError("Please add your document & vehicle document then wait for admin mail for activation.")
                            //CIError("Veuillez attendre la validation du support technique Vous recevrez un mail de confirmation")
                        }
                    }
                    
                    if self.bookTripRequestDeatil.isDriverActive == false{
                        CIError("Please wait for admin mail for driver activation.")
                        //CIError("Veuillez attendre la validation du support technique Vous recevrez un mail de confirmation.")
                        SharedStorage.setIsRememberMe(false)
                        SharedStorage.setDriverId(0)
                        UserDefaults.standard.set("", forKey: "NC_user")
                        UserDefaults.standard.synchronize()
                        SharedStorage.setUnderCapaDriverId(0)
                        self.appDelegate.loadSignInViewController()
                    }
                    
                    //Online Button
                    SharedStorage.setIsOnlineOffine(self.bookTripRequestDeatil.isOnline)
                    self.custNav.StatusButtonMethod(self.statusButton)
                    
                    //tripID
                    self.tripId = String(self.bookTripRequestDeatil.tripRequestId)
                    
                    if self.bookTripRequestDeatil.isOnline == true{
                        
                        if self.bookTripRequestDeatil.isOnTrip == true{
                            if self.bookTripRequestDeatil.isdriverReached == true{
                                
                                if self.bookTripRequestDeatil.isTripStart == true{
                                    // trip started
                                    self.endOpenTripScreen()
                                }else{
                                    
                                    //star cancel
                                    self.startCancelTrip()
                                }
                            }else{
                                //arrive
                                self.arrivedViewCall()
                            }
                        }else{
                            if self.bookTripRequestDeatil.canTakeNextRide == true{
                                //home
                                self.removeAnnotaion()
                            }else{
                                if self.bookTripRequestDeatil.hasDriverRating == false{
                                    // rating screen
                                    self.endTripWithRating()
                                }
                            }
                            
                        }
                    }else{
                        
                    }
                    
                }
                else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    
                    SharedStorage.setIsRememberMe(false)
                    SharedStorage.setDriverId(0)
                    UserDefaults.standard.set("", forKey: "NC_user")
                    UserDefaults.standard.synchronize()
                    SharedStorage.setUnderCapaDriverId(0)
                    self.appDelegate.loadSignInViewController()
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
                SharedStorage.setIsRememberMe(false)
                SharedStorage.setDriverId(0)
                UserDefaults.standard.set("", forKey: "NC_user")
                UserDefaults.standard.synchronize()
                SharedStorage.setUnderCapaDriverId(0)
                self.appDelegate.loadSignInViewController()
            }
            
        }
        
    }
    
    //MARK :- Accept View
    func AcceptTimerView(){
        
        circlePV?.progress=0.0
        imagesLoop.removeAll()
        
        //ashish
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        
        self.setTimer()
        for i in 1 ..< 15
        {
            imagesLoop.append(UIImage(named: "img_\(i)")!)
            print(imagesLoop)
        }
        
        imgGif?.animationImages = imagesLoop;
        imgGif?.animationDuration = 1.0
        imgGif?.startAnimating()
    }
    
    
    
    func setTimer()  {
        
        //counterFlag = 15
        counterFlag = countDownTime
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    func updateProgress()
    {
        
        NSLog("%@", String(describing: circlePV?.progress))
        print(counterFlag)
        //0.07 * 14 = 0.98
        //if String(circlePV.progress) == "0.98"
        if counterFlag == 0{
            counterFlag = 1
        }
        let angle = Double(1 / Double(counterFlag))
        let formatted = String(format: "%.2f", angle)
        // print(formatted)
        let f = Double(formatted)
        let s = counterFlag
        let call =   f! * Double(s!)
        print(call)
        if String(circlePV.progress) == String (call)
        {
            
            if timer != nil{
                timer.invalidate()
                timer = nil
            }
            lblCircle.text = "0"
            if self.acceptTimerView != nil{
                self.acceptTimerView.isHidden = true
            }
            imgGif.stopAnimating()
            //player.stop()
            CIError("Times Up!")
            //CIError("Le temps est écoulé!")
            self.DriverCurrentStatusDetail(false , selectedIndex: indexPathForAccess)
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }else
        {
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            let path = Bundle.main.path(forResource: "ForDriver_NewRequest", ofType:"mp3")
            let fileURL = URL(fileURLWithPath: path!)
            player = try! AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
            player.prepareToPlay()
            player.play()
            
            self.lblCircle.text = String(self.counterFlag)+" sec"
            //circlePV.progress = circlePV.progress + 0.07
            circlePV.progress = circlePV.progress + Double(formatted)!
            print(circlePV.progress)
            
            
        }
    }
    // Accept trip button :-
    @IBAction func btnAcceptTripPressed(_ sender: AnyObject) {
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        self.acceptTimerView.isHidden = true
        BookNowTripRequestAccept()
    }
    // Reject trip button :-
    @IBAction func btnRejectPressed(_ sender: AnyObject) {
        self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        self.acceptTimerView.isHidden = true
        lblCircle.text = "0"
        imgGif.stopAnimating()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
    }
    // Book now trip button :-
    func BookNowTripRequestAccept(){
        print(tripId)
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "TripRequestId"     : tripId as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "BookNowTripRequestAccept"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrivedViewCall()
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    // Book now trip driver detial button :-
    func BookNowTripRequestDetailForDriver(){
        print(tripId)
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "TripRequestId"     : tripId as AnyObject,
            ]
        print(parameters)
        // appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "BookNowTripRequestDetailForDriver"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            //  self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.ResetPage()
                    self.bookTripRequestDeatil = BookNowTripRequestDetail(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    
                    if self.bookTripRequestDeatil.passengerCount > 0{
                        self.isAccessRequest = true
                    }
                    self.countDownTime = self.bookTripRequestDeatil.acceptRequestLeftTime
                    //self.counterFlag = self.bookTripRequestDeatil.acceptRequestLeftTime
                    print(self.countDownTime)
                    self.acceptScreen()
                    // for current location
                    self.annonationId = 1
                    let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
                    let center = locManager.myLocation
                    let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.mapView?.setRegion(region, animated: true)
                    
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    // Accept UI:-
    func acceptScreen(){
        
        
        self.AcceptTimerView()
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if self.acceptTimerView != nil{
                self.acceptTimerView.isHidden = false
            }
            
                    let lat : Double = Double(self.bookTripRequestDeatil.pickupLatitude )
                    let long : Double = Double(self.bookTripRequestDeatil.pickupLongitude)
            let location = CLLocation(latitude : lat , longitude: long)
            self.addressFromLatLong(location , isPickup: true ,index: 0)
            //address
            //self.lblPickUpLocationOfCustomer?.text = self.bookTripRequestDeatil.pickupAddress
            print(self.bookTripRequestDeatil.clientName)
            print(String(NikkosDriverManager.trimString(self.bookTripRequestDeatil.clientName)))
            if self.bookTripRequestDeatil.clientName != nil{
                self.lblCustomerName?.text = self.bookTripRequestDeatil.clientName
            }
        }
        
    }
    // get address from lat long
    func addressFromLatLong(_ addLocation : CLLocation, isPickup : Bool , index : Int)
    {
        if addLocation.coordinate.latitude != 0 && addLocation.coordinate.longitude != 0{
            CLGeocoder().reverseGeocodeLocation(addLocation, completionHandler: {(placemarks, error) -> Void in
                //            print("addLocationGet........>>>\(addLocation)")
                //            print("placemarks........>>>\(placemarks)")
                
                if placemarks == nil{
                    
                }else{
                    if placemarks!.count > 0 {
                        let pm = placemarks![0]
                        if let val = pm.addressDictionary!["FormattedAddressLines"] {
                            self.address = (val as AnyObject).componentsJoined(by: ", ")
                            if  isPickup == true{
                                self.lblPickUpLocationOfCustomer?.text = self.address
                                self.lblPickupLocationArrived?.text = self.address
                                self.lblPickUpLocationStart?.text = self.address
                                self.lblPickUpLocationEnd?.text = self.address
                                self.lblPickUpInfo?.text = self.address
                                if self.isAccessRequest == true{
                                    let indexPath = IndexPath(row: index, section: 0)
                                    print(indexPath)
                                    let cell : AccessTableViewCell?  = self.accessTableView?.cellForRow(at: indexPath) as? AccessTableViewCell
                                    cell?.lblPickUpLocation?.text = self.address
                                }
                            }else{
                                self.lblDropOfLocationStart?.text = self.address
                                self.lblDropUpLocationEnd?.text = self.address
                                self.lblDropOfInfo?.text = self.address
                            }
                            print(self.address)
                            
                        }
                        
                    }
                    else {
                        print("Problem with the data received from geocoder")
                    }
                }
            })
            
        }
    }
    
    
    //MARK :- ARRIVED view
    
    func arrivedViewCall(){
        
        self.arrivedView.isHidden = false
        //For route drow
        let pickUpLat : Double = Double(self.bookTripRequestDeatil.pickupLatitude )
        let pickUpLong : Double = Double(self.bookTripRequestDeatil.pickupLongitude)
        
        let dropUpLat : Double = Double(self.bookTripRequestDeatil.dropLatitude )
        let dropUpLong : Double = Double(self.bookTripRequestDeatil.dropLongitude)
//
       
        let location = CLLocation(latitude : pickUpLat , longitude: pickUpLong)
        self.addressFromLatLong(location , isPickup: true ,index: 0)
        
        //address
       // self.lblPickupLocationArrived?.text = self.bookTripRequestDeatil.pickupAddress
        
        self.lblCustomerNameArrived.text = self.bookTripRequestDeatil.clientName
        print("eta>>>>>" , self.bookTripRequestDeatil.eTA)
        self.lblEtaArrived.text = String("ETA ") + String(self.bookTripRequestDeatil.eTA) + "min"
        //............
        //ashish
        /*
        let pickUpDistanceLocation = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong)
        let dropOffDistanceLocation = CLLocationCoordinate2D(latitude: dropUpLat, longitude: dropUpLong)
        let alloverlays = self.mapView.overlays
        self.mapView.removeOverlays(alloverlays)
        self.addRoutesOverLayForMapView(pickUpDistanceLocation,dropOffDistanceLocation: dropOffDistanceLocation)
        //For drop Pin (annonation)
        let annPickUp = DriverAnnonation(coordinate: pickUpDistanceLocation, title: "",course:"")
        let annDropUp = DriverAnnonation(coordinate: dropOffDistanceLocation, title: "",course:"")
        annPickUp.title = "To"
        annDropUp.title = "from"
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotation(annPickUp)
        self.mapView.addAnnotation(annDropUp)
        */
        
        
        let pickUpDistanceLocation = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong)
        let alloverlays = self.mapView.overlays
        self.mapView.removeOverlays(alloverlays)
        //For drop Pin (annonation)
        let annPickUp = DriverAnnonation(coordinate: pickUpDistanceLocation, title: "",course:"")
        annPickUp.title = "To"
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotation(annPickUp)
        
        //............
        
        //for show all pin
        annonationId = -1
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        //for access view
        if isAccessRequest == true{
            
            self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
        }
        if self.bookTripRequestDeatil.passengerCount > 0{
            
            accessView.isHidden = false
            accessViewBottom.constant = arrivedView.frame.height
            self.accessTableView.reloadData()
        }
        
        //For Open Map
        latMap = String(self.bookTripRequestDeatil.pickupLatitude)
        longMap = String(self.bookTripRequestDeatil.pickupLongitude)
        
        latDropMap = String(self.bookTripRequestDeatil.dropLatitude)
        longDropMap = String(self.bookTripRequestDeatil.dropLongitude)
        
        
    }
    // Arrived button :-
    @IBAction func btnArrivedPressed(_ sender: AnyObject) {
        let parameters: [String: AnyObject] = [
            "TripRequestId"     : tripId as AnyObject,
            "DriverId"     : SharedStorage.getDriverId()
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "DriverArrivedForTrip"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    self.arrivedView.isHidden = true
                    self.startCancelTrip()
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
    }
    // Call button :-
    @IBAction func btnCallPress(_ sender: AnyObject) {
        let number = self.bookTripRequestDeatil.clientPhoneNumber
//        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.openURL(url)
//        }
        guard let url = URL(string: "tel://" + number!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url as URL)
        }
    }
    // SMS button :-
    @IBAction func btnSmsPress(_ sender: AnyObject) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            let number = self.bookTripRequestDeatil.clientPhoneNumber
            controller.recipients = [number!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    //Info popup
    @IBAction func btnInfoPress(_ sender: AnyObject) {
        
        infoView.showInView(self.view)
        
        let parameters: [String: AnyObject] = [
            "ID"     : tripId as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Trip + "GetTripDetail"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.tripInfo = TripInfoModel(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    self.setInfoValue()
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    func setInfoValue(){
        lblDriverNameInfo.text = self.tripInfo.driverName
        lblDriverNo.text = self.tripInfo.driverPhoneNumber
        lblLincesNoInfo.text = self.tripInfo.licenseNumber
        lblVehicleNoInfo.text = self.tripInfo.platNumber
        lblVtcInfo.text = self.tripInfo.vtcNumber
        let pickUpLat : Double = Double(self.tripInfo.pickupLatitude )
        let pickUpLong : Double = Double(self.tripInfo.pickupLongitude)
        
        let dropUpLat : Double = Double(self.tripInfo.dropLatitude )
        let dropUpLong : Double = Double(self.tripInfo.dropLongitude)
        
        let locationPickup = CLLocation(latitude : pickUpLat , longitude: pickUpLong)
        let locationDropup = CLLocation(latitude : dropUpLat , longitude: dropUpLong)
        
        self.addressFromLatLong(locationPickup , isPickup: true ,index: 0)
        self.addressFromLatLong(locationDropup , isPickup: false ,index: 0)
        
        lblClientName.text = self.tripInfo.clientName
        lblClientnoInfo.text = self.tripInfo.clientPhoneNumber
        //lblClientnoInfo.text = "06.44.44.44.44"
        //image
        if self.tripInfo.clientImage != nil{
            ImgClientInfo.imageURL = URL(string:self.tripInfo.clientImage)
        }
        //image
        if self.tripInfo.driverImage != nil{
            driverInfoImg.imageURL = URL(string:self.tripInfo.driverImage)
        }
    }
    @IBAction func btnDoneInfoPress(_ sender: AnyObject) {
        self.infoView.removeAnimate()
    }
    
    @IBAction func btnNavigationPress(_ sender: AnyObject) {
        
        //For route drow
        let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        let currnetLocation = locManager.myLocation
        
        let currentLat : Double = Double(currnetLocation!.latitude )
        let currentLong : Double = Double(currnetLocation!.longitude)
        
        let pickUpLat : Double = Double(self.bookTripRequestDeatil.pickupLatitude )
        let pickUpLong : Double = Double(self.bookTripRequestDeatil.pickupLongitude)
        
        let currentDistanceLocation = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
        let pickUpDistanceLocation = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong)
        
        let alloverlays = self.mapView.overlays
        self.mapView.removeOverlays(alloverlays)
        self.addRoutesOverLayForMapView(currentDistanceLocation,dropOffDistanceLocation: pickUpDistanceLocation)
        
        openGoogleMapApp(String(self.bookTripRequestDeatil.pickupLatitude) , long: String(self.bookTripRequestDeatil.pickupLongitude))
    }
    @IBAction func btnCancelTripPress(_ sender: AnyObject) {
        
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = "Onthego!"
        createAccountErrorAlert.message = "Do you want to cancel this ride?"
        createAccountErrorAlert.addButton(withTitle: "No")
        createAccountErrorAlert.addButton(withTitle: "Yes")
        createAccountErrorAlert.show()
        
        
        
    }
    func getCancelReasonList(){
        let parameters: [String: AnyObject] = [
            "ReasonType"     : "2" as AnyObject
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_OnlyCommon + "CancelReasonList"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let allCancelReasonDict = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = allCancelReasonDict.value(forKey: "List") as! NSArray
                    self.arrAllReasonData.removeAllObjects()
                    self.arrReasonId.removeAllObjects()
                    for  object  in arrList{
                        self.cancelReason =  CancelReasonModel(fromDictionary: object as! NSDictionary)
                        self.arrAllReasonData .add(self.cancelReason.reason)
                        self.arrReasonId .add(self.cancelReason.reasonId)
                    }
                    self.reasonTblView.reloadData()
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    func cancelRide(_ id : Int){
        let parameters: [String: AnyObject] = [
            "TripId"     : tripId as AnyObject,
            "ReasonId"     : id as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "CancelRideFromDriver"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    self.popupView.removeAnimate()
                    self.ResetPage()
                    self.DriverCurrentStatusDetail(false, selectedIndex: 0)
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    self.removeAnnotaion()
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    //reason table view
    // MARK: - TableView Delegate
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == accessTableView {
            //accessViewHeight.constant = 60
            if arrRequest.count == 1 {
                accessViewHeight.constant = 42
            }else if arrRequest.count == 2 {
                accessViewHeight.constant = 42 * 2
            }else if arrRequest.count == 3 {
                accessViewHeight.constant = 42 * 3
            }else if arrRequest.count == 4 {
                accessViewHeight.constant = 42 * 4
            }
            return arrRequest.count
        }else{
            return arrAllReasonData.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView()
        
        if tableView == accessTableView{
            
            let cell : AccessTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "AccessCell", for: indexPath) as! AccessTableViewCell
            let requestData = self.arrRequest.object(at: indexPath.row) as! BookNowTripRequestDetail
            self.bookTripRequestDeatil = requestData
            cell.lblName.text = requestData.clientName
            
            
            //address
            /*
             let pickUpLat : Double = Double(requestData.pickupLatitude )
             let pickUpLong : Double = Double(requestData.pickupLongitude)
             let locationPickup = CLLocation(latitude : pickUpLat , longitude: pickUpLong)
             self.addressFromLatLong(locationPickup , isPickup: true ,index: indexPath.row)
             */
            cell.lblPickUpLocation?.text = requestData.pickupAddress
            
            cell.lblStatus.layer.cornerRadius = 5
            cell.lblStatus.layer.masksToBounds = true
            //status
            if requestData.isOnline == true{
                
                if requestData.isOnTrip == true{
                    if requestData.isdriverReached == true{
                        
                        if requestData.isTripStart == true{
                            // trip started
                            cell.lblStatus.text = "Start"
                            cell.lblStatus.textColor = UIColor.white
                            cell.lblStatus.backgroundColor = UIColor(red: 1/255.0, green: 74/255.0, blue: 117/255.0, alpha: 1.0)
                            
                            
                        }else{
                            
                            //star cancel
                            cell.lblStatus.text = "Cancel"
                            cell.lblStatus.textColor = UIColor.white
                            cell.lblStatus.backgroundColor = UIColor(red: 1/255.0, green: 74/255.0, blue: 117/255.0, alpha: 1.0)
                            
                            
                        }
                    }else{
                        //arrive
                        cell.lblStatus.text = "Arrive"
                        cell.lblStatus.textColor = UIColor.white
                        cell.lblStatus.backgroundColor = UIColor(red: 1/255.0, green: 74/255.0, blue: 117/255.0, alpha: 1.0)
                        
                    }
                    
                }else{
                    if requestData.canTakeNextRide == true{
                        //home
                    }else{
                        if requestData.hasDriverRating == false{
                            // rating screen
                            cell.lblStatus.text = "End Trip"
                            cell.lblStatus.textColor = UIColor.white
                            cell.lblStatus.backgroundColor = UIColor(red: 219/255.0, green: 71/255.0, blue: 51/255.0, alpha: 1.0)
                            
                        }
                    }
                    
                }
            }
            
            //img
            if requestData.isdriverReached == true{
                if requestData.clientProfileImage != nil{
                    cell.imgClient.imageURL = URL(string:requestData.clientProfileImage)
                }
            }
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
        }else{
            
            let cell : ReasonTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath) as! ReasonTableViewCell
            cell.lblCancelReason.text = arrAllReasonData.object(at: indexPath.row) as? String
            if selectedReasonCellIndex == indexPath.row
            {
                cell.backgroundColor = UIColor.lightGray
            }else
            {
                cell.backgroundColor = UIColor.white
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        if tableView == accessTableView{
            
            // if self.bookTripRequestDeatil.hasDriverRating == true{
            indexPathForAccess = indexPath.row
            self.bookTripRequestDeatil = self.arrRequest.object(at: indexPath.row) as! BookNowTripRequestDetail
            self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
            // }
        }else{
            selectedReasonCellIndex = indexPath.row
            let object = arrAllReasonData.object(at: selectedReasonCellIndex)
            let index = arrAllReasonData .index(of: object)
            let id : Int = Int(arrReasonId .object(at: index) as! NSNumber)
            //reasonTblView.reloadData()
            //self.navigationItem.leftBarButtonItem?.enabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            cancelRide(id)
            
        }
        
    }
    func alertView(_ View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex
        {
        case 0:
            
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.popupView.removeAnimate()
            
            break;
        case 1:
            
            self.getCancelReasonList()
            popupView.showInView(self.view)
            
            break;
        default:
            break;
            //Some code here..
        }
    }
    
    @IBAction func cancelBtnPressPopView(_ sender: AnyObject) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.popupView.removeAnimate()
        // cancelRide()
    }
    //MARK :-  Start trip view
    func startCancelTrip()  {
        
        startCancelTripView.isHidden = false
        
        
        let pickUpLat : Double = Double(self.bookTripRequestDeatil.pickupLatitude )
        let pickUpLong : Double = Double(self.bookTripRequestDeatil.pickupLongitude)
        
        let dropUpLat : Double = Double(self.bookTripRequestDeatil.dropLatitude )
        let dropUpLong : Double = Double(self.bookTripRequestDeatil.dropLongitude)
        
        let locationPickup = CLLocation(latitude : pickUpLat , longitude: pickUpLong)
        let locationDropup = CLLocation(latitude : dropUpLat , longitude: dropUpLong)
        
        self.addressFromLatLong(locationPickup , isPickup: true ,index: 0)
        self.addressFromLatLong(locationDropup , isPickup: false ,index: 0)
        
        self.lblCustomerNameStart.text = self.bookTripRequestDeatil.clientName
        
        
        
        //ashish
        //.............
        let pickUpDistanceLocation = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong)
        let dropOffDistanceLocation = CLLocationCoordinate2D(latitude: dropUpLat, longitude: dropUpLong)
        let alloverlays = self.mapView.overlays
        self.mapView.removeOverlays(alloverlays)
        //ashish
        self.addRoutesOverLayForMapView(pickUpDistanceLocation,dropOffDistanceLocation: dropOffDistanceLocation)
        
        //For drop Pin (annonation)
        let annPickUp = DriverAnnonation(coordinate: pickUpDistanceLocation, title: "",course:"")
        let annDropUp = DriverAnnonation(coordinate: dropOffDistanceLocation, title: "",course:"")
        annPickUp.title = "To"
        annDropUp.title = "from"
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotation(annPickUp)
        self.mapView.addAnnotation(annDropUp)
        //..............
        
        
        
        
        //address
        self.lblPickUpLocationStart?.text = self.bookTripRequestDeatil.pickupAddress
        self.lblDropOfLocationStart?.text = self.bookTripRequestDeatil.dropupAddress
        
        //image
        if self.bookTripRequestDeatil.clientProfileImage != nil{
            self.imgCustomer.imageURL = URL(string:self.bookTripRequestDeatil.clientProfileImage)
        }
        
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        //For Open Map
        latMap = String(self.bookTripRequestDeatil.pickupLatitude)
        longMap = String(self.bookTripRequestDeatil.pickupLongitude)
        
        latDropMap = String(self.bookTripRequestDeatil.dropLatitude)
        longDropMap = String(self.bookTripRequestDeatil.dropLongitude)
        
        
        self.bookTripRequestDeatil = arrRequest.object(at: indexPathForAccess) as! BookNowTripRequestDetail
        //for access view
        if isAccessRequest == true{
            self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
        }
        if self.bookTripRequestDeatil.passengerCount > 0{
            accessView.isHidden = false
            accessViewBottom.constant = startCancelTripView.frame.height
            self.accessTableView.reloadData()
        }
        
    }
    @IBAction func startTripBtnPress(_ sender: AnyObject) {
        let parameters: [String: AnyObject] = [
            "TripRequestId"     : tripId as AnyObject,
            "DriverId"     : SharedStorage.getDriverId()
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "PostTripStartStatus"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    //CIError(data?.valueForKey("ResponseMessage") as! String)
                    self.startCancelTripView.isHidden = true
                    //ashish
                    //self.endOpenTripScreen()
                    self.DriverCurrentStatusDetail(false, selectedIndex: self.indexPathForAccess)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    
    //MARK :- End Open trip view
    func endOpenTripScreen(){
        endOpenView.isHidden = false
        
        let pickUpLat : Double = Double(self.bookTripRequestDeatil.pickupLatitude )
        let pickUpLong : Double = Double(self.bookTripRequestDeatil.pickupLongitude)
        
        let dropUpLat : Double = Double(self.bookTripRequestDeatil.dropLatitude )
        let dropUpLong : Double = Double(self.bookTripRequestDeatil.dropLongitude)
        
        let locationPickup = CLLocation(latitude : pickUpLat , longitude: pickUpLong)
        let locationDropup = CLLocation(latitude : dropUpLat , longitude: dropUpLong)
        
        self.addressFromLatLong(locationPickup , isPickup: true ,index: 0)
        self.addressFromLatLong(locationDropup , isPickup: false ,index: 0)
        
        self.lblCustomerNameEnd.text = self.bookTripRequestDeatil.clientName
        //address
//        self.lblPickUpLocationEnd?.text = self.bookTripRequestDeatil.pickupAddress
//        self.lblDropUpLocationEnd?.text = self.bookTripRequestDeatil.dropupAddress
        //image
        if self.bookTripRequestDeatil.clientProfileImage != nil{
            self.imgCustomerEnd.imageURL = URL(string:self.bookTripRequestDeatil.clientProfileImage)
        }
            
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        //For Open Map
        latMap = String(self.bookTripRequestDeatil.pickupLatitude)
        longMap = String(self.bookTripRequestDeatil.pickupLongitude)
        print(latMap)
        print(longMap)
        latDropMap = String(self.bookTripRequestDeatil.dropLatitude)
        longDropMap = String(self.bookTripRequestDeatil.dropLongitude)
        print(latDropMap)
        print(longDropMap)
        self.bookTripRequestDeatil = arrRequest.object(at: indexPathForAccess) as! BookNowTripRequestDetail
        //for access view
        if isAccessRequest == true{
            self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
        }
        if self.bookTripRequestDeatil.passengerCount > 0{
            accessView.isHidden = false
            accessViewBottom.constant = endOpenView.frame.height
            self.accessTableView.reloadData()
            
//            self.btnChangeToOpen.isUserInteractionEnabled = false
//            self.btnChangeToOpen.alpha = 0.2
        }else
        {
            if self.bookTripRequestDeatil.hasRideOpen == false{
//                self.btnChangeToOpen.isUserInteractionEnabled = true
//                self.btnChangeToOpen.alpha = 1
            }else{
//                self.btnChangeToOpen.isUserInteractionEnabled = false
//                self.btnChangeToOpen.alpha = 0.2
            }
        }
    }
    @IBAction func changeToOpenBtnPress(_ sender: AnyObject) {
        
        
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "TripRequestId"     : tripId as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "ConvertTripToOpen"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
//                    self.btnChangeToOpen.isUserInteractionEnabled = false
//                    self.btnChangeToOpen.alpha = 0.2
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    @IBAction func endTripBtnPress(_ sender: AnyObject) {
        
        //self.ResetPage()
        //For route drow
        let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        let currnetLocation = locManager.myLocation
        
        let currentLat : Double = Double(currnetLocation!.latitude )
        let currentLong : Double = Double(currnetLocation!.longitude)
        if currentLat != 0 && currentLat != 0{
            let parameters: [String: AnyObject] = [
                "DriverId"     : SharedStorage.getDriverId(),
                "TripRequestId"     : tripId as AnyObject,
                "DropOffLatitude" : currentLat as AnyObject,
                "DropOffLongitude" : currentLong as AnyObject,
                ]
            print(parameters)
            appDelegate.showHud()
            WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "EndTrip"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                self.appDelegate.dissmissHud()
                if status == true
                {
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        self.arrRequest .removeAllObjects()
                        let bookTripRequestData = data?.value(forKey: "Data") as! NSDictionary
                        
                        let arrList  = bookTripRequestData.value(forKey: "List") as! NSArray
                        for  object  in arrList{
                            let getDetail  =  BookNowTripRequestDetail(fromDictionary: object as! NSDictionary)
                            self.arrRequest .add(getDetail)
                        }
                        self.accessTableView.reloadData()
                        
                        
                        let getDetailForNonAccess  =  self.arrRequest.object(at: 0) as! BookNowTripRequestDetail
                        self.bookTripRequestDeatil = getDetailForNonAccess
                        
                        if self.bookTripRequestDeatil.passengerCount > 0{
                            self.accessTableView.isHidden = false
                            self.accessViewBottom.constant = 0
                        }
                        //end trip with rating
                        self.endOpenView.isHidden = true
                        self.endTripWithRating()
                        //self.removeaAnnotations()
                    }else
                    {
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }
                }
                else
                {
                    CIError("OOPs something went wrong.")
                }
            }
            
        }else{
            CIError("Please allow Onthego to access your location.")
        }
        
        
    }
    //MARK :- End Trip with rating
    func endTripWithRating(){
        endTripView.isHidden = false
        setStarRating()
       
       // self.totalAmount.text =  self.bookTripRequestDeatil.tripAmount
        self.billAmountLbl.text =  self.bookTripRequestDeatil.BillAmount
        self.lblPaymentType.text =   String( self.bookTripRequestDeatil.paymentMode)
            
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        //for access view
        if isAccessRequest == true{
            self.DriverCurrentStatusDetail(false, selectedIndex: indexPathForAccess)
        }else{
            self.removeAnnotaion()
        }
        if self.bookTripRequestDeatil.passengerCount > 0{
            accessView.isHidden = false
            accessViewBottom.constant = endTripView.frame.height
            self.accessTableView.reloadData()
            
            self.btnGoOffline.isUserInteractionEnabled = false
            self.btnGoOffline.alpha = 0.5
        }
    }
    func setStarRating() {
        starRatingEnd.starImage = UIImage(named: "star_select-1")!
        starRatingEnd.starHighlightedImage = UIImage(named: "star_select")!
        starRatingEnd.maxRating = 5
        starRatingEnd.delegate = self
        starRatingEnd.horizontalMargin = 12
        starRatingEnd.editable = true
        starRatingEnd.rating = 0
        //starRatingEnd.displayMode =  EDStarRatingDisplayAccurate
    }
    
    func starsSelectionChanged(_ control: EDStarRating, rating: Float) {
        Rating = String(format: "%.0f", rating)
    }
    
    
    @IBAction func availableForNextTripBtnPress(_ sender: AnyObject? ) {
        if Rating != "-1" && Rating  != "0"{
            let parameters: [String: AnyObject] = [
                "TripRequestId"     : tripId as AnyObject,
                "Rating"   : Rating as AnyObject,
                "Feedback" : "" as AnyObject,
                ]
            print(parameters)
            appDelegate.showHud()
            WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "PostRatingByDriver"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                self.appDelegate.dissmissHud()
                if status == true
                {
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        self.ResetPage()
                        if self.bookTripRequestDeatil.passengerCount > 0{
                            self.DriverCurrentStatusDetail(false, selectedIndex: self.indexPathForAccess)
                        }else{
                        }
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    }else
                    {
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }
                }
                else
                {
                    CIError("OOPs something went wrong.")
                }
            }
        }else{
            CIError("Please rate the customer.")
        }
    }
    
    @IBAction func goOfflineBtnPress(_ sender: AnyObject) {
        if arrRequest.count == 1{
            if Rating != "-1" && Rating  != "0"{
                self.availableForNextTripBtnPress(nil)
                self.ResetPage()
                SharedStorage.setIsOnlineOffine(false)
                self.custNav.StatusButtonMethod(self.statusButton)
            }else{
                CIError("Please rate the customer.")
            }
        }
    }
    
    
    
    
    //show Route
    func addRoutesOverLayForMapView(_ pickUpDistanceLocation: CLLocationCoordinate2D, dropOffDistanceLocation:CLLocationCoordinate2D ){
        
        var source:MKMapItem?
        var destination:MKMapItem?
        
        
        
        if dropOffDistanceLocation.latitude != -1.0
        {
            let sourcePlacemark = MKPlacemark(coordinate: pickUpDistanceLocation, addressDictionary: nil)
            source = MKMapItem(placemark: sourcePlacemark)
            
            let desitnationPlacemark = MKPlacemark(coordinate: dropOffDistanceLocation, addressDictionary: nil)
            destination = MKMapItem(placemark: desitnationPlacemark)
            let request:MKDirectionsRequest = MKDirectionsRequest()
            request.source = source
            request.destination = destination
            request.transportType = MKDirectionsTransportType.automobile
            /*let directions = MKDirections(request: request)
            directions.calculate (completionHandler: {
                (response: MKDirectionsResponse?, error: NSError?) in
                if error == nil
                {
                    self.showRoute(response!)
                }
                else
                {
                    print("trace the error \(error?.localizedDescription)")
                }
            }*/
            // Calculate the direction
            let directions = MKDirections(request: request)
            directions.calculate {
                (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    func showRoute(_ response:MKDirectionsResponse){
        for route in response.routes
        {
            mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let routeSeconds = route.expectedTravelTime
            let routeDistance = route.distance
            print("distance between two points is \(routeSeconds) and \(routeDistance)")
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    @IBAction func btnOpenMapPressed(_ sender: AnyObject) {
        let btn : UIButton = sender as! UIButton
        if btn.tag == 1{
           // openMapForPlace(latMap , long: longMap)
            openGoogleMapApp(latMap , long: longMap)
        }else{
          //  openMapForPlace(latDropMap , long: longDropMap)
            openGoogleMapApp(latDropMap , long: longDropMap)
        }
    }
    // Open Map App with Lat long
    func openMapForPlace(_ lat : String , long : String)  {
        
        let lat1 : NSString = lat as NSString
        let lng1 : NSString = long as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        //mapItem.name = "\(self.venueName)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    // open google application with lat long
    func openGoogleMapApp(_ lat : String , long : String){
        print(lat)
        print(long)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")!)
            
        } else {
            NSLog("Can't use comgooglemaps://");
            let lat1 : NSString = lat as NSString
            let lng1 : NSString = long as NSString
            
            let latitude:CLLocationDegrees =  lat1.doubleValue
            let longitude:CLLocationDegrees =  lng1.doubleValue
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            //mapItem.name = "\(self.venueName)"
            mapItem.openInMaps(launchOptions: options)
        }
    
    }

    //MARK :-
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
