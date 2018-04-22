import UIKit
import AVFoundation
import RxSwift
import SwiftyJSON

class CameraViewController: ViewController {
    private let qrCodeFrameView = UIView()
    private let cameraSquare = SquareCameraView()
    
    private var flag: Bool = false
    
    private let captureSession = AVCaptureSession()
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: captureSession)
    }()
    
    init() {
        super.init(isNavBarHidden: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setViews()
        view.layoutIfNeeded()
        configureAVSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    private func setViews() {
        view.addSubview(qrCodeFrameView)
        view.addSubview(cameraSquare)
        
        qrCodeFrameView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraSquare.backgroundColor = UIColor.clear
        cameraSquare.snp.makeConstraints {
            $0.left.right.equalTo(qrCodeFrameView).inset(44)
            $0.top.equalToSuperview().inset(100)
            $0.height.equalTo(cameraSquare.snp.width)
        }
    }
    
    private func configureAVSession() {
        guard let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            print(error)
            return
        }
        
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = qrCodeFrameView.layer.bounds
        qrCodeFrameView.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !flag else { return }
        guard metadataObjects.count > 0 else {
            qrCodeFrameView.frame = .zero
            return
        }
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            metadataObj.type == AVMetadataObject.ObjectType.qr else {
                return
        }
        
        let json =  JSON.init(parseJSON: metadataObj.stringValue!)
        if let id = json["id"].int, let orderSum = json["sum"].double {
            flag = true
            let view = TipViewController(id: id, orderSum: orderSum)
            navigationController?.pushViewController(view, animated: true)
        }
    }
}
