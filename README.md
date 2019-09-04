# Product-Discovery
An iOS application to do the test for interview.

## Application structure
The application has three screens.

- First is home screen where user can choose to start discovery products
- Second is Product Listing screen where user can search products as a list and tap on product item to see detail of it
- Last is Product Detail screen which contains detail of the product

## Application architecture
The application uses MVC architecture with some extensions and networking protocol / class with allows developers can make mock networking classes to write unit tests for web service handling classes and controllers easier.

This application also uses an open source library called Kingfisher (through CocoaPods) to load image.

In the Product Detail screen, we separate to many view controllers to make sure the code does not have a massive view controller.

## Caching data
- We use sqlite database through Core Data framework to cache the attibuteGroups data of each product detail the app already loaded and use that cache when open product detail screen while waiting the service return latest data

- We store the cart count for each product in UserDefaults

## Images and colors
All images and colors are stored in Assets.xcassets, and we create a UIColor extension to managed the defined colors.

