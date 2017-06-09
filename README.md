# SwipeDemo

This is the swipe demo.

# About
Native iOS Swift app with Cocoapods integrated

# Pods
- AffdexSDK-iOS + dependencies - face recognition
- Koloda - Tinder-like swipe left/right
- Realm - database, probably to be removed (i think we can keep everything in memory)

# AffdexSDK
- library is written in ObjC, but thanks to header file, it can be used in Swift out of the box
- age recognition is bad, rest is good

# To do
~~1. Loading into memory the you-know-which xls table (manually convert to csv first). I think we can keep it in memory as 2d array
2. 'Algorithm' to go through the table~~
3. Storyboard with the screens + view controllers
- 1st screen some initial info and button to start
- 2nd screen the game screen
-- facial recognition runs in the background here.
-- cards to swipe left/right are displayed here
- 3rd screen results
4. Handling facial recognition results
- save somewhere (emotions per question)
- making the results affect the game algorithm
5. Styling the cards to swipe
6. Styling the 1st screen
7. Styling the results screen
