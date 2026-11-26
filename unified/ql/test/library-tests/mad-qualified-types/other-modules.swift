import Alamofire
import UIKit

func withOtherModelModules(
    response: DataResponse,
    qualifiedResponse: Alamofire.DataResponse,
    textField: UITextField,
    qualifiedTextField: UIKit.UITextField
) {
    _ = response.value  // $ isSource=remote
    _ = qualifiedResponse.value  // $ isSource=remote

    _ = textField.text  // $ isSource=local
    _ = qualifiedTextField.text  // $ isSource=local
}
