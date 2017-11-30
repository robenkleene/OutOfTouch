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
        OutOfTouch.createFile(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
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
        OutOfTouch.removeFile(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
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
        OutOfTouch.createDirectory(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
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
        OutOfTouch.removeDirectory(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            removeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it's removed
        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(!exists)
    }

    func testContentsNewFile() {
        let path = temporaryDirectoryPath.appendingPathComponent(testFilename)

        // Write to file
        let writeExpectation = expectation(description: "Write to file")
        OutOfTouch.writeToFile(atPath: path,
                               contents: testContents)
        { standardOutput, standardError, exitStatus in
            XCTAssertEqual(String(standardOutput!.dropLast()), self.testContents, "`writeToFile` also writes the contents to `standardOutput`")
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Read the contents
        let rawContents = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let contents = String(rawContents.dropLast()) // Remove the new line noise that comes from reading and writing the file
        XCTAssertEqual(contents, testContents)

        // Clean Up

        // Remove the file
        let removeExpectation = expectation(description: "Remove file")
        OutOfTouch.removeFile(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            removeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it's removed
        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(!exists)
    }

    func testContentsExistingFile() {
        let path = temporaryDirectoryPath.appendingPathComponent(testFilename)

        // Create a file
        let createExpectation = expectation(description: "Create file")
        OutOfTouch.createFile(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Write to the file
        let writeExpectation = expectation(description: "Write to file")
        OutOfTouch.writeToFile(atPath: path,
                               contents: testContents)
        { standardOutput, standardError, exitStatus in
            XCTAssertEqual(String(standardOutput!.dropLast()), self.testContents, "`writeToFile` also writes the contents to `standardOutput`")
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Read the contents
        let rawContents = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let contents = String(rawContents.dropLast()) // Remove the new line noise that comes from reading and writing the file
        XCTAssertEqual(contents, testContents)

        // Clean Up

        // Remove the file
        let removeExpectation = expectation(description: "Remove file")
        OutOfTouch.removeFile(atPath: path) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            removeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it's removed
        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        XCTAssertTrue(!exists)
    }

    func testError() {
        // `writeToFile` cannot write a new file to a directory that doesn't
        // exist yet, so this will generate an error.
        let path = temporaryDirectoryPath
            .appendingPathComponent(testDirectoryName)
            .appendingPathComponent(testFilename)

        // Write to file
        let writeExpectation = expectation(description: "Write to file")
        OutOfTouch.writeToFile(atPath: path, contents: testContents) { standardOutput, standardError, exitStatus in
            XCTAssertEqual(String(standardOutput!.dropLast()), self.testContents, "`writeToFile` also writes the contents to `standardOutput`")
            XCTAssertNotNil(standardError)
            XCTAssertTrue(exitStatus > 0)
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

//    func testMove() {
//        let path = temporaryDirectoryPath
//            .appendingPathComponent(testDirectoryName)
//            .appendingPathComponent(testFilename)
//
//        // Write to file
//        let writeExpectation = expectation(description: "Write to file")
//        OutOfTouch.writeToFile(atPath: path, contents: testContents) {
//            writeExpectation.fulfill()
//        }
//        waitForExpectations(timeout: defaultTimeout, handler: nil)
//
//        // Confirm it exists
//        var isDir: ObjCBool = false
//        var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
//        XCTAssertTrue(exists)
//        XCTAssertTrue(!isDir.boolValue)
//
//
//        // Read the contents
//        let rawContents = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
//        let contents = String(rawContents.dropLast()) // Remove the new line noise that comes from reading and writing the file
//        XCTAssertEqual(contents, testContents)
//
//        // Clean Up
//
//        // Remove the file
//        let removeExpectation = expectation(description: "Remove file")
//        OutOfTouch.removeFile(atPath: path) {
//            removeExpectation.fulfill()
//        }
//        waitForExpectations(timeout: defaultTimeout, handler: nil)
//
//        // Confirm it's removed
//        exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
//        XCTAssertTrue(!exists)
//    }

    func testCopy() {
        // Write to a file in a directory
        // Copy and confirm that it exists in the new location
        // Delete it from both locations
    }

}
