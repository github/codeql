import Alamofire
import UIKit

func withOtherModelModules(
    qualifiedResponse: Alamofire.DataResponse,
    qualifiedTextField: UIKit.UITextField
) {
    _ = qualifiedResponse.value  // $ isSource=remote

    _ = qualifiedTextField.text  // $ isSource=local
}
