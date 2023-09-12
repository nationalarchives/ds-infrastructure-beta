import boto3
import datetime

def private_beta_docker_deployment(event, context):
    script = """
    echo "Hello World!" > /home/ec2-user/helloworld.txt
    pwd >> /home/ec2-user/helloworld.txt
    """
    #Define the tag possessed by the EC2 instances that we want to execute the script on
    tag = 'private-beta-dw'

    ec2_client = boto3.client("ec2", region_name='eu-west-2')
    ssm_client = boto3.client('ssm')

    filtered_instances = ec2_client.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': [tag]}])
    reservations = filtered_instances['Reservations']

    exec_list=[]
    for reservation in reservations:
        for instance in reservation['Instances']:
            print(instance['InstanceId'], " is ", instance['State']['Name'])
            if instance['State']['Name'] == 'running':
                exec_list.append(instance['InstanceId'])

        print("**************")

    response = ssm_client.send_command(
        DocumentName ='AWS-RunShellScript',
        Parameters = {'commands': [script]},
        InstanceIds = exec_list
    )

    #See the command run on the target instance Ids
    print(response['Command']['Parameters']['commands'])
