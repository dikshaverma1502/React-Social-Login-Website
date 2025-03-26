//
//  GuidanceScreenViewModel.swift
//  Pehchan
//
//  Created by iosUser on 24/03/25.
//

import Foundation
import FaceDetectionFramework
import UIKit
import TensorFlowLite
protocol GuidanceScreenViewModelProtocol {
    func handleProceedButtonTapped()
}

final class GuidanceScreenViewModel: UIViewController, GuidanceScreenViewModelProtocol {
    
    
    private var shouldStartLiveFeed = false


    private let router: GuidanceScreenRouterProtocol
    var consentItems: [ShareConsentItem] = [
        ShareConsentItem(title: "Your photo", description: "your digital photo saved on aadhar", icon: UIImage(systemName: "photo.fill")),
        ShareConsentItem(title: "Full name", description: "Chidurala Anoop Kumar", icon: UIImage(systemName: "person.fill")),
        ShareConsentItem(title: "Face authentication", description: "Verify your facial profile", icon: UIImage(systemName: "faceid")),
        ShareConsentItem(title: "Address", description: "No.30 & 28/2, Whitefield Main Road Hoodi Village, near Phoenix Market City, Krishnarajapuram, Bengaluru", icon: UIImage(systemName: "house.fill"))
    ]
    private var getLandMarkValuesFromFramework: FaceDetectionFramework.LandMark?
    private let registration = Registration()
    init(router: GuidanceScreenRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func handleProceedButtonTapped() {
        print("Proceed button tapped")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print("Current View Controller: \(self)")
            print("View's window: \(self.view.window ?? nil)")

            if self.isViewLoaded, self.view.window != nil {
                print("View is in hierarchy, starting live feed...")
                self.startLiveFeed()
            } else {
                print("View is not yet visible, setting flag to start in viewDidAppear")
                self.shouldStartLiveFeed = true
            }
        }
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad triggered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Forcing ViewController to be visible")
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear triggered")
        if shouldStartLiveFeed {
            print("View is now visible, starting live feed...")
            shouldStartLiveFeed = false
            startLiveFeed()
        }
    }
    
    
    func startLiveFeed() {
        DispatchQueue.main.async { [weak self] in

            guard let self = self else {
                print("startLiveFeed: self is nil!")
                return
            }
            print("router:\(router)")
            print("startLiveFeed is running")
            
            let vc = LiveFeedViewController()
            vc.transactionIDReceived = "model_training"
            vc.languageCodeFromAUA = "en"
            vc.reciveEnvironmetValue = "S"
            vc.auaCode = "000"
            vc.auaName = "UIDAI"
            vc.mandatoryCameraFlag = "N"
            vc.cameraFlagFromAua = "F"
            vc.liveFeedDelegate = self
            vc.modalPresentationStyle = .fullScreen
            if self.presentedViewController == nil {
                        print("Presenting LiveFeedViewController...")
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        print("LiveFeedViewController is already presented, skipping...")
                    }
        }
    }
    
    func viewLoaded() {
        APIService.shared.getAuthHistory { result in
            // Handle authentication history if needed
        }
    }
    
    private func startFaceAuth() {
        //        loadingSubject.send(true)
        APIService.shared.faceAuth { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.callCallbackUrlRequest(completion: { result in
//                    switch result {
//                    case .success(let value):
//                        print("Callback URL Response: \(value)")
//                    case .failure(let error):
//                        print("Callback URL Error: \(error)")
//                    }
//                })
//            case .failure(_):
//                () // show error
//            }
        }
    }
}


// MARK: - LiveFeedControllerDelegate Implementation
extension GuidanceScreenViewModel: LiveFeedControllerDelegate {
    
    func getEmbedDedValue(bool: Bool, passImage: UIImage) {
        
        DispatchQueue.global(qos: .userInitiated).async {
        let transformedImage = passImage.rotate(byDegrees: -90)?.flipHorizontally()
            let embeddingModel = EmbeddingModel()
            embeddingModel.nextdidCaptureImage(image: transformedImage, passLandMarks: self.getLandMarkValuesFromFramework) {
                
            embeddingArray in
                  if let embeddingArray = embeddingArray {
                      let startTime = Date()
                      self.registration.callCreatePidDataAPI(embeddingArray: embeddingArray, startTime: startTime)
//                      self.startFaceAuth()
                } else {
                    print("Failed to obtain embedding array")
                }
            }
        }
    }
//    private func startFaceAuth() {
//        //        loadingSubject.send(true)
//        APIService.shared.faceAuth { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.callCallbackUrlRequest(completion: { result in
//                    switch result {
//                    case .success(let value):
//                        print("Callback URL Response: \(value)")
//                    case .failure(let error):
//                        print("Callback URL Error: \(error)")
//                    }
//                })
//            case .failure(_):
//                () // show error
//            }
//        }
//    }



    
    func getLandmarks(landMark: FaceDetectionFramework.LandMark?) {
        self.getLandMarkValuesFromFramework  = landMark
    }
    
    func getValidatedImageResult(livenessResult: String?) {
        if let result = livenessResult {
//            livenessResultMessage = (result == "Liveness Failed") ? "Liveness Failed" : "Liveness Passed"
            
            // MARK: Handle liveness failure
            if result == "Liveness Failed" {
                showPopup(title: "Hello!", message: "This is a pop-up", in: self)
            }
//            checkAndShowToast()
        }
    }
    func showPopup(title: String, message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func getLivenessScore(livenessScore: Float?) {}
    
    
    func didCaptureImage(image: UIImage?, navigationController: UINavigationController?) {}
    func getTimeoutStatus(timeout: Bool?) {}
    func getFocusDistance(focusDistance: Float?) {}
    func totalDuration(totalDuration: Double?) {}
    func livenessDuration(livenessDuration: Double?) {}
    func versionDetails(visionVer: String?, livenessModelName: String?) {}
    func getBlinkCount(blinkCount: Int?) {}
    func cameraDetails(cameraused: String?, cameraResolution: String?) {}
}



