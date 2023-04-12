import subprocess
import re

cmd1 = "terraform output"

cmd_output = subprocess.check_output(cmd1, shell = True)
print (cmd_output)
print (cmd_output.decode())

urlRegex = re.compile(r'https://.*stage')

# ie. https://hostname.execute-api.region.amazonaws.com/function-stage
url = urlRegex.search(cmd_output.decode()).group()

cmd1 = f"curl {url}/pet?id=501"
cmd_output = subprocess.check_output(cmd1, shell = True)

# {"message":"Not Found"}
print (cmd_output.decode())

