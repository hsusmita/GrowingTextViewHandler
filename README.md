# GrowingTextViewHandler
An NSObject subclass to handle resizing of UITextView as the user types in. The textview resizes as long as the number of lines lies between specified minimum and maximum number of lines. 
These are the public properties which can be set from the client code.
* animationDuration    : Default 0.5
* maximumNumberOfLines : Default INT_MAX
* minimumNumberOfLines : Default 1


#Installation

Add following lines in your pod file for swift 3
```
pod 'GrowingTextViewHandler-Swift', '1.1'
```
For older versions, use

```
pod 'GrowingTextViewHandler-Swift', '1.0.3'
```

#Usage

First create an instance of GrowingTextViewHandler. It takes an UITextView and its height constraint as arguments. You can specify the maximum and minimum number of lines. Then in the method "textViewDidChange" call the method resizeTextView  
```
var handler:GrowingTextViewHandler?
@IBOutlet weak var aTextView: UITextView!
@IBOutlet weak var heightConstraint: NSLayoutConstraint!
override func viewDidLoad() {
super.viewDidLoad()
self.handler? = GrowingTextViewHandler(textView: self.aTextView, heightConstraint: heightConstraint)
self.handler?.minimumNumberOfLines = 2
self.handler?.maximumNumberOfLines = 6
}

func textViewDidChange(textView: UITextView) {
self.handler?.resizeTextView(animated:true)
}

```

However when you set text programmatically, **textViewDidChange(textView: UITextView)** does not get called. For this case you can resize UITextView as follows:
```
self.handler?.setText("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", animated: true)

```
# Screenshots
<img src="https://cloud.githubusercontent.com/assets/3590619/8056375/1c37993a-0ec5-11e5-9a8b-1708ba2e4c6f.gif" width="400" display="inline-block">
