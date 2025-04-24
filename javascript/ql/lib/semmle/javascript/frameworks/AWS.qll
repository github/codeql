/**
 * Provides classes for working with [AWS-SDK](https://aws.amazon.com/sdk-for-node-js/) applications.
 */

import javascript

module AWS {
  /**
   * Gets the name of a supported AWS service.
   */
  private string getAWSServiceName() {
    result =
      [
        "EC2", "Lambda", "ECS", "EKS", "Batch", "ElasticBeanstalk", "Lightsail", "AppRunner", "S3",
        "EFS", "Glacier", "S3Control", "StorageGateway", "Backup", "DynamoDB", "DynamoDBStreams",
        "RDS", "Redshift", "ElastiCache", "Neptune", "QLDB", "Athena", "Route53", "CloudFront",
        "APIGateway", "ApiGatewayV2", "DirectConnect", "GlobalAccelerator", "CloudWatch",
        "CloudFormation", "CloudTrail", "Config", "Organizations", "ServiceCatalog", "SSM",
        "ResourceGroups", "IAM", "CognitoIdentity", "CognitoIdentityServiceProvider", "GuardDuty",
        "Inspector", "KMS", "SecretsManager", "SecurityHub", "STS", "WAF", "WAFRegional",
        "SageMaker", "Rekognition", "Comprehend", "Textract", "Translate", "Polly",
        "LexModelBuildingService", "MachineLearning", "Personalize", "EMR", "Kinesis",
        "KinesisAnalytics", "KinesisVideo", "QuickSight", "DataPipeline", "Glue", "LakeFormation",
        "SNS", "SQS", "SES", "Pinpoint", "Chime", "Connect", "Amplify", "AppSync", "DeviceFarm",
        "IoTAnalytics", "IoTEvents", "IoT1ClickDevicesService", "IoTSiteWise", "MediaConvert",
        "MediaLive", "MediaPackage", "MediaStore", "ElasticTranscoder", "EventBridge", "MQ", "SWF",
        "StepFunctions"
      ]
  }

  /**
   * Gets a node representing an import of the AWS SDK.
   */
  private API::Node getAWSImport() { result = API::moduleImport("aws-sdk") }

  /**
   * Gets a data flow node representing an instantiation of an AWS service.
   */
  private DataFlow::Node getServiceInstantation() {
    result =
      getAWSImport().getMember(getAWSServiceName()).getAnInstantiation().getReturn().asSource()
  }

  /**
   * Holds if the `i`th argument of `invk` is an object hash for `AWS.Config`.
   */
  private predicate takesConfigurationObject(DataFlow::InvokeNode invk, int i) {
    exists(DataFlow::ModuleImportNode mod | mod.getPath() = "aws-sdk" |
      // `AWS.config.update(nd)`
      invk = mod.getAPropertyRead("config").getAMemberCall("update") and
      i = 0
      or
      exists(DataFlow::SourceNode cfg | cfg = mod.getAConstructorInvocation("Config") |
        // `new AWS.Config(nd)`
        invk = cfg and
        i = 0
        or
        // `var config = new AWS.Config(...); config.update(nd);`
        invk = cfg.getAMemberCall("update") and
        i = 0
      )
    )
  }

  /**
   * An expression that is used as an AWS config value: `{ accessKeyId: <user>, secretAccessKey: <password>}`.
   */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop, DataFlow::InvokeNode invk, int i |
        takesConfigurationObject(invk, i) and
        this = invk.getOptionArgument(i, prop)
        or
        // `new AWS.ServiceName({ accessKeyId: <user>, secretAccessKey: <password> })`
        invk = getServiceInstantation() and
        i = 0 and
        this = invk.getOptionArgument(i, prop)
      |
        prop = "accessKeyId" and kind = "user name"
        or
        prop = "secretAccessKey" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
