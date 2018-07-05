//
//  OutOfTouchTests.swift
//  OutOfTouchTests
//
//  Created by Roben Kleene on 11/25/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import OutOfTouch
import StringPlusPath
import XCTest
import XCTestTemp

class OutOfTouchTests: TemporaryDirectoryTestCase {
    let defaultTimeout = 20.0
    let testFilename = "Test File"
    let testDirectoryName = "Test Directory"
    let testDirectoryNameTwo = "Test Directory Two"
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
                               contents: testContents) { standardOutput, standardError, exitStatus in
            XCTAssertEqual(String(standardOutput!.dropLast()),
                           self.testContents,
                           "`writeToFile` also writes the contents to `standardOutput`")
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

        do {
            // Read the contents
            // Test remove the second file with NSFileManager
            let rawContents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            // Remove the new line noise that comes from reading and writing the file
            let contents = String(rawContents.dropLast())
            XCTAssertEqual(contents, testContents)
        } catch {
            XCTFail()
        }

        // # Clean Up

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
        // # Setup

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

        // # Test

        // Write to the file
        let writeExpectation = expectation(description: "Write to file")
        OutOfTouch.writeToFile(atPath: path,
                               contents: testContents) { standardOutput, standardError, exitStatus in
            XCTAssertEqual(String(standardOutput!.dropLast()),
                           self.testContents,
                           "`writeToFile` also writes the contents to `standardOutput`")
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        do {
            // Read the contents
            let rawContents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            // Remove the new line noise that comes from reading and writing the file
            let contents = String(rawContents.dropLast())
            XCTAssertEqual(contents, testContents)
        } catch {
            XCTFail()
        }

        // # Clean Up

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
        OutOfTouch.writeToFile(atPath: path, contents: testContents) { _, _, exitStatus in
            // These two asserts sometimes fail:
            // `XCTAssertNotNil(standardError)`
            // `XCTAssertEqual(String(standardOutput!.dropLast()), self.testContents`
            // It's not clear it's defined in which order the process handler
            // blocks for processing `stdout` and exit are called.
//            XCTAssertEqual(String(standardOutput!.dropLast()),
//                           self.testContents,
//                           "`writeToFile` also writes the contents to `standardOutput`")
//            XCTAssertNotNil(standardError)
            XCTAssertTrue(exitStatus > 0)
            writeExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

    func testMove() {
        // # Setup

        // Create a directory
        let directoryPath = temporaryDirectoryPath.appendingPathComponent(testDirectoryName)
        let filePath = directoryPath.appendingPathComponent(testFilename)

        do {
            try FileManager.default.createDirectory(atPath: directoryPath,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
            // Create a file
            try testContents.write(toFile: filePath,
                                    atomically: true,
                                    encoding: String.Encoding.utf8)
        } catch {
            XCTFail()
        }

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // # Test

        // Move the directory
        let destinationDirectoryPath = temporaryDirectoryPath.appendingPathComponent(testDirectoryNameTwo)
        let destinationFilePath = destinationDirectoryPath.appendingPathComponent(testFilename)
        let moveExpectation = expectation(description: "Move")
        OutOfTouch.moveItem(atPath: directoryPath,
                            toPath: destinationDirectoryPath) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            moveExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists in the new location
        exists = FileManager.default.fileExists(atPath: destinationFilePath, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Confirm it doesn't exist in the old location
        exists = FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDir)
        XCTAssertFalse(exists)

        // # Clean Up

        // Remove the directory from the destination
        do {
            try removeTemporaryItem(atPath: destinationDirectoryPath)
        } catch {
            XCTFail()
        }
    }

    func testCopy() {
        // # Setup

        // Create a directory
        let directoryPath = temporaryDirectoryPath.appendingPathComponent(testDirectoryName)
        try! FileManager.default.createDirectory(atPath: directoryPath,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
        let filePath = directoryPath.appendingPathComponent(testFilename)

        // Create a file
        try! testContents.write(toFile: filePath,
                                atomically: true,
                                encoding: String.Encoding.utf8)

        // Confirm it exists
        var isDir: ObjCBool = false
        var exists = FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // # Test

        // Move the directory
        let destinationDirectoryPath = temporaryDirectoryPath.appendingPathComponent(testDirectoryNameTwo)
        let destinationFilePath = destinationDirectoryPath.appendingPathComponent(testFilename)
        let moveExpectation = expectation(description: "Move")
        OutOfTouch.copyDirectory(atPath: directoryPath,
                                 toPath: destinationDirectoryPath) { standardOutput, standardError, exitStatus in
            XCTAssertNil(standardOutput)
            XCTAssertNil(standardError)
            XCTAssert(exitStatus == 0)
            moveExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Confirm it exists in the new location
        exists = FileManager.default.fileExists(atPath: destinationFilePath, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // Confirm it also exists in the original location
        exists = FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir)
        XCTAssertTrue(exists)
        XCTAssertTrue(!isDir.boolValue)

        // # Clean Up

        // Remove the directory from the destination
        try! removeTemporaryItem(atPath: destinationDirectoryPath)
        try! removeTemporaryItem(atPath: directoryPath)
    }
}
