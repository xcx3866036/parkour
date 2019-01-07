// MediaPickerController.swift
// MediaPickerController
//
// Copyright (c) 2016 Inaka - http://inaka.net/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import AVFoundation
import MobileCoreServices

public enum MediaPickerControllerType {
	case imageOnly
	case imageAndVideo
}

@objc public protocol MediaPickerControllerDelegate {
	@objc optional func mediaPickerControllerDidPickImage(_ image: UIImage)
	@objc optional func mediaPickerControllerDidPickVideo(url: URL, data: Data, thumbnail: UIImage)
}

open class MediaPickerController: NSObject {
	
	// MARK: - Public
	
	open weak var delegate: MediaPickerControllerDelegate?
	
	public init(type: MediaPickerControllerType, presentingViewController controller: UIViewController) {
		self.type = type
		self.presentingController = controller
		self.mediaPicker = UIImagePickerController()
		super.init()
		self.mediaPicker.delegate = self
	}
	
	open func show() {
		let actionSheet = self.optionsActionSheet
		self.presentingController.present(actionSheet, animated: true, completion: nil)
	}
	
	// MARK: - Private
	
	fileprivate let presentingController: UIViewController
	fileprivate let type: MediaPickerControllerType
	fileprivate let mediaPicker: UIImagePickerController
	
}

extension MediaPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: - UIImagePickerControllerDelegate
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		self.dismiss()
		let mediaType = info[UIImagePickerControllerMediaType] as! NSString
		
		if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
			// Is Image
			let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
			self.delegate?.mediaPickerControllerDidPickImage?(chosenImage)
		} else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
			// Is Video
			let url: URL = info[UIImagePickerControllerMediaURL] as! URL
			let chosenVideo = info[UIImagePickerControllerMediaURL] as! URL
			let videoData = try! Data(contentsOf: chosenVideo, options: [])
			let thumbnail = url.generateThumbnail()
            self.delegate?.mediaPickerControllerDidPickVideo?(url: url, data: videoData, thumbnail: thumbnail)
		}
		
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss()
	}
	
	// MARK: - UINavigationControllerDelegate
	
	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
}

// MARK: - Private

private extension MediaPickerController {
	
	var optionsActionSheet: UIAlertController {
		let actionSheet = UIAlertController(title: Strings.Title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		self.addChooseExistingMediaActionToSheet(actionSheet)
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			self.addTakePhotoActionToSheet(actionSheet)
			if self.type == .imageAndVideo {
				self.addTakeVideoActionToSheet(actionSheet)
			}
		}
		self.addCancelActionToSheet(actionSheet)
		return actionSheet
	}
	
	func addChooseExistingMediaActionToSheet(_ actionSheet: UIAlertController) {
		let chooseExistingAction = UIAlertAction(title: self.chooseExistingText, style: UIAlertActionStyle.default) { (_) -> Void in
			self.mediaPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
			self.mediaPicker.mediaTypes = self.chooseExistingMediaTypes
			self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
		}
		actionSheet.addAction(chooseExistingAction)
	}
	
	func addTakePhotoActionToSheet(_ actionSheet: UIAlertController) {
		let takePhotoAction = UIAlertAction(title: Strings.TakePhoto, style: UIAlertActionStyle.default) { (_) -> Void in
			self.mediaPicker.sourceType = UIImagePickerControllerSourceType.camera
			self.mediaPicker.mediaTypes = [kUTTypeImage as String]
			self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
		}
		actionSheet.addAction(takePhotoAction)
	}
	
	func addTakeVideoActionToSheet(_ actionSheet: UIAlertController) {
		let takeVideoAction = UIAlertAction(title: Strings.TakeVideo, style: UIAlertActionStyle.default) { (_) -> Void in
			self.mediaPicker.sourceType = UIImagePickerControllerSourceType.camera
			self.mediaPicker.mediaTypes = [kUTTypeMovie as String]
			self.presentingController.present(self.mediaPicker, animated: true, completion: nil)
		}
		actionSheet.addAction(takeVideoAction)
	}
	
	func addCancelActionToSheet(_ actionSheet: UIAlertController) {
		let cancel = Strings.Cancel
		let cancelAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: nil)
		actionSheet.addAction(cancelAction)
	}
	
	func dismiss() {
		DispatchQueue.main.async {
			self.presentingController.dismiss(animated: true, completion: nil)
		}
	}
	
	var chooseExistingText: String {
		switch self.type {
		case .imageOnly: return Strings.ChoosePhoto
		case .imageAndVideo: return Strings.ChoosePhotoOrVideo
		}
	}
	
	var chooseExistingMediaTypes: [String] {
		switch self.type {
		case .imageOnly: return [kUTTypeImage as String]
		case .imageAndVideo: return [kUTTypeImage as String, kUTTypeMovie as String]
		}
	}
	
	// MARK: - Constants
	
	struct Strings {
		static let Title = NSLocalizedString("Attach", comment: "Title for a generic action sheet for picking media from the device.")
		static let ChoosePhoto = NSLocalizedString("Choose existing photo", comment: "Text for an option that lets the user choose an existing photo in a generic action sheet for picking media from the device.")
		static let ChoosePhotoOrVideo = NSLocalizedString("Choose existing photo or video", comment: "Text for an option that lets the user choose an existing photo or video in a generic action sheet for picking media from the device.")
		static let TakePhoto = NSLocalizedString("Take a photo", comment: "Text for an option that lets the user take a picture with the device camera in a generic action sheet for picking media from the device.")
		static let TakeVideo = NSLocalizedString("Take a video", comment: "Text for an option that lets the user take a video with the device camera in a generic action sheet for picking media from the device.")
		static let Cancel = NSLocalizedString("Cancel", comment: "Text for the 'cancel' action in a generic action sheet for picking media from the device.")
	}
	
}

private extension URL {
	
	func generateThumbnail() -> UIImage {
		let asset = AVAsset(url: self)
		let generator = AVAssetImageGenerator(asset: asset)
		generator.appliesPreferredTrackTransform = true
		var time = asset.duration
		time.value = 0
		let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
		let thumbnail = UIImage(cgImage: imageRef!)
		return thumbnail
	}
	
}
