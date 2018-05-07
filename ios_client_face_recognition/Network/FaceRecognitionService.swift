import UIKit
import Moya


enum FaceRecognitionService {
    case login(username: String, password: String)
    case register(username: String, password: String, faces: [UIImage])
    case loginPhoto(image: UIImage)
    case highlightFaces(image: UIImage)
    case facesCoordinates(image: UIImage)
    case eyesCoordinates(image: UIImage)
    case identifyGroup(image: UIImage)
    case cropFace(image: UIImage)
    case authorizePerson(image: UIImage)
    case nonTokenCropFace(image: UIImage)
}


extension FaceRecognitionService: TargetType {
    var baseURL: URL {
        return URL(string: "http://vitalyainvoker.tk/users/api")!
    }
    
    
    var path: String {
        switch self {
        case .login( _, _):
            return "/login"
        case .register( _, _, _):
            return "/register"
        case .nonTokenCropFace(_):
            return "/non_token_crop_face"
        case .loginPhoto(_):
            return "/login_photo"
        case .highlightFaces(_):
            return "/highlight_faces"
        case .facesCoordinates(_):
            return "/faces_coordinates"
        case .eyesCoordinates(_):
            return "/eyes_coordinates"
        case .identifyGroup(_):
            return "/identify_group"
        case .cropFace(_):
            return "/crop_face"
        case .authorizePerson(_):
            return "/authorize_photo"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .get
        default:
            return .post
        }
    }
    
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    
    var task: Task {
        switch self {
        case .login(let username, let password):
            return .requestParameters(parameters: ["username": username, "password": password],
                                      encoding: URLEncoding.queryString)
        case .register(let username, let password, let faces):
            var multipartData = [MultipartFormData]()
            //images for post request
            for i in 0..<faces.count {
                multipartData.append(multipart(image: faces[i], name: "image\(i + 1)"))
            }
            
            multipartData.append(multipart(value: username, name: "username"))
            multipartData.append(multipart(value: password, name: "password"))
            
            return .uploadMultipart(multipartData)
        case .loginPhoto(let image), .highlightFaces(let image),
             .facesCoordinates(let image), .eyesCoordinates(let image),
             .identifyGroup(let image), .cropFace(let image),
             .authorizePerson(let image), .nonTokenCropFace(let image):
            return .uploadMultipart([multipart(image: image)])
        }
    }
    
    
    var headers: [String : String]? {
        return nil
    }
    
    
    private func multipart(image: UIImage, name: String = "image") -> MultipartFormData {
        guard let imageData = UIImagePNGRepresentation(image) else {
            fatalError("Couldn't parse image")
        }
        
        let imageMultipart = MultipartFormData(provider: MultipartFormData.FormDataProvider.data(imageData),
                                               name: name, fileName: "image.png", mimeType: "image/png")
        
        return imageMultipart
    }
    
    
    private func multipart(value: String, name: String) -> MultipartFormData {
        guard let data = value.data(using: .utf8) else {
            fatalError("Couldn't parse string")
        }
        
        return MultipartFormData(provider: MultipartFormData.FormDataProvider.data(data),
                                 name: name)
    }
}
