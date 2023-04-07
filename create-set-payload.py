# Python program to generate an AWS CLI command line invocation of the Pets lambda set function.

finalPayStr = ""
payload = {}

payload['id'] = input("Enter unique id: ")
payload['name'] = input("Enter dog name: ")
payload['breed'] = input("Enter dog breed: ")
payload['gender'] = input('Enter dog gender: ')
payload['owner'] = input('Enter dog owner name: ')
payload['birthday'] = input('Enter dog birthday: ')

for key, value in payload.items():
    finalPayStr += f'"{key}": "{value}", '

finalPayStr = finalPayStr[:-2]

print(f"aws lambda invoke --function-name pyfun_set --payload '{{ {finalPayStr} }}' response.json")
