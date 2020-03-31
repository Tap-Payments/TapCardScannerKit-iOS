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

