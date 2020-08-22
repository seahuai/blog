#### image

1. image command is an alias for the `target modules`, it can querying information about any private frameworks and its classes or methods not pubilc.
2. `image list`- list all modules currently loaded

```shell
[  0] 56E47800-2CCB-3B7D-B94B-CCF5F13D6BCF 0x00007fff256b8000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation 
```

* UUID uniquely identifies the version of the Foundation module
* Following the UUID is the load addreass, 0x00007fff256b8000, this identifies where the module is loaded into the application's process space
* Finally, the full path of module on disk

3. `image dump` -  Commands for dumping information about one or more target modules

4. `image lookup` - Look up information within executable and dependent shared library images

   1. example:  `image lookup -rn NSObject\(IvarDescription\)`

      ```````objective-c
      Summary: UIKitCore`-[NSObject(IvarDescription) __ivarDescriptionForClass:]        
      Summary: UIKitCore`-[NSObject(IvarDescription) _ivarDescription]        
      Summary: UIKitCore`-[NSObject(IvarDescription) __propertyDescriptionForClass:]        
      Summary: UIKitCore`-[NSObject(IvarDescription) _propertyDescription]        
      Summary: UIKitCore`-[NSObject(IvarDescription) __methodDescriptionForClass:]        
      Summary: UIKitCore`-[NSObject(IvarDescription) _methodDescription]        
      Summary: UIKitCore`-[NSObject(IvarDescription) _shortMethodDescription]
      ```````

