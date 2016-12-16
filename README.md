# StandUp

Stand Up IOS app (Swift)

This was an app originally created at [CodeRed Hackathon](https://uhcode.red/) in 2015 hosted at University of Houston.

The app has a login controller with a parse backend.
It takes in data from the position of the iphone and determines if the user is sitting or standing.
This info is then sent to a server to be processed and stored,which is located at [StandUp Backend](https://github.com/jaybutera/StandUp)
Unfortunately, this was never completed so the ios app is limited to local storage.

The app correctly detects whether a user is sitting or standing and saves data in an object ready to be sent to a server.

To run the app open the StandUp.xcworkspace file because it include cocoapod files and a parse backend.

It also includes a debug view controller to see in realtime the device motion values and if the app correctly detects if 
you are sitting or standing.

Note: Will not work in simulator because device motion is not simulated. You have to use a device to test it.
