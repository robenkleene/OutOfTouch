//
//  OutOfTouchTests.swift
//  OutOfTouchTests
//
//  Created by Roben Kleene on 11/25/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import XCTest
import XCTestTemp
import StringPlusPath
import OutOfTouch

class OutOfTouchTests: TemporaryDirectoryTestCase {

    let defaultTimeout = 20.0
    let testFilename = "Test File"
    let testDirectoryName = "Test Directory"
    let testContents = "Test Contents"

    // public class func createFile(atPath path: String, handler: (() -> Void)?) {
    // public class func removeFile(atPath path: String, handler: (() -> Void)?) {
    // public class func createDirectory(atPath path: String, handler: (() -> Void)?) {
    // public class func removeDirectory(atPath path: String, handler: (() -> Void)?) {
    // public class func copyDirectory(atPath path: String, toPath destinationPath: String, handler: (() -> Void)?) {
    // public class func moveItem(atPath path: String, toPath destinationPath: String, handler: (() -> Void)?) {
    // public class func writeToFile(atPath path: String, contents: String) {

    func testFile() {
        let path = temporaryDirectoryPath.appendingPathComponent(testFilename)

        // Create a file
        let createExpectation = expectation(description: "Create file")
        OutOfTouch.createFile(atPath: path) {
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Remove the file
        let removeExpectation = expectation(description: "Remove file")
        OutOfTouch.removeFile(atPath: path) {
            removeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it's removed
        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(!exists)
    }

    func testDirectory() {
        let path = temporaryDirectoryPath.appendingPathComponent(testDirectoryName)

        // Create a directory
        let createExpectation = expectation(description: "Create directory")
        OutOfTouch.createDirectory(atPath: path) {
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(isDir.boolValue)

        // Remove the directory
        let removeExpectation = expectation(description: "Remove file")
        OutOfTouch.removeDirectory(atPath: path) {
            removeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it's removed
        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(!exists)
    }

    func testContentsNewFile() {
        // write contents
        // confirm file exists
        // confirm file contents
        // remove file
        // confirm file is removed
    }

    func testContentsExistingFile() {
        // create file
        // confirm file exists
        // write contents
        // confirm file contents
        // remove file
        // confirm file is removed
    }

    func testMove() {

    }

    func testCopy() {

    }

}
