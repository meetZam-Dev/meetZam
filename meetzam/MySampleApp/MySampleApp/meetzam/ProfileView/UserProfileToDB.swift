//
//  UserProfileToDB.swift
//  MySampleApp
//
//  Created by Rainy on 2017/2/26.
//  update:bug fixed related to movie count in saving edited profile
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//
import Foundation
import UIKit
import AWSDynamoDB
import AWSS3
class UserProfileToDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var userId: String?
    var displayName: String?
    var bio: String?
    var age: String?
    var gender: String?
    var region: String?
    var email: String?
    var currentLikedMovie = Set<String>()
    var movieCount: NSNumber?
    var likedUsers = Set<String>()
    var matchedUsers = Set<String>()
    
    class func dynamoDBTableName() -> String {
        
        return "meetzam-mobilehub-1569925313-UserProfile"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "userId"
    }
    
    // function to add/update user info into database
    // argument: dbName...
    func insertProfile(_userId: String, _displayName: String, _bio: String, _age: String, _gender: String, _region: String, _email: String) {
        print("     insertProfile")
        let mapper = AWSDynamoDBObjectMapper.default()
        let userProfile = UserProfileToDB()
        
        // update only if the user is in table
        if (UserProfileToDB().isInTable(userID: _userId) == true)
        {
            mapper.load(UserProfileToDB.self, hashKey: _userId, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
                if let error = task.error as? NSError {
                    print("InsertError: \(error)")
                } else if let user_profile_addTo = task.result as? UserProfileToDB {
                    userProfile?.currentLikedMovie=user_profile_addTo.currentLikedMovie
                    // if the user does not have any liked movies
                    if (user_profile_addTo.currentLikedMovie.count == 0)
                    {
                        userProfile?.currentLikedMovie.insert("mushroom13")
                    }
                    userProfile?.likedUsers = user_profile_addTo.likedUsers
                    if (user_profile_addTo.likedUsers.count == 0)
                    {
                        userProfile?.likedUsers.insert("mushroom13")
                    }
                    userProfile?.matchedUsers = user_profile_addTo.matchedUsers
                    if (user_profile_addTo.matchedUsers.count == 0)
                    {
                        userProfile?.matchedUsers.insert("mushroom13")
                    }
                    userProfile?.movieCount = user_profile_addTo.movieCount
                    userProfile?.userId=user_profile_addTo.userId
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return nil
            })
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            while(userProfile?.userId==nil)
            {
                print("insertProfile waiting")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        userProfile?.userId  = _userId
        userProfile?.displayName = _displayName
        userProfile?.bio = _bio
        userProfile?.age = _age
        userProfile?.gender = _gender
        userProfile?.region = _region
        userProfile?.email = _email
        mapper.save(userProfile!)
    }
    
    func isInTable(userID: String) -> Bool
    {
        var result: Bool = false
        var userIDInTable: Array = [String]()
        let mapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        var dummynum: Int = 0
        
        mapper.scan(UserProfileToDB.self, expression: scanExpression).continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let allUsers = task.result {
                for user in allUsers.items as! [UserProfileToDB] {
                    userIDInTable.append(user.userId!)
                }
                dummynum = 6
            }
            return nil
        })
        while (dummynum != 6)
        {
            print("isInTable waiting")
        }
        if (userIDInTable.contains(userID))
        {
            result = true
        }
        return result
    }
    
    func getProfileForEdit(key: String, user_profile: UserProfileToDB?, displayname: UITextField!, bio: UITextField!, age: UITextField!, gender: UITextField!, region: UITextField!, email: UITextField!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let mapper = AWSDynamoDBObjectMapper.default()
        
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                displayname.text = user_profile.displayName
                //print(displayname.text)
                bio.text = user_profile.bio
                //print(bio.text)
                age.text = user_profile.age
                //print(age.text)
                gender.text = user_profile.gender
                //print(gender.text)
                region.text = user_profile.region
                //print(region.text)
                email.text = user_profile.email
                //print(email.text)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
    }
    
    func getProfileForDisplay(key: String, user_profile: UserProfileToDB?, displayname: UILabel!, bio: UILabel!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let mapper = AWSDynamoDBObjectMapper.default()
        
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                //print("     Getting fields in user_profile")
                displayname.text = user_profile.displayName
                //print(displayname.text)
                bio.text = user_profile.bio
                //print(bio.text)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
    }
    
    func insertToCurrentLikedMovie(key: String, movieTitle: String)
    {
        print("     insertToCurrentLikedMovie!!")
        let mapper = AWSDynamoDBObjectMapper.default()
        
        let userProfile = UserProfileToDB()
        
        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.userId=key
                print("     key is \(key)")
                userProfile?.displayName = user_profile_addTo.displayName
                print("displayname is \(userProfile?.displayName)")
                userProfile?.bio = user_profile_addTo.bio
                print("bio is \(userProfile?.bio)")
                userProfile?.age = user_profile_addTo.age
                print("age is \(userProfile?.age)")
                userProfile?.gender = user_profile_addTo.gender
                print("gender is \(userProfile?.gender)")
                userProfile?.region = user_profile_addTo.region
                print("region is \(userProfile?.region)")
                userProfile?.currentLikedMovie = user_profile_addTo.currentLikedMovie
                if (user_profile_addTo.currentLikedMovie.count == 0)
                {
                    userProfile?.currentLikedMovie.insert("mushroom13")
                }
                userProfile?.likedUsers = user_profile_addTo.likedUsers
                if (user_profile_addTo.likedUsers.count == 0)
                {
                    userProfile?.likedUsers.insert("mushroom13")
                }
                userProfile?.matchedUsers = user_profile_addTo.matchedUsers
                if (user_profile_addTo.matchedUsers.count == 0)
                {
                    userProfile?.matchedUsers.insert("mushroom13")
                }
                for movie in (userProfile?.currentLikedMovie)! {
                    print("\(movie)")
                }
                userProfile?.movieCount = user_profile_addTo.movieCount
                
                userProfile?.email = user_profile_addTo.email
                print("email is \(userProfile?.email)")
                print("     all put")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        while(userProfile?.email==nil)
        {
            print("waiting")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        print("SHOULD BE AFTER LOAD: displayname is \(userProfile?.displayName)")
        if (!((userProfile?.currentLikedMovie.contains(movieTitle))!))
        {
            if (userProfile?.currentLikedMovie.count != 0 && userProfile?.movieCount == 0) {
                //dummy exist
                userProfile?.currentLikedMovie.removeAll()
            }
            userProfile?.currentLikedMovie.insert(movieTitle)
            userProfile?.movieCount = userProfile?.currentLikedMovie.count as NSNumber?
        }
        for movie in (userProfile?.currentLikedMovie)! {
            print("\(movie)")
        }
        mapper.save(userProfile!)
    }
    
    func deleteFromCurrentLikedMovie(key: String, movieTitle: String)
    {
        print("     deleteFromCurrentLikedMovie!!")
        
        let mapper = AWSDynamoDBObjectMapper.default()
        
        let userProfile = UserProfileToDB()
        
        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.userId=key
                print("     key is \(key)")
                userProfile?.displayName = user_profile_addTo.displayName
                print("displayname is \(userProfile?.displayName)")
                userProfile?.bio = user_profile_addTo.bio
                print("bio is \(userProfile?.bio)")
                userProfile?.age = user_profile_addTo.age
                print("age is \(userProfile?.age)")
                userProfile?.gender = user_profile_addTo.gender
                print("gender is \(userProfile?.gender)")
                userProfile?.region = user_profile_addTo.region
                print("region is \(userProfile?.region)")
                userProfile?.likedUsers = user_profile_addTo.likedUsers
                if (user_profile_addTo.likedUsers.count == 0)
                {
                    userProfile?.likedUsers.insert("mushroom13")
                }
                userProfile?.matchedUsers = user_profile_addTo.matchedUsers
                if (user_profile_addTo.matchedUsers.count == 0)
                {
                    userProfile?.matchedUsers.insert("mushroom13")
                }
                userProfile?.currentLikedMovie=user_profile_addTo.currentLikedMovie
                print("BEFORE DELETION, currentLikedMovie are: \(userProfile?.currentLikedMovie.description)")
                userProfile?.movieCount = user_profile_addTo.movieCount
                userProfile?.email = user_profile_addTo.email
                print("email is \(userProfile?.email)")
                print("     all put")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        while(userProfile?.email==nil)
        {
            print("waiting")
        }
        print("SHOULD BE AFTER LOAD: displayname is \(userProfile?.displayName)")
        if (!((userProfile?.currentLikedMovie.contains(movieTitle))!))
        {
            print("error: delete a movie not in user's liked movie list")
        }
        else {
            print("removing movie")
            _ = userProfile?.currentLikedMovie.remove(movieTitle)
            userProfile?.movieCount = userProfile?.currentLikedMovie.count as NSNumber?
            //dummy string since empty string set not allowed
            if (userProfile?.currentLikedMovie.count == 0) {
                userProfile?.currentLikedMovie.insert("mushroom13")
            }
        }
        
        print("AFTER DELETION, currentLikedMovie are: \(userProfile?.currentLikedMovie.description)")
        mapper.save(userProfile!)
    }
    
    
    func getLikedMovies(userId: String, user_profile: UserProfileToDB) {
        let mapper = AWSDynamoDBObjectMapper.default()
        mapper.load(UserProfileToDB.self, hashKey: userId, rangeKey: nil).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile_temp = task.result as? UserProfileToDB {
                print("get: HERE ARE THE LIKED MOVIES")
                if (user_profile_temp.currentLikedMovie.count != 0 && user_profile_temp.movieCount == 0) {
                    print("dummy detected")
                }
                else {
                    user_profile.currentLikedMovie = user_profile_temp.currentLikedMovie
                    print(user_profile.currentLikedMovie.description)
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
    }
    
    func getMatchedUserIDs(key: String) -> [String]
    {
        print("     getMatchedUserIDs")
        let mapper = AWSDynamoDBObjectMapper.default()
        var currentLikedMovie = Set<String>()
        let userProfile = UserProfileToDB()
        
        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                if (user_profile_addTo.currentLikedMovie.count != 0 && user_profile_addTo.movieCount == 0) {
                    print("dummy detected")
                }
                else {
                    currentLikedMovie=user_profile_addTo.currentLikedMovie
                }
                userProfile?.displayName=user_profile_addTo.displayName
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        while (userProfile?.displayName == nil)
        {
            print("waiting")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("     next step")
        var matchedUserIDs: Array = [String]()
        var dummynum: Int = 0
        for movie in (currentLikedMovie) {
            dummynum = 0
            print("You Liked \(movie)")
            mapper.load(SingleMovie.self, hashKey: movie, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
                if let error = task.error as? NSError {
                    print("InsertError: \(error)")
                } else if let single_movie = task.result as? SingleMovie {
                    // put all the matched user ids to matchedUserIDs array
                    for likedUsers in single_movie.currentLikedUser
                    {
                        // if the id is not the user him/herself, add it to list
                        if (likedUsers != key && !matchedUserIDs.contains(likedUsers))
                        {
                            matchedUserIDs.append(likedUsers)
                        }
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                dummynum = 6
                return nil
            })
            while (dummynum != 6)
            {
                print("waiting")
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        return matchedUserIDs
    }
    
    func getMatchedUserProfiles(userIDs: [String]) -> [UserProfileToDB]
    {
        print("     getMatchedUserProfiles")
        var matchedUserProfiles: Array = [UserProfileToDB]()
        let mapper = AWSDynamoDBObjectMapper.default()
        var dummynum: Int = 0
        for userID in userIDs
        {
            dummynum = 0
            print("userid is \(userID)")
            mapper.load(UserProfileToDB.self, hashKey: userID, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
                if let error = task.error as? NSError {
                    print("InsertError: \(error)")
                } else if let userProfile = task.result as? UserProfileToDB {
                    dummynum = 0
                    matchedUserProfiles.append(userProfile)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                dummynum = 6
                return nil
            })
            while (dummynum != 6)
            {
                print("waiting")
            }
        }
        return matchedUserProfiles
    }
    
    
    func likeOneUser(key: String, likedUserID: String)
    {
        print("     likeOneUser")
        let mapper = AWSDynamoDBObjectMapper.default()
        let userProfile = UserProfileToDB()
        
        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.userId=key
                print("     key is \(key)")
                userProfile?.displayName = user_profile_addTo.displayName
                print("displayname is \(userProfile?.displayName)")
                userProfile?.bio = user_profile_addTo.bio
                print("bio is \(userProfile?.bio)")
                userProfile?.age = user_profile_addTo.age
                print("age is \(userProfile?.age)")
                userProfile?.gender = user_profile_addTo.gender
                print("gender is \(userProfile?.gender)")
                userProfile?.region = user_profile_addTo.region
                print("region is \(userProfile?.region)")
                userProfile?.currentLikedMovie=user_profile_addTo.currentLikedMovie
                // if the user does not have any liked movies
                if (user_profile_addTo.currentLikedMovie.count == 0)
                {
                    userProfile?.currentLikedMovie.insert("mushroom13")
                }
                userProfile?.likedUsers = user_profile_addTo.likedUsers
                if (user_profile_addTo.likedUsers.count == 0)
                {
                    userProfile?.likedUsers.insert("mushroom13")
                }
                userProfile?.matchedUsers = user_profile_addTo.matchedUsers
                if (user_profile_addTo.matchedUsers.count == 0)
                {
                    userProfile?.matchedUsers.insert("mushroom13")
                }
                userProfile?.movieCount = user_profile_addTo.movieCount
                
                userProfile?.email = user_profile_addTo.email
                print("email is \(userProfile?.email)")
                print("     all put")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        while(userProfile?.email==nil)
        {
            print("likeOneUser waiting")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        print("SHOULD BE AFTER LOAD: displayname is \(userProfile?.displayName)")
        if (!((userProfile?.likedUsers.contains(likedUserID))!))
        {
            if (userProfile?.likedUsers.count == 1 && (userProfile?.likedUsers.contains("mushroom13"))!) {
                //dummy exist
                userProfile?.likedUsers.removeAll()
            }
            userProfile?.likedUsers.insert(likedUserID)
        }
        mapper.save(userProfile!)
    }
    
    func getLikedUserIDs(key: String) -> [String]
    {
        print("     getLikedUserIDs")
        let mapper = AWSDynamoDBObjectMapper.default()
        var likedUserArr = Set<String>()
        var likedUserIDs: Array = [String]()
        var dummynum: Int = 0
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task: AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                likedUserArr = user_profile.likedUsers
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            dummynum = 6
            return nil
        })
        while (dummynum == 0)
        {
            print("waiting")
        }
        for user in likedUserArr
        {
            likedUserIDs.append(user)
        }
        return likedUserIDs
    }
    
    // Call this twice!
    // 1st: (your id, other's id)
    // 2nd: (other's id, your id)
    // if both true, then there is a match
    func findIsMatched(key: String, userID: String) -> Bool
    {
        print("     findIsMatched")
        let mapper = AWSDynamoDBObjectMapper.default()
        var result: Bool = false
        var dummynum: Int = 0
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task: AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                if (user_profile.likedUsers.contains(userID))
                {
                    result = true
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            dummynum = 6
            return nil
        })
        while (dummynum == 0)
        {
            print("findIsMatched waiting")
        }
        return result
    }
    
    func insertToMatchedUser(key: String, userID: String)
    {
        print("     insertToMatchedUser")
        let mapper = AWSDynamoDBObjectMapper.default()
        let userProfile = UserProfileToDB()
        
        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.userId=key
                print("     key is \(key)")
                userProfile?.displayName = user_profile_addTo.displayName
                print("displayname is \(userProfile?.displayName)")
                userProfile?.bio = user_profile_addTo.bio
                print("bio is \(userProfile?.bio)")
                userProfile?.age = user_profile_addTo.age
                print("age is \(userProfile?.age)")
                userProfile?.gender = user_profile_addTo.gender
                print("gender is \(userProfile?.gender)")
                userProfile?.region = user_profile_addTo.region
                print("region is \(userProfile?.region)")
                userProfile?.currentLikedMovie = user_profile_addTo.currentLikedMovie
                if (user_profile_addTo.currentLikedMovie.count == 0)
                {
                    userProfile?.currentLikedMovie.insert("mushroom13")
                }
                userProfile?.likedUsers = user_profile_addTo.likedUsers
                if (user_profile_addTo.likedUsers.count == 0)
                {
                    userProfile?.likedUsers.insert("mushroom13")
                }
                userProfile?.matchedUsers = user_profile_addTo.matchedUsers
                if (user_profile_addTo.matchedUsers.count == 0)
                {
                    userProfile?.matchedUsers.insert("mushroom13")
                }
                for movie in (userProfile?.currentLikedMovie)! {
                    print("\(movie)")
                }
                userProfile?.movieCount = user_profile_addTo.movieCount
                userProfile?.email = user_profile_addTo.email
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        while(userProfile?.email==nil)
        {
            print("insertToMatchedUser waiting")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        print("SHOULD BE AFTER LOAD: displayname is \(userProfile?.displayName)")
        if (!((userProfile?.matchedUsers.contains(userID))!))
        {
            if (userProfile?.matchedUsers.count != 0 && (userProfile?.matchedUsers.contains("mushroom13"))!) {
                //dummy exist
                print("dummy here")
                userProfile?.matchedUsers.removeAll()
            }
            userProfile?.matchedUsers.insert(userID)
        }
        mapper.save(userProfile!)
    }
    
    func downloadUserIcon(userID: String) -> URL
    {
        let transferManager = AWSS3TransferManager.default()
        
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(userID)
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = "testprofile-meetzam"
        downloadRequest?.key = userID + ".jpeg"
        downloadRequest?.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error downloading: \(downloadRequest?.key) Error: \(error)")
                    }
                } else {
                    print("Error downloading")
                }
                return nil
            }
            print("Download complete for: \(downloadRequest?.key)")
            return nil
        })
        return downloadingFileURL
    }
    
}
