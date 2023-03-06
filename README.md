# Sygma relayer Deployment guide
This guide is a step-by-step manual that will help you deploy Sygma Relayer and join the Sygma Bridge MPC consensus.
*Note: This process is not permissionless and should be agreed upon with the Sygma team in advance. For more information please visit [website](https://buildwithsygma.com/)*

This deployment guide is based on assumptions that the user will use AWS as an infrastructure provider and will use GitHub Actions as a deployment pipeline. Although this guide is deadlocked for now, it is not meant to be like that so we are encouraging to use any providers of your choice.

**While most of the code can be reused we still highly encourage you to consider this guide to be more a demo than something to use directly on production without changes**

## Pre-requsitieves

### Prepare configuration parameters
1. Prepare a Private key that will be used to send execution transactions on the destination network.
**Note: you can use one private key for different domains).**
**Note #2: Never use this private key for something else and keep it secret**
***Note #3: Do not forget to top up the balance of the sender key and set some periodic checks of the balance***

The current TestNet/Mainent Relayer operation requires private keys for 3 EVM networks: Goerli, Moonbase, and Polygon Mumbai (as it states for now).

2. For each network, you should have an RPC provider. You can use your own node or any of the available SaaS providers like Alchemy or Infura.

3. Fork the repo to your own organization. In this guide, the GitHub repo is used as CI/CD platform. More on GitHub actions read [here](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)
### Setup AWS account

If you already don't own an AWS Account, use [this link as a guide from the official support](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

## How to run infrastructure provisioning the first time

#### Tools

To create the resources in our repository you're going to need:
- [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform > 1.0](https://learn.hashicorp.com/tutorials/terraform/install-cli)

Now we can proceed to the resources in our AWS Account.

Before you run the Terraform Scripts, make sure to set the right Environment Variables to access your account. You might need a user with the right privileges to create the resources.


### Executing the scripts
This document provides step-by-step
In this guide, we are describing the process of deploying Relayers with GitHub actions on the infrastructure on the AWS,
as well as we provide all necessary scripts to provision the infra and deploy the relayers.



#### Configure AWS

```
aws configure
```
More details on how to configure AWS CLI client you can find [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

#### VPC

The only requirement to create the Relayers infrastructure is a VPC. Of course, you can use the default VPC from any region in your AWS account, but it's a best practice to create a VPC to allocate your resources. If you don't know what a VPC is, [use this document to better understand it](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).

In this repository, we have the folder `vpc`. In that folder run the following commands:
```
terraform init
terraform apply
```

You might need to input a few variables, you can do that in the prompt that will appear in your terminal or you could create a file called `terraform.tfvars` with the desired values. [Read this link for more information on Input Variables](https://www.terraform.io/language/values/variables).

When the prompt appears to apply the changes, type `yes`.

More details on how to run Terraform [what this video](https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started).

#### Relayers infra provision

In this repository, we have the folder `relayers`. In that folder run the following commands:
```
terraform init
terraform apply
```

You might need to input a few variables, you can do that in the prompt that will appear in your terminal or you could create a file called `terraform.tfvars` with the desired values. [Read this link for more information on Input Variables](https://www.terraform.io/language/values/variables).

When the prompt appears to apply the changes, type `yes`.

#### Configuration script

The configuration for the relayers is in the folder `ecs`. For ECS we configure our applications with a Task Definition. [You can read more about it here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html).

**Change EFS configuration according to your provision results.**

[efsVolumeConfiguration](https://github.com/sygmaprotocol/sygma-relayer-deployment/blob/main/ecs/task_definition_TESTNET.j2#L199) - set this value to the EFS File system ID that was created (should have `relayers-efs-Demo` name by default)



 Now all the infrastructure should be provisioned. And you should move to configuration.


#### Set Secret variables
Set the next secret variables in GitHub Secret variables section. They will be used for deployment.

 `AWS_REGION` - a region where you want your relayer to be deployed
 `AWS_ARN` - ARN of the user that will be deploying the Relayer
 `AWS_ROLE` - the name of IAM Role that will perform deployment

#### Cofigurate other GitHub action variables.

You can also configure different [env variables](https://github.com/sygmaprotocol/sygma-relayer-deployment/blob/main/.github/workflows/deploy_ecs_TESTNET.yml#L8)

### Relayer configuration

We use SSM to hold all of our secrets. To access it, go to your AWS Account, in the Search bar type `SSM`. Go into the Systems Manager Service. On the left side menu, go into Parameter Store.
Now you can create any secrets that you want, and then reference it in the `secrets` section in the Task Definition.

During the infrastructure, provisioning terraforms scripts will create a number of secret parameters in the [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html). You should manually set this parameter according to the following description

- **SYG_DOM_N -** domain configuration. One configuration per domain (network) (eg SYG_DOM_1, SYG_DOM_2, etc). Amount of supported domains is always growing, discuss this with the Sygma team but in general, scripts will create parameters for all Domains

    ```solidity
    {
        "id": 0,
        "name": "goerli",
        "type": "evm", // types {evm, substrate}
        "key": "123", // Private key that used to send execution transactions
        "endpoint": {RPC endpoint},
        "startBlock": 8415289, // the block from where your Relayer should start. (In most times it should be lastest block)
        "fresh": true,
    }

    {
        "id": 0,
        "name": "moonbase",
        "type": "evm", // types {evm, substrate}
        "key": "123", // Private key that used to send execution transactions
        "endpoint": "{RPC endpoint}",
        "startBlock": 8415289, // the block from where your Relayer should start. (In most times it should be lastest block)
        "fresh": true,
    }

    {
        "id": 0,
        "name": "mumbai",
        "type": "evm", // types {evm, substrate}
        "key": "123", // Private key that used to send execution transactions
        "endpoint": "{RPC endpoint}",
        "startBlock": 8415289, // the block from where you Relayer should start. (Most times it should be lastest block)
        "fresh": true,
    }
    ```

- **SYG_RELAYER_MPCCONFIG_KEY -** secret libp2p key

    *This key is used to secure libp2p communication between relayers. The format of the key is* RSA 2048 with base64 protobuf encoding.

    It is possible to generate a new key by using the CLI command `peer gen-key` from the [relayer repository](https://github.com/sygmaprotocol/sygma-relayer).
    This will generate an output LibP2P peer identity and LibP2P private key, you will need both. But for this param use LibP2P private key.
    **Note: keep private key secret**

    If you generate the key by yourself, you can find out complementary peer identity by running `peer info --private-key=<libp2p_identity_priv_key>`  This identity you will need later.

- **SYG_RELAYER_MPCCONFIG_TOPOLOGYCONFIGURATION_PATH**

    Example: `/mount/r1-top.json` Should be unique per relayer. (eg /mount/r1-top.json, /mount/r2-top.json, etc)

- **SYG_RELAYER_MPCCONFIG_TOPOLOGYCONFIGURATION_ENCRYPTIONKEY**

    AES secret key that is used to encrypt libp2p network topology. The Sygma team will provide you with this key.

Note:


- **SYG_RELAYER_MPCCONFIG_TOPOLOGYCONFIGURATION_URL**

    URL to fetch topology file from.  The Sygma team will provide you with this key.

- **SYG_RELAYER_MPCCONFIG_KEYSHAREPATH**

    Example: `/mount/r1.keyshare` - path to the file that will contain MPC private key share. Should be unique per relayer. (eg /mount/r1.keyshare, /mount/r2.keyshare, /mount/r3.keyshare, etc)


### Lunch relayer

After all, the configuration parameters above are set we need to add your Relayer(s) to the Sygma MPC network by updating the network topology.

Provide the Sygma team with the next params so we update the topology map:

1. The network address. This could be a DNS name or IP address.
2. Peer ID - determined from libp2p private key being used for that relayer (you can use relayers [CLI command](https://github.com/sygmaprotocol/sygma-relayer/blob/main/cli/peer/info.go) for this `peer info --private-key=<pk>`)

The final address of your relayer in the topology map will look this `"/dns4/relayer2/tcp/9001/p2p/QmeTuMtdpPB7zKDgmobEwSvxodrf5aFVSmBXX3SQJVjJaT"`

After all the information is provided Sygma team will regenerate Topology Map and initiate key Resharing by calling the Bridge contract [method](https://github.com/sygmaprotocol/sygma-solidity/blob/master/contracts/Bridge.sol#L351) with a new topology map hash.


### Run the deployment
After configuration is done, the current pipeline will run on every **push to the main branch**.
Make sure to grant all necessary permissions to the pipeline, either using IAM Roles or Environment Variables.


### Confirm
Go to the logs.
You should see something like
`Processing 0 deposit events in blocks: 3422205 to 3422209` - this is the log that parses the blocks in search of bridging events. That means that relayer up and listening.



## Other

#### To change the number of relayers to deploy
Amount of IDS in array set amount of relayers to be deployed.

#### Relayer shared configuration
Relayer configuration is done with `--config-url` flag on Relayer start and can be changed [here](https://github.com/sygmaprotocol/sygma-relayer-deployment/blob/main/ecs/task_definition_TESTNET.j2#L23)
This flag set-up shared configuration IPNS URL that is used by all Relayers in the MPC network and provided by Sygma.
More on [shared configuration]() <-- TODO add a link when shared config doc is ready

#### Add a new domain
Add one more [DOM config](https://github.com/sygmaprotocol/devops/blob/main/relayers/ecs/task_definition-TESTNET.j2#L67)

