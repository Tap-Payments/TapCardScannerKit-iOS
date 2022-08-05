//  Created by josh on 2020/07/23.

#if canImport(UIKit)
#if canImport(AVFoundation)
import AVFoundation
import UIKit
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS

/// Conform to this delegate to get notified of key events
@available(iOS 13, *)
@objc public protocol TapCreditCardScannerViewControllerDelegate: AnyObject {
    /// Called user taps the cancel button. Comes with a default implementation for UIViewControllers.
    /// - Warning: The viewController does not auto-dismiss. You must dismiss the viewController
    func creditCardScannerViewControllerDidCancel(_ viewController: TapFullScreenScannerViewController)
    /// Called when an error is encountered
    func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didErrorWith error: Error)
    /// Called when finished successfully
    /// - Note: successful finish does not guarentee that all credit card info can be extracted
    func creditCardScannerViewController(_ viewController: TapFullScreenScannerViewController, didFinishWith card: TapCard)
}


@available(iOS 13, *)
@objc open class TapFullScreenScannerViewController: UIViewController {
    
    /*public var titleLabelText: String = "Add card"
     public var subtitleLabelText: String = "Line up card within the lines"
     public var cancelButtonTitleText: String = "Cancel"
     public var cancelButtonTitleTextColor: UIColor = .gray
     public var labelTextColor: UIColor = .white
     public var textBackgroundColor: UIColor = .black*/
    internal var textBackgroundColor: UIColor = .black
    internal var cameraViewCreditCardFrameStrokeColor: UIColor = .green
    internal var cameraViewMaskLayerColor: UIColor = .black
    internal var cameraViewMaskAlpha: CGFloat = 0.7
    
    // MARK: - Subviews and layers
    
    /// View representing live camera
    private var cameraView: CameraView?
    /// The data source needed to configure
    private weak var dataSource:TapScannerDataSource?
    /// Analyzes text data for credit card info
    private lazy var analyzer = ImageAnalyzer(delegate: self, dataSource: dataSource)
    
    /// Conform to this delegate to get notified of key events
    @objc public weak var delegate: TapCreditCardScannerViewControllerDelegate?
    
    /// uiCustomization: The UI customization object to theme the scanner
    private var uiCustomization:TapFullScreenUICustomizer = .init() {
        didSet {
            self.cameraViewCreditCardFrameStrokeColor = uiCustomization.tapFullScreenScanBorderColor
        }
    }
    
    /// The backgroundColor stack view that is below the camera preview view
    private var bottomStackView = UIStackView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var cancelButton = UIButton(type: .system)
    
    private var allowedCardBrands:[CardBrand] = CardBrand.allCases
    // MARK: - Vision-related
    
    /// - Parameter delegate: Conform to this delegate to get notified of key events
    /// - Parameter uiCustomization: The UI customization object to theme the scanner
    public init(delegate: TapCreditCardScannerViewControllerDelegate? = nil, uiCustomization:TapFullScreenUICustomizer = .init(), dataSource: TapScannerDataSource?) {
        self.delegate = delegate
        self.dataSource = dataSource
        self.uiCustomization = uiCustomization
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        cameraView = CameraView(
            delegate: self,
            creditCardFrameStrokeColor: self.uiCustomization.tapFullScreenScanBorderColor,
            maskLayerColor: self.cameraViewMaskLayerColor,
            maskLayerAlpha: self.cameraViewMaskAlpha,
            showBlur: self.uiCustomization.blurCardScannerBackground
        )
        layoutSubviews()
        //setupLabelsAndButtons()
        // check if the consumer app did get an authoriation for cammera access or not
        AVCaptureDevice.authorize { [weak self] authoriazed in
            // This is on the main thread.
            guard let strongSelf = self else {
                return
            }
            guard authoriazed else {
                // Not athorized, then we inform the delegate that we canno start scanning :)
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: "Authorization denied")
                return
            }
            // Authorized, hence we can start the scanning process
            strongSelf.cameraView?.setupCamera(with: strongSelf.uiCustomization)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView?.setupRegionOfInterest()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraView?.stopSession()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cameraView?.regionOfInterest = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                self?.cameraView?.setupRegionOfInterest()
            } else {
                print("Portrait")
                self?.cameraView?.setupRegionOfInterest()
            }
        }
    }
}

@available(iOS 13, *)
private extension TapFullScreenScannerViewController {
    
    
    
    @objc func cancel(_ sender: UIButton) {
        delegate?.creditCardScannerViewControllerDidCancel(self)
    }
    
    func layoutSubviews() {
        view.backgroundColor = textBackgroundColor
        // TODO: test screen rotation cameraView, cutoutView
        cameraView?.translatesAutoresizingMaskIntoConstraints = false
        guard let cameraView = cameraView else { return }
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: CreditCard.heightRatioAgainstWidth, constant: 100),
        ])
        
        /*bottomStackView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(bottomStackView)
         NSLayoutConstraint.activate([
         bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         bottomStackView.topAnchor.constraint(equalTo: cameraView.bottomAnchor),
         ])
         
         cancelButton.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(cancelButton)
         NSLayoutConstraint.activate([
         cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
         ])
         
         bottomStackView.axis = .vertical
         bottomStackView.spacing = 16.0
         bottomStackView.isLayoutMarginsRelativeArrangement = true
         bottomStackView.distribution = .equalSpacing
         bottomStackView.directionalLayoutMargins = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
         let arrangedSubviews: [UIView] = [titleLabel, subtitleLabel]
         arrangedSubviews.forEach(bottomStackView.addArrangedSubview)*/
    }
    
    /*func setupLabelsAndButtons() {
     titleLabel.text = titleLabelText
     titleLabel.textAlignment = .center
     titleLabel.textColor = labelTextColor
     titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
     subtitleLabel.text = subtitleLabelText
     subtitleLabel.textAlignment = .center
     subtitleLabel.font = .preferredFont(forTextStyle: .title3)
     subtitleLabel.textColor = labelTextColor
     subtitleLabel.numberOfLines = 0
     cancelButton.setTitle(cancelButtonTitleText, for: .normal)
     cancelButton.setTitleColor(cancelButtonTitleTextColor, for: .normal)
     cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
     }*/
}

@available(iOS 13, *)
extension TapFullScreenScannerViewController: CameraViewDelegate {
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }
    
    internal func didError(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            strongSelf.cameraView?.stopSession()
        }
    }
}

@available(iOS 13, *)
extension TapFullScreenScannerViewController: ImageAnalyzerProtocol {
    internal func didFinishAnalyzation(with result: Result<TapCard, Error>) {
        switch result {
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView?.stopSession()
                strongSelf.dismiss(animated: true,completion: {
                    strongSelf.delegate?.creditCardScannerViewController(strongSelf, didFinishWith: creditCard)
                })
            }
            
        case let .failure(error):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView?.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            }
        }
    }
}

@available(iOS 13, *)
extension AVCaptureDevice {
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }
        
        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
            })
        default:
            mainThreadHandler(false)
        }
    }
}
#endif
#endif



/**
 This class represents the way you pass all the available ui customizations to be applied to tap full screen scanner
 - Tag: TapFullScreenUICustomizer
 **/
@objcMembers public class TapFullScreenUICustomizer:NSObject {
    
    /// The cancel button title default is "Cancel"
    public var tapFullScreenCancelButtonTitle:String = "Cancel"
    /// The cancel button font default is system with 15
    public var tapFullScreenCancelButtonFont:UIFont  = UIFont.systemFont(ofSize: 15)
    /// The cancel button color default is "White"
    public var tapFullScreenCancelButtonTitleColor:UIColor  = .white
    /// The cancel button holder background color default is "Black"
    public var tapFullScreenCancelButtonHolderViewColor:UIColor  = .black
    /// The borders of scan card color default is "Green"
    public var tapFullScreenScanBorderColor:UIColor  = .green
    // Indicates whether ot not to show a blur background around the scanning area
    public var blurCardScannerBackground:Bool = true
    
    public init(tapFullScreenCancelButtonTitle: String = "Cancel", tapFullScreenCancelButtonFont: UIFont = UIFont.systemFont(ofSize: 15), tapFullScreenCancelButtonTitleColor: UIColor = .white, tapFullScreenCancelButtonHolderViewColor: UIColor = .black, tapFullScreenScanBorderColor: UIColor = .green, blurCardScannerBackground: Bool = true) {
        self.tapFullScreenCancelButtonTitle = tapFullScreenCancelButtonTitle
        self.tapFullScreenCancelButtonFont = tapFullScreenCancelButtonFont
        self.tapFullScreenCancelButtonTitleColor = tapFullScreenCancelButtonTitleColor
        self.tapFullScreenCancelButtonHolderViewColor = tapFullScreenCancelButtonHolderViewColor
        self.tapFullScreenScanBorderColor = tapFullScreenScanBorderColor
        self.blurCardScannerBackground = blurCardScannerBackground
    }
}
