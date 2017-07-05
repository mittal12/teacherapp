//
//  DKAssetGroup.swift
//  DKImagePickerControllerDemo


import Photos

// Group Model
open class DKAssetGroup : NSObject {
	open var groupId: String!
	open var groupName: String!
	open var totalCount: Int!
	
	open var originalCollection: PHAssetCollection!
	open var fetchResult: PHFetchResult<AnyObject>!
}
