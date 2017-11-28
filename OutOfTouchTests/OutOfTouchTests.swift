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
        let path = temporaryDirectoryPath.appendingPathComponent(testFilename)

        // Remove the directory
        let writeExpectation = expectation(description: "Remove file")
        OutOfTouch.writeToFile(atPath: path, contents: testContents) {
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Clean Up

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
