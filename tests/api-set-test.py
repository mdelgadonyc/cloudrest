import subprocess
import re

cmd1 = "terraform output"

cmd_output = subprocess.check_output(cmd1, shell = True)
print (cmd_output)
print (cmd_output.decode())

urlRegex = re.compile(r'https://.*stage')

# ie. https://hostname.execute-api.region.amazonaws.com/function-stage
url = urlRegex.search(cmd_output.decode()).group()

cmd1 = f'curl -X POST {url}/pet -H \'Content-Type: application/json\' -d \'{{ "id": "1234", "name": "biscuit", "breed": "pug", "gender": "female", "owner": "allen ginsberg", "birthday": "10/2/2020" }}\''

cmd_output = subprocess.check_output(cmd1, shell = True)
recSetRegex = re.compile(r'Record 1234 added')
print (recSetRegex.search(cmd_output.decode()).group())

cmd1 = f"curl {url}/pet?id=1234"
cmd_output = subprocess.check_output(cmd1, shell = True)
recGetRegex = re.compile(r'ginsberg')
print (recGetRegex.search(cmd_output.decode()).group())
