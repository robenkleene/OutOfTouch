# `OutOfTouch`

`OutOfTouch` is a Cocoa framework for creating a separate process that modifies the file system. 

The macOS [File System Events API](https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html), [`FSEventStreamCreate`](https://developer.apple.com/reference/coreservices/1443980-fseventstreamcreate) has a flag `kFSEventStreamCreateFlagIgnoreSelf` that ignores events that were triggered by the current process. In order to test that these events fire in a Test Target, the file system modifications have to come from a separate process.

`OutOfTouch` provides helper methods for creating file system events from a separate process.

	public class func createFile(atPath path: String) {
	public class func createFile(atPath path: String, handler: ((Void) -> Void)?) {
	public class func removeFile(atPath path: String) {
	public class func removeFile(atPath path: String, handler: ((Void) -> Void)?) {
	public class func createDirectory(atPath path: String) {
	public class func createDirectory(atPath path: String, handler: ((Void) -> Void)?) {
	public class func removeDirectory(atPath path: String) {
	public class func removeDirectory(atPath path: String, handler: ((Void) -> Void)?) {
	public class func copyDirectory(atPath path: String, toPath destinationPath: String) {
	public class func copyDirectory(atPath path: String, toPath destinationPath: String, handler: ((Void) -> Void)?) {
	public class func moveItem(atPath path: String, toPath destinationPath: String) {
	public class func moveItem(atPath path: String, toPath destinationPath: String, handler: ((Void) -> Void)?) {
	public class func writeToFile(atPath path: String, contents: String) {
