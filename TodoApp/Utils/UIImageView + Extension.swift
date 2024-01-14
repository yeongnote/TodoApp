import UIKit

extension UIImageView {
    func getImageFromURL(url: String, completion: ((Result<Data, Error>) -> ())? = nil){
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion?(.failure(NetworkError.unknown(error.localizedDescription)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: invalid response")
                completion?(.failure(NetworkError.invalidResponse))
                return
            }
            guard let data = data else {
                print("Error: no data")
                completion?(.failure(NetworkError.emptyResponse))
                return
            }
            DispatchQueue.main.sync {
                self.image = UIImage(data: data)
                
            }
             
            completion?(.success(data))

        }
        task.resume()
    }
}
