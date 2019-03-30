//
//	MyTrip.swift
//
//	Create by admin on 7/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MyTrip : NSObject, NSCoding{

	var amount : String!
	var bookingTime : String!
	var companyName : String!
	var customerName : String!
	var dropAddress : String!
	var id : Int!
	var miles : Double!
	var minutes : Int!
	var paymentMode : Int!
	var phoneNumber : String!
	var pickupAddress : String!
	var tripMap : String!
	var tripRequestId : Int!
	var tripStartOn : String!
	var vehicleCategory : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		amount = dictionary["Amount"] as? String
		bookingTime = dictionary["BookingTime"] as? String
		companyName = dictionary["CompanyName"] as? String
		customerName = dictionary["CustomerName"] as? String
		dropAddress = dictionary["DropAddress"] as? String
		id = dictionary["Id"] as? Int
		miles = dictionary["Miles"] as? Double
		minutes = dictionary["Minutes"] as? Int
		paymentMode = dictionary["PaymentMode"] as? Int
		phoneNumber = dictionary["PhoneNumber"] as? String
		pickupAddress = dictionary["PickupAddress"] as? String
		tripMap = dictionary["TripMap"] as? String
		tripRequestId = dictionary["TripRequestId"] as? Int
		tripStartOn = dictionary["TripStartOn"] as? String
		vehicleCategory = dictionary["VehicleCategory"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if amount != nil{
			dictionary["Amount"] = amount
		}
		if bookingTime != nil{
			dictionary["BookingTime"] = bookingTime
		}
		if companyName != nil{
			dictionary["CompanyName"] = companyName
		}
		if customerName != nil{
			dictionary["CustomerName"] = customerName
		}
		if dropAddress != nil{
			dictionary["DropAddress"] = dropAddress
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if miles != nil{
			dictionary["Miles"] = miles
		}
		if minutes != nil{
			dictionary["Minutes"] = minutes
		}
		if paymentMode != nil{
			dictionary["PaymentMode"] = paymentMode
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		if pickupAddress != nil{
			dictionary["PickupAddress"] = pickupAddress
		}
		if tripMap != nil{
			dictionary["TripMap"] = tripMap
		}
		if tripRequestId != nil{
			dictionary["TripRequestId"] = tripRequestId
		}
		if tripStartOn != nil{
			dictionary["TripStartOn"] = tripStartOn
		}
		if vehicleCategory != nil{
			dictionary["VehicleCategory"] = vehicleCategory
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         amount = aDecoder.decodeObject(forKey: "Amount") as? String
         bookingTime = aDecoder.decodeObject(forKey: "BookingTime") as? String
         companyName = aDecoder.decodeObject(forKey: "CompanyName") as? String
         customerName = aDecoder.decodeObject(forKey: "CustomerName") as? String
         dropAddress = aDecoder.decodeObject(forKey: "DropAddress") as? String
         id = aDecoder.decodeObject(forKey: "Id") as? Int
         miles = aDecoder.decodeObject(forKey: "Miles") as? Double
         minutes = aDecoder.decodeObject(forKey: "Minutes") as? Int
         paymentMode = aDecoder.decodeObject(forKey: "PaymentMode") as? Int
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String
         pickupAddress = aDecoder.decodeObject(forKey: "PickupAddress") as? String
         tripMap = aDecoder.decodeObject(forKey: "TripMap") as? String
         tripRequestId = aDecoder.decodeObject(forKey: "TripRequestId") as? Int
         tripStartOn = aDecoder.decodeObject(forKey: "TripStartOn") as? String
         vehicleCategory = aDecoder.decodeObject(forKey: "VehicleCategory") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    
    @objc func encode(with aCoder: NSCoder)
	{
		if amount != nil{
			aCoder.encode(amount, forKey: "Amount")
		}
		if bookingTime != nil{
			aCoder.encode(bookingTime, forKey: "BookingTime")
		}
		if companyName != nil{
			aCoder.encode(companyName, forKey: "CompanyName")
		}
		if customerName != nil{
			aCoder.encode(customerName, forKey: "CustomerName")
		}
		if dropAddress != nil{
			aCoder.encode(dropAddress, forKey: "DropAddress")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if miles != nil{
			aCoder.encode(miles, forKey: "Miles")
		}
		if minutes != nil{
			aCoder.encode(minutes, forKey: "Minutes")
		}
		if paymentMode != nil{
			aCoder.encode(paymentMode, forKey: "PaymentMode")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}
		if pickupAddress != nil{
			aCoder.encode(pickupAddress, forKey: "PickupAddress")
		}
		if tripMap != nil{
			aCoder.encode(tripMap, forKey: "TripMap")
		}
		if tripRequestId != nil{
			aCoder.encode(tripRequestId, forKey: "TripRequestId")
		}
		if tripStartOn != nil{
			aCoder.encode(tripStartOn, forKey: "TripStartOn")
		}
		if vehicleCategory != nil{
			aCoder.encode(vehicleCategory, forKey: "VehicleCategory")
		}

	}

}
