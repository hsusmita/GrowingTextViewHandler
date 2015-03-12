# GrowingTextViewHandler
An NSObject subclass to handle resizing of UITextView as the user types in. The textview resizes as long as the number of lines lies between specified minimum and maximum number of lines. 
These are the public properties which can be set from the client code.
  * animationDuration    : Default 0.8
  * maximumNumberOfLines : Default 3
  * minimumNumberOfLines : Default 1 

#Installation

Add following lines in your pod file  

pod 'GrowingTextViewHandler', :git => 'https://github.com/hsusmita/GrowingTextViewHandler.git',:branch => 'master'

You might have to use "use_frameworks!". This is because Pods written in Swift can only be integrated as frameworks.

#Usage
First create an instance of GrowingTextViewHandler. It takes an UITextView and its height constraint as arguments. You can specify the maximum and minimum number of lines. Then in the method "textViewDidChange" call the method resizeTextView  

    var handler:GrowingTextViewHandler?
    @IBOutlet weak var aTextView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
      super.viewDidLoad()
      self.handler = GrowingTextViewHandler(textView: self.aTextView!, heightConstraint: self.heightConstraint)
      self.handler.minimumNumberOfLines = 2
      self.handler.maximumNumberOfLines = 6
    }

    func textViewDidChange(textView: UITextView) {
     self.handler?.resizeTextView(animated:true)
    }


