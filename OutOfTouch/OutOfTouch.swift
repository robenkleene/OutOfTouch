//
//  swift
//  BubbleUp
//
//  Created by Roben Kleene on 11/22/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa

public class OutOfTouch {

    // MARK: Create File

    public class func createFile(atPath path: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        let task = Process()
        task.launchPath = "/usr/bin/touch"
        task.arguments = [path]
        run(task, handler: handler)
    }

    // MARK: Remove File

    public class func removeFile(atPath path: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        let task = Process()
        task.launchPath = "/bin/rm"
        task.arguments = [path]
        run(task, handler: handler)
    }

    // MARK: Create Directory

    public class func createDirectory(atPath path: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        let task = Process()
        task.launchPath = "/bin/mkdir"
        task.arguments = [path]
        run(task, handler: handler)
    }

    // MARK: Remove Directory

    public class func removeDirectory(atPath path: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        let task = Process()
        task.launchPath = "/bin/rm"
        task.arguments = ["-r", path]
        run(task, handler: handler)
    }

    // MARK: Copy Directory

    public class func copyDirectory(atPath path: String, toPath destinationPath: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        confirmSafe(path: destinationPath)
        if path.hasSuffix("/") {
            assert(false, "The path should not end with a slash")
            return
        }
        if destinationPath.hasSuffix("/") {
            assert(false, "The path should not end with a slash")
            return
        }
        let task = Process()
        task.launchPath = "/bin/cp"
        task.arguments = ["-R", path, destinationPath]
        run(task, handler: handler)
    }
    
    // MARK: Move Item

    public class func moveItem(atPath path: String, toPath destinationPath: String, handler: (() -> Void)?) {
        confirmSafe(path: path)
        confirmSafe(path: destinationPath)
        let task = Process()
        task.launchPath = "/bin/mv"
        task.arguments = [path, destinationPath]
        run(task, handler: handler)
    }

    // MARK: Write to File

    public class func writeToFile(atPath path: String, contents: String) {
        confirmSafe(path: path)
        let echoTask = Process()
        echoTask.launchPath = "/bin/echo"
        echoTask.arguments = [contents]
        let pipe = Pipe()
        echoTask.standardOutput = pipe

        let teeTask = Process()
        teeTask.launchPath = "/usr/bin/tee"
        teeTask.arguments = [path]
        teeTask.standardInput = pipe
        teeTask.standardOutput = Pipe() // Suppress stdout

        teeTask.launch()
        echoTask.launch()
    }

    // MARK: Private

    private class func confirmSafe(path: String) {
        let pathAsNSString: NSString = path as NSString
        if pathAsNSString.range(of: "*").location != NSNotFound {
            assert(false, "The path should not contain a wildcard")
        }
        if !path.hasPrefix("/var/folders/") {
            assert(false, "The path should be a temporary directory")
        }
    }

    private class func run(_ task: Process, handler: (() -> Void)?) {

        let standardOutputPipe = Pipe()
        standardOutputPipe.fileHandleForReading.readabilityHandler = { file in
            let data = file.availableData
            if
                let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue),
                output.length > 0
            {
                print("standardOutput \(output)")
            }
        }
        task.standardOutput = standardOutputPipe

        let standardErrorPipe = Pipe()
        standardErrorPipe.fileHandleForReading.readabilityHandler = { file in
            if
                let output = NSString(data: file.availableData, encoding: String.Encoding.utf8.rawValue),
                output.length > 0
            {
                print("standardError \(output)")
                assert(false, "There should not be output to standard error")
            }
        }
        task.standardError = standardErrorPipe

        task.terminationHandler = { task in
            handler?()
            assert(task.terminationStatus == 0)
            assert(task.standardOutput as! Pipe == standardOutputPipe)
            assert(task.standardError as! Pipe == standardErrorPipe)
            standardOutputPipe.fileHandleForReading.readabilityHandler = nil
            standardErrorPipe.fileHandleForReading.readabilityHandler = nil
        }
        
        task.launch()
    }

}
