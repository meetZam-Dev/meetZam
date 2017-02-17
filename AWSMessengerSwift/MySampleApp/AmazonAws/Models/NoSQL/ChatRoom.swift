//
//  ChatRoom.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.4
//

import Foundation
import UIKit
import AWSDynamoDB

class ChatRoom: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _chatRoomId: String?
    var _createdAt: String?
    var _name: String?
    var _recipients: Set<String>?
    
    class func dynamoDBTableName() -> String {

        return Bundle.dynamoDBTableName("ChatRoom")
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_chatRoomId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_chatRoomId" : "chatRoomId",
               "_createdAt" : "createdAt",
               "_name" : "name",
               "_recipients" : "recipients",
        ]
    }
}
