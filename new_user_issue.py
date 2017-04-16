import sys
from github import Github

token_file = "/home/clifford/.gissues/token.txt"
user = 'cliffordsnow'
user_repo = 'newUsers'

try:
   t = open(token_file,"r")
except IOError:
   print("Error: Token File missing")
   return 0

token = str(t.read())[:-1]

g = Github(token)

user = g.get_user(user)
repo = user.get_repo(user_repo)

changeset = 'Changeset = https://osm.org/changeset/' + str(sys.argv[1])
user = str(sys.argv[2]) +' https://osm.org/user/' + str(sys.argv[2]).replace(" ","%20")
comment = 'Comment: ' + str(sys.argv[3])
location = str(sys.argv[4])

title = str(sys.argv[2]) + " just started editing"
body = changeset + '\n' + user + '\n' + comment + '\nNear: ' + location + '\n'

newissue = repo.create_issue(title, body)


