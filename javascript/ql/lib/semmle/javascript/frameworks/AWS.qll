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
   * Gets a node representing the AWS global config object.
   */
  private API::Node getAWSConfig() { result = getAWSImport().getMember("config") }

  /**
   * Gets a property write to the AWS config object.
   * This captures assignments to AWS.config properties.
   */
  private DataFlow::PropWrite configAssigment() {
    result = getAWSConfig().asSource().getAPropertyWrite()
  }

  /**
   * Gets a data flow node representing an instance of `new AWS.Credentials(accessKeyId, secretAccessKey)`.
   */
  private DataFlow::Node getCredentialsCreationNode() {
    result = getAWSImport().getMember("Credentials").getAnInstantiation().getReturn().asSource()
  }

  /**
   * Holds if the `i`th argument of `invk` is an object hash for `AWS.Config`.
   */
  private predicate takesConfigurationObject(DataFlow::InvokeNode invk, int i) {
    exists(API::Node mod | mod = getAWSImport() |
      // `AWS.config.update(nd)`
      invk = mod.getMember("config").getMember("update").getACall() and
      i = 0
      or
      exists(DataFlow::SourceNode cfg |
        cfg = mod.getMember("Config").getAnInstantiation().getReturn().asSource()
      |
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
      or
      // `AWS.config.accessKeyId = <user>` or `AWS.config.secretAccessKey = <password>`
      exists(string prop, DataFlow::PropWrite propWrite |
        propWrite = configAssigment() and
        this = propWrite.getRhs() and
        prop = propWrite.getPropertyName() and
        (
          kind = "user name" and
          prop = "accessKeyId"
          or
          kind = "password" and
          prop = "secretAccessKey"
        )
      )
      or
      // `new AWS.Credentials({ accessKeyId: <user>, secretAccessKey: <password> })`
      exists(DataFlow::InvokeNode invk |
        invk = getCredentialsCreationNode() and
        (
          this = invk.getArgument(0) and
          kind = "user name"
          or
          this = invk.getArgument(1) and
          kind = "password"
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
