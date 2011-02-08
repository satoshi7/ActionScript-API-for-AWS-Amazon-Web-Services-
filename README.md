ActionScript API for AWS (Amazon Web Services)
=============

ActionScript からカンタンにAWSへアクセスするためのAPI群です。

とりあえずswcが必要な方はこちらへ

* [cmawslib.swc](https://github.com/satoshi7/ActionScript-API-for-AWS-Amazon-Web-Services-/blob/master/bin/cmawslib.swc)

更新履歴
-------
2011/2/9 : エンドポイントをコンストラクタで指定できるようにしました。
2011/2/9 : タイプミスを修正しました。

操作できるAPI
-------

Amazon Web Services Query API が提供しているものはほぼ全ての操作に対応しています。

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

使い方
-------
本コードは Adobe Flex Library Project で作っています。
ご使用の際には Adobe Flash Builder などでプロジェクトのインポートを行い、
アプリケーション側の設定画面からライブラリ追加をしてご利用ください。 

開発の仕方
-------
以下のように短いコードを書いて頂ければカンタンにAWSを操作できます。


Amazon Elastic Compute Cloud
	var ec2:EC2 = new EC2();
	ec2.setAWSCredentials(AWSKey.key,AWSKey.sec);
	ec2.addEventListener(AWSEvent.RESULT,awsHandler);
	ec2.executeRequest(EC2.DESCRIVE_REGIONS);


Amazon Elastic MapReduce
	var emr:EMR = new EMR();
	emr.setAWSCredentials(AWSKey.key,AWSKey.sec);
	emr.addEventListener(AWSEvent.RESULT,awsHandler);
	emr.executeRequest(EMR.DESCRIBE_JOB_FLOWS);


Amazon Relational Database Service
	var rds:RDS = new RDS();
	rds.setAWSCredentials(AWSKey.key,AWSKey.sec);
	rds.addEventListener(AWSEvent.RESULT,awsHandler);
	rds.executeRequest(RDS.DESCRIBE_DB_INSTANCES);


Amazon Simple Notification Service
	var sns:SNS = new SNS();
	sns.setAWSCredentials(AWSKey.key,AWSKey.sec);
	sns.addEventListener(AWSEvent.RESULT,awsHandler);
	sns.executeRequest(SNS.LIST_TOPICS);

					
Amazon SimpleDB
	var sdb:SDB = new SDB();
	sdb.setAWSCredentials(AWSKey.key,AWSKey.sec);
	sdb.addEventListener(AWSEvent.RESULT,awsHandler);
	sdb.executeRequest(SDB.LIST_DOMAINS);


Amazon Simple Queue Service
	var sqs:SQS = new SQS();
	sqs.setAWSCredentials(AWSKey.key,AWSKey.sec);
	sqs.addEventListener(AWSEvent.RESULT,awsHandler);
	sqs.executeRequest(SQS.LIST_QUEUES);


Amazon CloudWatch
	var acw:ACW = new ACW();
	acw.setAWSCredentials(AWSKey.key,AWSKey.sec);
	acw.addEventListener(AWSEvent.RESULT,awsHandler);
	acw.executeRequest(ACW.LIST_METRICS);

	
AWS Identity and Access Management
	var iam:IAM = new IAM();
	iam.setAWSCredentials(AWSKey.key,AWSKey.sec);
	iam.addEventListener(AWSEvent.RESULT,awsHandler);
	iam.executeRequest(IAM.LIST_ACCESS_KEYS);


AWS Elastic Beanstalk 
	var ebt:EBT = new EBT();
	ebt.setAWSCredentials(AWSKey.key,AWSKey.sec);
	ebt.addEventListener(AWSEvent.RESULT,awsHandler);
	ebt.executeRequest(EBT.DESCRIBE_APPLICATIONS);


Amazon Simple Email Serivce
	var ses:SES = new SES();
	ses.setAWSCredentials(AWSKey.key,AWSKey.sec);
	ses.addEventListener(AWSEvent.RESULT,awsHandler);
	ses.executeRequest(SES.LIST_VERIFIED_EMAIL_ADDRESSES);
	
	or
	
	var ses:SES = new SES();
	ses.setAWSCredentials(AWSKey.key,AWSKey.sec);
	ses.addEventListener(AWSEvent.RESULT,awsHandler);
	var vals:Array = new Array();
	vals.push(new Parameter("Destination.ToAddresses.member.1","<to address>"));
	vals.push(new Parameter("Message.Subject.Data","こんにちは Amazon SES"));
	vals.push(new Parameter("Message.Subject.CharSet","Shift_JIS"));
	vals.push(new Parameter("Message.Body.Text.Data","こんにちは、Amazon SES"));				
	vals.push(new Parameter("Message.Body.Text.CharSet","Shift_JIS"));				
	vals.push(new Parameter("Source","<from address>"));
	ses.executeRequest(SES.SEND_EMAIL,vals);


イベントハンドラの記述の仕方
	public function awsHandler(event:AWSEvent):void{
		var data:Object = event.data;
		//XML形式のテキストが取得されます。
		ta.text += data.toString();
	}

注意
-------
本ライブラリを使うには、AWSと契約を行って頂き、発行される Access Key ID と Secret Access Key を使用します。
事前にご準備ください。

コントリビュータ
-------

* [@sato_shi](http://twitter.com/sato_shi/) - Classmethod,Inc. [http://classmethod.jp/](http://classmethod.jp/)]
