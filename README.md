# iOSProject Asteroids remake
This is a simple remake of Asteroids! 
The start screen is made of a fixed table, with 2 items in it: start and about. 
About contains some additional information about the project and it's constraints are different for iPhone & iPad.
The 'settings' screen is made using AutoLayout which then launches a segue to the SpriteKit scene. 
When the ship gets hit by an asteroid, a segue is launched and it goes to the game over screen, where the user can go back to the 'settings' screen to try again.


##Force touch
Unfortunately, I couldn't implement force touch. I borrowed my friend's iPhone 6s, and when I tried to debug the app on the phone,
it errored and when I googled it, found the solution: the iPhone was running a newer iOS version (9.x) than
was supported by my Xcode version. I didn't want to risk updating my Xcode on my VM, because of earlier complications.