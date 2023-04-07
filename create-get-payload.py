# Python program to generate an AWS CLI command line invocation of the Pets lambda get function.

finalPayStr = ""
payload = {}

payload['id'] = input("Enter unique id: ")


for key, value in payload.items():
    finalPayStr += f'"{key}": "{value}", '

finalPayStr = finalPayStr[:-2]

print(f"aws lambda invoke --function-name pyfun_get --payload '{{ {finalPayStr} }}' response.json")
