ActionScript API for AWS (Amazon Web Services)
=============

This is an ActionScript API Library Project for Amazon Web Services.

Anyway, try it!

* [cmawslib.swc](https://github.com/satoshi7/ActionScript-API-for-AWS-Amazon-Web-Services-/blob/master/bin/cmawslib.swc)

Update History
-------

2011/8/24 : Added Amazon ElastiCache, AWS Security Token Service.

2011/3/6  : Added Objec style request method exec().

2011/3/2  : Added Tokyo Region, EC2, SDB, CFM, ELB, ASC, S3, RDS, SQS, SNS.

2011/3/1  : Fixed bugs, SimpleDB.

2011/2/25 : Added AWS CloudFormation.

2011/2/14 : Added EC2 method. Update Timestamp spec to ISO8601.

2011/2/12 : Added Amazon Route 53.

2011/2/11 : Added Amazon CloudFront.

2011/2/10 : Added Amazon Simple Storage Service, Amazon Virtual Private Cloud.

2011/2/9  : Removed flex mx package classes. ex) DateFormatter

2011/2/9  : Added Amazon Elastic Load Balancing, Auto Scaling.

2011/2/9  : Added constructor to change the region. 

2011/2/9  : Fixed variable name...

Usable API's
-------

These API's are compatible for Amazon Web Services Query API.

* EC2 - Amazon Elastic Compute Cloud
* EMR - Amazon Elastic MapReduce
* RDS - Amazon Relational Database Service
* SNS - Amazon Simple Notification Service
* SDB - Amazon SimpleDB
* SQS - Amazon Simple Queue Service
* ACW - Amazon CloudWatch
* IAM - AWS Identity and Access Management
* EBT - AWS Elastic Beanstalk 
* SES - Amazon Simple Email Service
* ASC - Auto Scaling
* ELB - Amazon Elastic Load Balancing
* S3  - Amazon Simple Storage Service
* VPC - Amazon Virtual Private Cloud
* ACF - Amazon CloudFront
* AIE - Amazon Import/Export  -- under development..
* R53 - Amazon Route 53
* CFM - AWS CloudFormation
* AEC - Amazon ElastiCache
* STS - AWS Security Token Service

How to Use
-------
This is an ActionScript API Library Project (.swc)  for Amazon Web Services.
You can import to Flash Builder Library Project or other development tool. 


How to Development
-------
You can develop the application by a really little code. 

    
Amazon Elastic Compute Cloud

    var ec2:EC2 = new EC2(EC2.US_EAST_1);
    ec2.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ec2.addEventListener(AWSEvent.RESULT,awsHandler);
    ec2.executeRequest(EC2.DESCRIBE_REGIONS);
    
    or
    
    var ec2:EC2 = new EC2(EC2.US_EAST_1);
    ec2.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ec2.addEventListener(AWSEvent.RESULT,awsHandler);
    ec2.runInstances("ami-76f0061f",1,1,null,"m1.small");
    
    or
    
    var ec2:EC2 = new EC2(EC2.US_EAST_1);
    ec2.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ec2.addEventListener(AWSEvent.RESULT,awsHandler);
    ec2.exec({"Action":EC2.DESCRIBE_AVAILABILITY_ZONES});
    


Amazon Elastic MapReduce

    var emr:EMR = new EMR(EMR.US_EAST_1);
    emr.setAWSCredentials(AWSKey.key,AWSKey.sec);
    emr.addEventListener(AWSEvent.RESULT,awsHandler);
    emr.executeRequest(EMR.DESCRIBE_JOB_FLOWS);


Amazon Relational Database Service

    var rds:RDS = new RDS(RDS.US_EAST_1);
    rds.setAWSCredentials(AWSKey.key,AWSKey.sec);
    rds.addEventListener(AWSEvent.RESULT,awsHandler);
    rds.executeRequest(RDS.DESCRIBE_DB_INSTANCES);


Amazon Simple Notification Service

    var sns:SNS = new SNS(SNS.US_EAST_1);
    sns.setAWSCredentials(AWSKey.key,AWSKey.sec);
    sns.addEventListener(AWSEvent.RESULT,awsHandler);
    sns.executeRequest(SNS.LIST_TOPICS);

                    
Amazon SimpleDB

    var sdb:SDB = new SDB(SDB.US_EAST_1);
    sdb.setAWSCredentials(AWSKey.key,AWSKey.sec);
    sdb.addEventListener(AWSEvent.RESULT,awsHandler);
    sdb.executeRequest(SDB.LIST_DOMAINS);


Amazon Simple Queue Service

    var sqs:SQS = new SQS(SQS.US_EAST_1);
    sqs.setAWSCredentials(AWSKey.key,AWSKey.sec);
    sqs.addEventListener(AWSEvent.RESULT,awsHandler);
    sqs.executeRequest(SQS.LIST_QUEUES);


Amazon CloudWatch

    var acw:ACW = new ACW(ACW.US_EAST_1);
    acw.setAWSCredentials(AWSKey.key,AWSKey.sec);
    acw.addEventListener(AWSEvent.RESULT,awsHandler);
    acw.executeRequest(ACW.LIST_METRICS);

    
AWS Identity and Access Management

    var iam:IAM = new IAM(IAM.US_EAST_1);
    iam.setAWSCredentials(AWSKey.key,AWSKey.sec);
    iam.addEventListener(AWSEvent.RESULT,awsHandler);
    iam.executeRequest(IAM.LIST_ACCESS_KEYS);


AWS Elastic Beanstalk 

    var ebt:EBT = new EBT(EBT.US_EAST_1);
    ebt.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ebt.addEventListener(AWSEvent.RESULT,awsHandler);
    ebt.executeRequest(EBT.DESCRIBE_APPLICATIONS);


Amazon Simple Email Serivce

    var ses:SES = new SES(SES.US_EAST_1);
    ses.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ses.addEventListener(AWSEvent.RESULT,awsHandler);
    ses.executeRequest(SES.LIST_VERIFIED_EMAIL_ADDRESSES);
    
    or
    
    var ses:SES = new SES(SES.US_EAST_1);
    ses.setAWSCredentials(AWSKey.key,AWSKey.sec);
    ses.addEventListener(AWSEvent.RESULT,awsHandler);
    var vals:Array = new Array();
    vals.push(new Parameter("Destination.ToAddresses.member.1","<to address>"));
    vals.push(new Parameter("Message.Subject.Data","Hello Amazon SES"));
    vals.push(new Parameter("Message.Subject.CharSet","Shift_JIS"));
    vals.push(new Parameter("Message.Body.Text.Data","Hello、Amazon SES"));                
    vals.push(new Parameter("Message.Body.Text.CharSet","Shift_JIS"));                
    vals.push(new Parameter("Source","<from address>"));
    ses.executeRequest(SES.SEND_EMAIL,vals);
    

Amazon Elastic Load Balancing

    var elb:ELB = new ELB(ELB.EU_WEST_1);
    elb.setAWSCredentials(AWSKey.key,AWSKey.sec);
    elb.addEventListener(AWSEvent.RESULT,awsHandler);
    elb.executeRequest(ELB.DESCRIBE_LOAD_BALANCERS);            


Auto Scaling 

    var asc:ASC = new ASC(ASC.EU_WEST_1);
    asc.setAWSCredentials(AWSKey.key,AWSKey.sec);
    asc.addEventListener(AWSEvent.RESULT,awsHandler);
    asc.executeRequest(ASC.DESCRIBE_SCALING_ACTIVITIES);            


Amazon Simple Storage Service

    var s3:S3 = new S3(S3.US_EAST_1);
    s3.setAWSCredentials(AWSKey.key,AWSKey.sec);
    s3.addEventListener(AWSEvent.RESULT,awsHandler);
    s3.executeRequest();

    or
    
    var s3:S3 = new S3(S3.US_EAST_1);
    s3.setAWSCredentials(AWSKey.key,AWSKey.sec);
    s3.addEventListener(AWSEvent.RESULT,awsHandler);
    var vals:Array = new Array();
    vals.push(new Parameter("Bucket","<bucket-name>"));
    vals.push(new Parameter("Resources","<resource-path>"));
    s3.executeRequest(null,vals,"GET");
    

Amazon Virtual Private Cloud

    var vpc:VPC = new VPC(VPC.US_EAST_1);
    vpc.setAWSCredentials(AWSKey.key,AWSKey.sec);
    vpc.addEventListener(AWSEvent.RESULT,awsHandler);
    vpc.executeRequest(VPC.DESCRIBE_CUSTOMER_GATEWAYS);    


Amazon CloudFront

    var vpc:ACF = new ACF();
    vpc.setAWSCredentials(AWSKey.key,AWSKey.sec);
    vpc.addEventListener(AWSEvent.RESULT,awsHandler);
    vpc.executeRequest();
    
    
Amazon Route 53    

    var r53:R53 = new R53();
    r53.setAWSCredentials(AWSKey.key,AWSKey.sec);
    r53.addEventListener(AWSEvent.RESULT,awsHandler);
    r53.executeRequest();            


AWS CloudFormation

    var cfm:CFM = new CFM(CFM.US_EAST_1);
    cfm.setAWSCredentials(AWSKey.key,AWSKey.sec);
    cfm.addEventListener(AWSEvent.RESULT,awsHandler);
    cfm.executeRequest(CFM.DESCRIBE_STACKS);
    
    or
    
    var cfm:CFM = new CFM(CFM.US_EAST_1);
    cfm.setAWSCredentials(AWSKey.key,AWSKey.sec);
    cfm.addEventListener(AWSEvent.RESULT,awsHandler);
    var vals:Array = new Array();
    vals.push(new Parameter("StackName","test"));
    cfm.executeRequest(CFM.DESCRIBE_STACK_RESOURCES,vals);
        
    
Amazon ElastiCache

    var sts:STS = new STS();
    sts.setAWSCredentials(AWSKey.key,AWSKey.sec);
    var array:Array = new Array();
    array.push(new Parameter("Name","Bob"));
    sts.addEventListener(AWSEvent.RESULT,resultHandler);
    sts.executeRequest(STS.GET_FEDERATION_TOKEN,array);
    
    
AWS Security Token Service

    var aec:AEC = new AEC();
    aec.setAWSCredentials(AWSKey.key,AWSKey.sec);
    aec.addEventListener(AWSEvent.RESULT,resultHandler);
    aec.executeRequest(AEC.DESCRIBE_CACHE_SECURITY_GROUPS);
    
    
    

How to code for event handler

    public function awsHandler(event:AWSEvent):void{
        // E4X ( ECMAScript for XML ) object.
        var data:XML = XML(event.data);
        // wildcard namespace * and specify child element name. ex) requestId
        ta.text += data.*::requestId;
        ta.text += data;
    }


Conclusion
-------

To use this library, you have to contract to Amazon Web Services ( http://aws.amazon.com/ ) . And, use Access Key ID and Secret Access Key. 
Please prepare it beforehand. 

Contributor
-------

* [@sato_shi](http://twitter.com/sato_shi/) - Classmethod,Inc. [http://classmethod.jp/](http://classmethod.jp/)]
