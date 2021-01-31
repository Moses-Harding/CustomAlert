# CustomAlert

According to Apple:
>The UIAlertController class is intended to be used as-is and does not support subclassing. 

This leaves limited room for customization. Additionally, validation is can be complicated, and it's difficult to get custom messages to appear. I created CustomAlert to allow you to 1. rapidly create simple alerts, 2. customize the visual aspects of the alerts, and 3. add validation.

## Alert Types

There are two classes contained in this package (as well as a parent class that is overrideable if you choose) - **SimpleAlert** and **TextInputAlert**.

### SimpleAlert

**SimpleAlert** allows you to create a simple pop-up with buttons and a message. You can customize those things, but the simplest implementation just looks like this:
```
let alert = SimpleAlert(parentViewController: self, message: "Simple Message")
```
If the output is not visually appealing enough, it's easy to override almost every property since the labels and buttons are public:
```
alert.messageLabel.textAlignment = .center
alert.messageLabel.textColor = .blue
```

The alert accepts optional closure arguments so that you can customize the actions of the "OK" and "Cancel" buttons.
```
let title = "Simple Alert"
let message = "The message body is here."

let okayAction = {
     print("Okay was pressed")
}
let cancelAction = {
    print("Cancel was pressed")
}
        
let alert = SimpleAlert(parentViewController: self, title: title, message: message, messageFontSize: 12, okayAction: okayAction, cancelAction: cancelAction)
```

You can use the set functions to modify items after the fact, including the ability to modify the button text:
```
alert.setCustomOkayText(to: "Cancel", fontColor: .red)
alert.okayAction = { print("Cancel") }
 alert.setFont(for: alert.messageLabel, fontSize: 100, fontName: "Helvetica")
```

### TextInputAlert

**TextInputAlert** is where this class gets really useful (I _hope_). Setting one up can be equally as simple as a **SimpleAlert**, but with addition of a text input field and validation field.

You can access the value captured by the input field via the `okayAction`, which is a closure in the form of `((String) -> ())`.
```
let okayAction: ((String) -> ()) = {
    self.someOtherClass.someFunction(with: $0)
}

let alert = TextInputAlert(parentViewController: self, message: "Capture text", okayAction: okayAction)
```
You can provide validation with a validationAction (`((String) -> (Bool))`) and a corresponding validationMessage ( `((String) -> (String?))`). These pop up after the user has tapped "OK", and subsequently persist as long as the user's entry violates your validation.
```
let validationAction: ((String) -> (Bool)) = { (text: String) in
    if text.count < 3 {
        return false
    } else if text == "Test" {
        return false
    }
    return true
}

let validationMessage: ((String) -> (String?)) = { (text: String) in
    if text.count < 3 {
        return "Must be longer than 2 characters."
    } else if text == "Test" {
        return "Remember - the input text can NOT be the word 'Test.' Try to choose something else"
    }
    return nil
}

let alert = TextInputAlert(parentViewController: self, title: title, message: message, messageFontSize: 16, validationFontSize: 12, validationAction: validationAction, validationMessage: validationMessage)
```
Having a mis-matched validation message and action won't cause any errors, but it might confuse the user. 

Finally, keep in mind that the alert will automatically size itself to accomodate the validation, but there is simple a limit to how much text a single view can accomodate, so double-check to make sure everything fits.
