# In App Purchase Demo Project

A basic in app purchase demonstration project for use with iOS projects. Written in Swift 4.

## Description

This demonstrates how to setup and use in app purchase functionality in an iOS app. It is currently setup with hard coded product identifiers but can be (and has been) adapted for use with dynamic products and product identifiers fetched from a server for display and purchase within an iOS application.

The core functionality for interaction with iTunesConnect for purchasing purposes is located in the 'iTunesStore' directory. You can edit it if needed but it's setup to work out of the box.

There are two demo classes designed as templates for your use/editing/adaptation for use with your projects. 

They are MyProductIdentifiers.swift and MyAppProductStore.swift. See the 'Installation' section below for directions.

Note that the test app is setup to validate the product identifiers (see ViewController.swift, that's where the store instance is setup) but the product identifiers are simply placeholders so validation will fail when you run the project. 

There are two ways to test with your product identifiers.
1. Change the bundle id of this test project to your own and update with your own product identifiers if you want to use this project as a test bed.
2. Copy the files into your own project and update the product identifiers to test.


## Requirements

- iOS 10.0+
- Xcode 9
- Swift 4

## Installation

 1. Copy the iTunesStore directory into your project.
 2. Copy the MyProductIdentifiers.swift & MyAppProductStore.swift files into your app.
 3. Edit MyProductIdentifiers
     - Update with your own product identifiers.
 4. Edit MyAppProductStore.swift
     - Function 'processPurchaseStatus(_ status: PurchaseStatus)', add or update with whatever custom handling you want for each status during the purchase process. This is where you should provide access for any purchased products or handle any errors. 
     - Also, if any custom handling is desired during the product identifier validation steps, you can edit the appropriate delegate functions in this class as well.

