//
//  ChoosenGlassViewController.swift
//  VirtualTryOn
//
//  Created by Shubham Gupta on 08/09/19.
//  Copyright © 2019 Shubham Gupta. All rights reserved.
//

import UIKit
import ARKit

private let nodeYPosition: Float = 0.022
private let planeWidth: CGFloat = 0.13
private let planeHeight: CGFloat = 0.06

protocol BottomSheetScrollDelegate {
    func bottomSheetScrollingEnded(state: State)
}

class VirtualTryOnViewController: UIViewController {

    var choosenGlassName: String?
    
    @IBOutlet weak var arSceneView: ARSCNView!
    @IBOutlet weak var pullDownLabel: UILabel!
    public var selectedGlassViewController: SelectedGlassViewController?
    var sheet: PullableSheet!
    private var configuration: ARFaceTrackingConfiguration!
    private let glassPlane = SCNPlane(width: planeWidth, height: planeHeight)
    let glassNode = SCNNode()
    let lowLightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var bottomSheetScrollDelegate: BottomSheetScrollDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        handleBackButtonAndNavigationBar()
        
        sheet = PullableSheet(content: selectedGlassViewController!, topBarStyle: .custom(UIView(frame: .zero)), radius: 13)
        selectedGlassViewController?.delegate = self
        selectedGlassViewController?.virtualTryOnVC = self
        selectedGlassViewController?.choosenGlassName = choosenGlassName!
        selectedGlassViewController?.sheet = sheet
        sheet.snapPoints = [.custom(y: 130), .custom(y: view.bounds.height - 330)] // snap points (if needed)
        sheet.add(to: self)

        if(!checkForFaceTrackingSupport()) {
            pullDownLabel.text = "Virtual Try-On is not supported on this device"
        }
    }
    
    private func checkForFaceTrackingSupport() -> Bool {
        guard ARFaceTrackingConfiguration.isSupported else {
            return false
        }
        arSceneView.delegate = self
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
            if !self.checkForFaceTrackingSupport() {
                return
            }
            self.configuration = ARFaceTrackingConfiguration()
            DispatchQueue.main.async {
                self.arSceneView.session.pause()
            }
            self.arSceneView.autoenablesDefaultLighting   = true
            self.arSceneView.automaticallyUpdatesLighting = true
            self.arSceneView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arSceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func handleBackButtonAndNavigationBar() {
        let backImage = UIImage(named: "left-arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.topItem?.title = ""
    }

}

extension VirtualTryOnViewController: PullableDelegate {
    func pullableViewScrollEnded() {
        bottomSheetScrollDelegate.bottomSheetScrollingEnded(state: sheet.state)
        if sheet.state == .open {
            self.arSceneView.isHidden = true
            self.arSceneView.session.pause()
        } else {
            if !self.checkForFaceTrackingSupport() {
                return
            }
            self.arSceneView.isHidden = false
            self.arSceneView.session.run(self.configuration)
        }
    }
    
    private func updateGlasses(withImage image: String) {
//        self.glassPlane.firstMaterial?.diffuse.contents =
    }
}

extension VirtualTryOnViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = arSceneView.device else {
            return nil
        }
//
//        let device = MTLCreateSystemDefaultDevice()
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        glassPlane.firstMaterial?.isDoubleSided = true
        faceNode.geometry?.firstMaterial?.transparency = 0
        updateGlasses(withImage: choosenGlassName!)
        let glassObjectScene = SCNScene(named:"glass1.scn")
        for child: SCNNode in (glassObjectScene?.rootNode.childNodes)! {
            glassNode.addChildNode(child)
        }
        glassNode.position.z = faceNode.boundingBox.max.z * 3 / 4
        glassNode.position.y = nodeYPosition
        glassNode.geometry = glassPlane
        faceNode.addChildNode(glassNode)
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let lightEstimate = self.arSceneView.session.currentFrame?.lightEstimate else { return }

        let ambientLightEstimate = lightEstimate.ambientIntensity

        let ambientColourTemperature = lightEstimate.ambientColorTemperature


        print(
            """
            Current Light Estimate = \(ambientLightEstimate)
            Current Ambient Light Colour Temperature Estimate = \(ambientColourTemperature)
            """)


        if ambientLightEstimate < 100 { print("Lighting Is Too Dark") }
        
    }
}

extension VirtualTryOnViewController: GlassesBottomSheetDelegate {
    func glassSelected(glassName: String) {
        updateGlasses(withImage: glassName)
    }
    
    func closeBottomSheet() {
        self.dismiss(animated: true, completion: nil)
    }
}

