# LineTextField
Custom UITextField with floated placeholder and an underline.

## Requirenments

- iOS 9.0+

## Installation

### CocoaPods

LineTextField is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LineTextField'
```

## Usafe

```swift
import LineTextField

//Connect IBOutlet
@IBOutlet var lineTextField: LineTextField!

//Create programmatically
let lineTextField = LineTextField(frame: CGRect(x: 20, y: 400, width: view.frame.width - 40, height: 35))
lineTextField.floatingPlaceholder = true
```

### Bottom line
You can specify default and active color for bottom line for `LineTextField`.

```swift
lineTextField.lineColorDefault = UIColor.red
lineTextField.lineColorActive = UIColor.blue
```

![bottom line](https://user-images.githubusercontent.com/8337067/78116638-4b016180-740d-11ea-8b31-acebaba8c68b.gif)

These properties are available for change in Interface Builder.

### Floating placeholder
You can use floating placeholder

```swift
lineTextField.floatingPlaceholder = true
```

and specify text color for active/inactive state of floating placeholder

```swift
lineTextField.floatingPlaceholderColor = UIColor.red
lineTextField.floatingPlaceholderActiveColor = UIColor.blue
```

![floating placeholder](https://user-images.githubusercontent.com/8337067/78119498-3626cd00-7411-11ea-85b1-6d7310e12f70.gif)

These properties are available for change in Interface Builder.

## Demo
You can see other features in the example project.
