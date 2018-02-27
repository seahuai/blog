### URLSession

* 一个简单的网络请求

```
let url = URL(string: "https://www.baidu.com")
		 //创建URLSession
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        //创建dataTask
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            print((response as! HTTPURLResponse).statusCode)
        }
        //开始
        dataTask.resume()
```

### URLSession中的核心类
#### 1.[URLSessionConfiguration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration)
> URLSession的配置信息，设置cookie的存储方法、后台传输等内容

* `.default`持久化存储Cache，共享cookie，将证书存储到钥匙串中
* `.ephemeral `不存储任何东西到本地，而是存储在内存中，和session有一样的生命周期，用于无痕式浏览功能
* `.background(withIdentifier:)`创建后台会话，初始化时需要一个唯一的identifier作为参数

#### 2.[URLSessionTask](https://developer.apple.com/documentation/foundation/urlsessiontask)
* `DataTask`用来请求资源，服务器返回的数据以`Data`格式存储在内存中
* `UploadTask`
* `DownloadTask`

#### 3.[URLSession](https://developer.apple.com/documentation/foundation/urlsession)
* 通过configuration来创建会话，默认`.default`，然后用`URLSession`来完成网络相关操作

#### 4.[URLRequest](https://developer.apple.com/documentation/foundation/urlrequest)
* 指定请求的方法、URL、cache策略等

#### 5.[URLCache](https://developer.apple.com/documentation/foundation/urlcache)
* 同一个请求访问等到内容有可能都是一样的，使用缓存可以节省流量
* 根据`URLRequest`作为键，`CachedURLResponse`作为值来进行缓存
* 一般使用单例对象`shared`就已经足够

#### 6.[URLResponse](https://developer.apple.com/documentation/foundation/urlresponse)
* [HTTPURLResponse](https://developer.apple.com/documentation/foundation/httpurlresponse)是URLResponse的子类
* 大部分请求都是HTTP请求，大部分都是使用`HTTPURLResponse`，可以用来获得头部的内容、状态码等

#### 7.URLCredential、URLAuthenticationChallenge用于处理证书相关的东西
* 在访问某个资源时，如果服务器需要授权则会调用对应的代理方法，我们需要提供一个`URLCredential`对象

### 较为不熟悉的URLSessionUploadTask
* `URLSessionUploadTask`继承了`URLSessionDataTask`，用`URLSessionDataTask`也可以实现upload功能
* 创建task的方法类似，主要有以下几个方法

```
//前四个方法会自动计算Content－Length
func uploadTask(with: URLRequest, from: Data)
func uploadTask(with: URLRequest, from: Data?, completionHandler: (Data?, URLResponse?, Error?) -> Void)
func uploadTask(with: URLRequest, fromFile: URL)
func uploadTask(with: URLRequest, fromFile: URL, completionHandler: (Data?, URLResponse?, Error?) -> Void)
//该方法需要实现一个数据源方法urlSession(_:task:needNewBodyStream:)
func uploadTask(withStreamedRequest: URLRequest)

```
#### 上传图片
```
let url = URL(string: "http://www.freeimagehosting.net/upload.php")!
        var request = URLRequest(url: url)
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let imageData = #imageLiteral(resourceName: "IMG_0569.JPG").tiffRepresentation(using: .JPEG, factor: 1.0)
        let uploadTask = session.uploadTask(with: request, from: imageData) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let data = data,
                let htmlString = String.init(data: data, encoding: .utf8) else {
                    return
            }
            
            DispatchQueue.main.async {
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }

        }
        
        
        uploadTask.resume()
    }
```



