
//
//  LiveGPSMAPViewController.swift
//  NikkosDriver
//
//  Created by Ashish Soni on 14/11/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import MapKit
class LiveGPSMAPViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var underDriverId : String!
    var liveGps : liveGPS!
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for update location of driver
        let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        locManager.startUpdateingLocation()
        mapView.delegate = self
        mapView.userLocation.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions.old, context: nil)
        
        //zoom location
        let center = locManager.myLocation
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        getDriverCurrentLocation()
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
    
    
    @IBAction func btnRefreshPressed(_ sender: AnyObject) {
        getDriverCurrentLocation()
    }
    func getDriverCurrentLocation() {
        let parameters: [String: AnyObject] = [
            "ID"     : underDriverId as AnyObject
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetDriverLocation"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.liveGps = liveGPS(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    // set lat long on map
                    let lat : Double = Double(self.liveGps.locationLat )
                    let long : Double = Double(self.liveGps.locationLong)
                    
                    //For drop Pin (annonation)
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    //annotation Method
                    let annDriverLocation = DriverAnnonation(coordinate: location, title: "",course:"")
                    
                    annDriverLocation.title = self.liveGps.vehicleType
                    annDriverLocation.course = self.liveGps.course
                    
                    let allAnnotations = self.mapView.annotations
                    self.mapView.removeAnnotations(allAnnotations)
                    self.mapView.addAnnotation(annDriverLocation)
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
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = true
        // i am not sure about this line so must try this by commenting
        
        pinView!.image = UIImage(named: ((annotation.title)! as String?)!)
        
        let annonation1 = annotation as! DriverAnnonation
        if annonation1.course.count > 0
        {
            
            if (annonation1.course as NSString).doubleValue > 0.0
            {
                pinView?.transform = CGAffineTransform(rotationAngle: CGFloat( M_PI * (Double(annonation1.course))! / 180.0));
            }
            
        }
        
        return pinView
        
    }
    
    
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
