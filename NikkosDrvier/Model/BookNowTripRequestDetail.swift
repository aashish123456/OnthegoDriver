//
//	BookNowTripRequestDetail.swift
//
//	Create by admin on 10/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BookNowTripRequestDetail : NSObject, NSCoding{

	var acceptRequestLeftTime : Int!
	var canTakeNextRide : Bool!
	var clientId : Int!
	var clientName : String!
	var clientPhoneNumber : String!
	var clientProfileImage : String!
	var clientRating : Double!
	var driverId : Int!
	var dropLatitude : Double!
	var dropLongitude : Double!
	var dropupAddress : String!
	var eTA : Int!
	var hasDriverDocAdded : Bool!
	var hasDriverRating : Bool!
	var hasVehicleAdded : Bool!
	var isDriverActive : Bool!
	var isOnTrip : Bool!
	var isOnline : Bool!
	var isTripStart : Bool!
	var isdriverReached : Bool!
	var passengerCount : Int!
	var paymentMode : String!
	var pickupAddress : String!
	var pickupLatitude : Double!
	var pickupLongitude : Double!
	var tripAmount : String!
    var BillAmount : String!
	var tripRequestId : Int!
	var success : Bool!
    var deviceToken : String!
    var hasRideOpen : Bool!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		acceptRequestLeftTime = dictionary["AcceptRequestLeftTime"] as? Int
		canTakeNextRide = dictionary["CanTakeNextRide"] as? Bool
		clientId = dictionary["ClientId"] as? Int
		clientName = dictionary["ClientName"] as? String
		clientPhoneNumber = dictionary["ClientPhoneNumber"] as? String
		clientProfileImage = dictionary["ClientProfileImage"] as? String
		clientRating = dictionary["ClientRating"] as? Double
		driverId = dictionary["DriverId"] as? Int
		dropLatitude = dictionary["DropLatitude"] as? Double
		dropLongitude = dictionary["DropLongitude"] as? Double
		dropupAddress = dictionary["DropupAddress"] as? String
		eTA = dictionary["ETA"] as? Int
		hasDriverDocAdded = dictionary["HasDriverDocAdded"] as? Bool
		hasDriverRating = dictionary["HasDriverRating"] as? Bool
		hasVehicleAdded = dictionary["HasVehicleAdded"] as? Bool
		isDriverActive = dictionary["IsDriverActive"] as? Bool
		isOnTrip = dictionary["IsOnTrip"] as? Bool
		isOnline = dictionary["IsOnline"] as? Bool
		isTripStart = dictionary["IsTripStart"] as? Bool
		isdriverReached = dictionary["IsdriverReached"] as? Bool
		passengerCount = dictionary["PassengerCount"] as? Int
		paymentMode = dictionary["PaymentMode"] as? String
		pickupAddress = dictionary["PickupAddress"] as? String
		pickupLatitude = dictionary["PickupLatitude"] as? Double
		pickupLongitude = dictionary["PickupLongitude"] as? Double
		tripAmount = dictionary["TripAmount"] as? String
        BillAmount = dictionary["BillAmount"] as? String
		tripRequestId = dictionary["TripRequestId"] as? Int
		success = dictionary["success"] as? Bool
        deviceToken = dictionary["DeviceToken"] as? String
        hasRideOpen = dictionary["HasRideOpen"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if acceptRequestLeftTime != nil{
			dictionary["AcceptRequestLeftTime"] = acceptRequestLeftTime
		}
		if canTakeNextRide != nil{
			dictionary["CanTakeNextRide"] = canTakeNextRide
		}
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if clientName != nil{
			dictionary["ClientName"] = clientName
		}
		if clientPhoneNumber != nil{
			dictionary["ClientPhoneNumber"] = clientPhoneNumber
		}
		if clientProfileImage != nil{
			dictionary["ClientProfileImage"] = clientProfileImage
		}
		if clientRating != nil{
			dictionary["ClientRating"] = clientRating
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if dropLatitude != nil{
			dictionary["DropLatitude"] = dropLatitude
		}
		if dropLongitude != nil{
			dictionary["DropLongitude"] = dropLongitude
		}
		if dropupAddress != nil{
			dictionary["DropupAddress"] = dropupAddress
		}
		if eTA != nil{
			dictionary["ETA"] = eTA
		}
		if hasDriverDocAdded != nil{
			dictionary["HasDriverDocAdded"] = hasDriverDocAdded
		}
		if hasDriverRating != nil{
			dictionary["HasDriverRating"] = hasDriverRating
		}
		if hasVehicleAdded != nil{
			dictionary["HasVehicleAdded"] = hasVehicleAdded
		}
		if isDriverActive != nil{
			dictionary["IsDriverActive"] = isDriverActive
		}
		if isOnTrip != nil{
			dictionary["IsOnTrip"] = isOnTrip
		}
		if isOnline != nil{
			dictionary["IsOnline"] = isOnline
		}
		if isTripStart != nil{
			dictionary["IsTripStart"] = isTripStart
		}
		if isdriverReached != nil{
			dictionary["IsdriverReached"] = isdriverReached
		}
		if passengerCount != nil{
			dictionary["PassengerCount"] = passengerCount
		}
		if paymentMode != nil{
			dictionary["PaymentMode"] = paymentMode
		}
		if pickupAddress != nil{
			dictionary["PickupAddress"] = pickupAddress
		}
		if pickupLatitude != nil{
			dictionary["PickupLatitude"] = pickupLatitude
		}
		if pickupLongitude != nil{
			dictionary["PickupLongitude"] = pickupLongitude
		}
		if tripAmount != nil{
			dictionary["TripAmount"] = tripAmount
		}
        if BillAmount != nil{
            dictionary["BillAmount"] = BillAmount
        }
		if tripRequestId != nil{
			dictionary["TripRequestId"] = tripRequestId
		}
		if success != nil{
			dictionary["success"] = success
		}
        if deviceToken != nil{
            dictionary["DeviceToken"] = deviceToken
        }
        if hasRideOpen != nil{
            dictionary["HasRideOpen"] = success
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         acceptRequestLeftTime = aDecoder.decodeObject(forKey: "AcceptRequestLeftTime") as? Int
         canTakeNextRide = aDecoder.decodeObject(forKey: "CanTakeNextRide") as? Bool
         clientId = aDecoder.decodeObject(forKey: "ClientId") as? Int
         clientName = aDecoder.decodeObject(forKey: "ClientName") as? String
         clientPhoneNumber = aDecoder.decodeObject(forKey: "ClientPhoneNumber") as? String
         clientProfileImage = aDecoder.decodeObject(forKey: "ClientProfileImage") as? String
         clientRating = aDecoder.decodeObject(forKey: "ClientRating") as? Double
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         dropLatitude = aDecoder.decodeObject(forKey: "DropLatitude") as? Double
         dropLongitude = aDecoder.decodeObject(forKey: "DropLongitude") as? Double
         dropupAddress = aDecoder.decodeObject(forKey: "DropupAddress") as? String
         eTA = aDecoder.decodeObject(forKey: "ETA") as? Int
         hasDriverDocAdded = aDecoder.decodeObject(forKey: "HasDriverDocAdded") as? Bool
         hasDriverRating = aDecoder.decodeObject(forKey: "HasDriverRating") as? Bool
         hasVehicleAdded = aDecoder.decodeObject(forKey: "HasVehicleAdded") as? Bool
         isDriverActive = aDecoder.decodeObject(forKey: "IsDriverActive") as? Bool
         isOnTrip = aDecoder.decodeObject(forKey: "IsOnTrip") as? Bool
         isOnline = aDecoder.decodeObject(forKey: "IsOnline") as? Bool
         isTripStart = aDecoder.decodeObject(forKey: "IsTripStart") as? Bool
         isdriverReached = aDecoder.decodeObject(forKey: "IsdriverReached") as? Bool
         passengerCount = aDecoder.decodeObject(forKey: "PassengerCount") as? Int
         paymentMode = aDecoder.decodeObject(forKey: "PaymentMode") as? String
         pickupAddress = aDecoder.decodeObject(forKey: "PickupAddress") as? String
         pickupLatitude = aDecoder.decodeObject(forKey: "PickupLatitude") as? Double
         pickupLongitude = aDecoder.decodeObject(forKey: "PickupLongitude") as? Double
         tripAmount = aDecoder.decodeObject(forKey: "TripAmount") as? String
         BillAmount = aDecoder.decodeObject(forKey: "BillAmount") as? String
         tripRequestId = aDecoder.decodeObject(forKey: "TripRequestId") as? Int
         success = aDecoder.decodeObject(forKey: "success") as? Bool
         deviceToken = aDecoder.decodeObject(forKey: "DeviceToken") as? String
         hasRideOpen = aDecoder.decodeObject(forKey: "HasRideOpen") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if acceptRequestLeftTime != nil{
			aCoder.encode(acceptRequestLeftTime, forKey: "AcceptRequestLeftTime")
		}
		if canTakeNextRide != nil{
			aCoder.encode(canTakeNextRide, forKey: "CanTakeNextRide")
		}
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if clientName != nil{
			aCoder.encode(clientName, forKey: "ClientName")
		}
		if clientPhoneNumber != nil{
			aCoder.encode(clientPhoneNumber, forKey: "ClientPhoneNumber")
		}
		if clientProfileImage != nil{
			aCoder.encode(clientProfileImage, forKey: "ClientProfileImage")
		}
		if clientRating != nil{
			aCoder.encode(clientRating, forKey: "ClientRating")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if dropLatitude != nil{
			aCoder.encode(dropLatitude, forKey: "DropLatitude")
		}
		if dropLongitude != nil{
			aCoder.encode(dropLongitude, forKey: "DropLongitude")
		}
		if dropupAddress != nil{
			aCoder.encode(dropupAddress, forKey: "DropupAddress")
		}
		if eTA != nil{
			aCoder.encode(eTA, forKey: "ETA")
		}
		if hasDriverDocAdded != nil{
			aCoder.encode(hasDriverDocAdded, forKey: "HasDriverDocAdded")
		}
		if hasDriverRating != nil{
			aCoder.encode(hasDriverRating, forKey: "HasDriverRating")
		}
		if hasVehicleAdded != nil{
			aCoder.encode(hasVehicleAdded, forKey: "HasVehicleAdded")
		}
		if isDriverActive != nil{
			aCoder.encode(isDriverActive, forKey: "IsDriverActive")
		}
		if isOnTrip != nil{
			aCoder.encode(isOnTrip, forKey: "IsOnTrip")
		}
		if isOnline != nil{
			aCoder.encode(isOnline, forKey: "IsOnline")
		}
		if isTripStart != nil{
			aCoder.encode(isTripStart, forKey: "IsTripStart")
		}
		if isdriverReached != nil{
			aCoder.encode(isdriverReached, forKey: "IsdriverReached")
		}
		if passengerCount != nil{
			aCoder.encode(passengerCount, forKey: "PassengerCount")
		}
		if paymentMode != nil{
			aCoder.encode(paymentMode, forKey: "PaymentMode")
		}
		if pickupAddress != nil{
			aCoder.encode(pickupAddress, forKey: "PickupAddress")
		}
		if pickupLatitude != nil{
			aCoder.encode(pickupLatitude, forKey: "PickupLatitude")
		}
		if pickupLongitude != nil{
			aCoder.encode(pickupLongitude, forKey: "PickupLongitude")
		}
		if tripAmount != nil{
			aCoder.encode(tripAmount, forKey: "TripAmount")
		}
        if BillAmount != nil{
            aCoder.encode(tripAmount, forKey: "BillAmount")
        }
		if tripRequestId != nil{
			aCoder.encode(tripRequestId, forKey: "TripRequestId")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "DeviceToken")
        }
        if hasRideOpen != nil{
            aCoder.encode(hasRideOpen, forKey: "HasRideOpen")
        }

	}

}
