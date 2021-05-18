# `OutOfTouch`  ![Status](https://github.com/robenkleene/outoftouch/actions/workflows/ci.yml/badge.svg) ![Status](https://github.com/robenkleene/outoftouch/actions/workflows/release.yml/badge.svg)

`OutOfTouch` is a Cocoa framework for creating a separate process that modifies the file system. 

The macOS [File System Events API](https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html), [`FSEventStreamCreate`](https://developer.apple.com/reference/coreservices/1443980-fseventstreamcreate) has a flag `kFSEventStreamCreateFlagIgnoreSelf` that ignores events that were triggered by the current process. In order to test that these events fire in a Test Target, the file system modifications have to come from a separate process.

`OutOfTouch` provides helper methods for creating file system events from a separate process.

    public class func createFile(atPath path: String, handler: OutOfTouchHandler?) {
    public class func removeFile(atPath path: String, handler: OutOfTouchHandler?) {
    public class func createDirectory(atPath path: String, handler: OutOfTouchHandler?) {
    public class func removeDirectory(atPath path: String, handler: OutOfTouchHandler?) {
    public class func copyDirectory(atPath path: String,
    public class func moveItem(atPath path: String,
    public class func writeToFile(atPath path: String,

Most take an `OutOfTouchHandler` for `stdout`, `stderr` and exit status:

    public typealias OutOfTouchHandler = (String?, String?, Int32) -> Void

