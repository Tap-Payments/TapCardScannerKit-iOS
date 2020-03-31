# TapCardScanner-iOS

A SDK that provides an interface to scan different types of payment cards with various ways and contexts.

[![Platform](https://img.shields.io/cocoapods/p/TapThemeManager2020.svg?style=flat)](https://github.com/Tap-Payments/TapThemeManger-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TapCardScanner-iOS.svg?style=flat)](https://img.shields.io/Tap-Payments/v/TapQRCode-iOS)



## Requirements

To use the SDK the following requirements must be met:

1. **Xcode 11.0** or newer
2. **Swift 4.2** or newer (preinstalled with Xcode)
3. Deployment target SDK for the app: **iOS 12.0** or later



## Installation

------

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager, which automates and simplifies the process of using 3rd-party libraries in your projects.
You can install it with the following command:

```
$ gem install cocoapods
```

### Podfile

To integrate goSellSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
platform :ios, '12.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'MyApp' do
    
    pod 'TapCardScanner-iOS'

end
```

Then, run the following command:

```
$ pod update
```



## Features

------

`TapCardScanner-iOS` provides extensive ways for scanning payment cards whether:

- Embossed cards:

  - Cards that has digits and letters raised and well crafted.
  - Examples:
    - Visa.
    - Mastercard.
    - Amex.
    - ![All of Your Embossing Questions, Answered.](https://www.cardsource.com/hs-fs/hubfs/Images%20for%20sharing%20(bigger%20files)/shutterstock_613618706%20(1).jpg?width=400&name=shutterstock_613618706%20(1).jpg)
  - For more info check : [Embossed Card Explaination](https://www.creditcards.com/credit-card-news/glossary/term-embossed.php)) 

- Unembossed cards:

  - Cards where the numbers on the card are not raised up like a normal card. It is perfectly flat, with everything just printed on the card.
  - Examples:
    - Some types of Visa.
    - KNET in Kuwait.
    - MADA in KSA.
    - ![Prepaid Cards | Mastercard](https://www.mastercard.ca/en-ca/consumers/find-card-products/prepaid-cards/_jcr_content/contentpar/herolight/image.adaptive.479.high.png/1516312754375.png)

- For more info check: [Unembossed Card Explaination](https://www.commercebank.com/sharedcontent/pdfs/merchant-online/MerchantOnline_winter07.pdf).) 

  

  Making it one of the most inclusive pods in the market, yet one of the easiest to integrate with.

### Asynchronous Card Scanning

The kit provides an asyncronous offline way to scan cards from a camera feed right away in your app. This works great in case of scanning embossed cards. The Kit provides two ways to start an asynchronous:

1. Inline card scanner.
2. Full screen card scanner.
3. EMVCO push payment based QR codes.

Also, the Kit provides an interface to style the scanner in both cases as follows:

1. Cancel button color.
2. Cancel button localisation.
3. Scanner rectangle colour.



#### Asynchronous - Full Screen Scanner

This feature provides an easy way to start the scanner in a modal covering screen.



##### TapFullScreenUICustomizer Class

This class is used whenever you want to customise the look and feel of the full scanner.

*Swift*:

```swift
import TapCardScanner_iOS

let tapFullScreenCustomiser:TapFullScreenUICustomizer = TapFullScreenUICustomizer()
tapFullScreenCustomiser.tapFullScreenCancelButtonTitle = "Cancel"
tapFullScreenCustomiser.tapFullScreenCancelButtonFont = UIFont.systemFont(ofSize: 15)
tapFullScreenCustomiser.tapFullScreenCancelButtonTitleColor = .white
tapFullScreenCustomiser.tapFullScreenCancelButtonHolderViewColor = .black
tapFullScreenCustomiser.tapFullScreenScanBorderColor = .green

```

*Parameters*:

| Parameter name                           | Parameter type | Required | Default value                 | Description                               |
| ---------------------------------------- | -------------- | -------- | ----------------------------- | ----------------------------------------- |
| tapFullScreenCancelButtonTitle           | String         | No       | Cancel                        | The cancel button title                   |
| tapFullScreenCancelButtonFont            | UIFont         | No       | UIFont.systemFont(ofSize: 15) | The cancel button font                    |
| tapFullScreenCancelButtonTitleColor      | UIColor        | No       | .white                        | The cancel button title color             |
| tapFullScreenCancelButtonHolderViewColor | UIColor        | No       | .black                        | The cancel button holder background color |
| tapFullScreenScanBorderColor             | UIColor        | No       | .green                        | The borders of scan card color            |



##### TapFullScreenCardScanner Class

This is the class providing the functionalioy of showing the Tap scanner as a modal full screen controller. Integrating with it is as simple as writing one line as follows

*Swift*:

```swift
import TapCardScanner_iOS

let fullScanner:TapFullScreenCardScanner = TapFullScreenCardScanner()

fullScanner.showModalScreen(presenter: self,tapCardScannerDidFinish: { (scannedCard) in
                            print("Card Number : \(scannedCard.scannedCardNumber ?? "")\nCard Name : \(scannedCard.scannedCardName ?? "")\nCard Expiry : \(scannedCard.scannedCardExpiryMonth ?? "")/\(scannedCard.scannedCardExpiryYear ?? "")\n")
                        },scannerUICustomization: customiser)
```

*Parameters*:

| Parameter name             | Parameter type            | Required | Default value | Description                                                  |
| -------------------------- | ------------------------- | -------- | ------------- | ------------------------------------------------------------ |
| Presenter                  | UIViewController          | Yes      | None          | The UIViewController the TAP scanner will be presented from  |
| tapFullCardScannerDimissed | () -> ()                  | No       | Nil           | The dismiss block that will be called if the user clicks on the cancel button |
| tapCardScannerDidFinish    | (ScannedTapCard)->()      | No       | Nil           | The block that will be called whenver a card has been scanned |
| scannerUICustomization     | TapFullScreenUICustomizer | No       | .init()       | Pass this object if you want to customise how the UI elements of the full screen scanner looks like |





##### ScannedTapCard Class

This is the data model the scanner will return after scanning a card

*Parameters*:

| Parameter name         | Parameter type | Required | Default value | Description                                                  |
| ---------------------- | -------------- | -------- | ------------- | ------------------------------------------------------------ |
| scannedCardNumber      | String         | No       | Nil           | Represents the scanned card number if any. Otherwise, it will be nil |
| scannedCardName        | String         | No       | Nil           | Represents the scanned card name if any. Otherwise, it will be nil |
| scannedCardExpiryMonth | String         | No       | Nil           | Represents the scanned card expiration month MM if any. Otherwise, it will be nil |
| scannedCardExpiryYear  | String         | No       | Nil           | Represents the scanned card exxpiration year YYYY or YY if any. Otherwise, it will be nil |



