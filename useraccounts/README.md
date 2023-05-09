
-This is a shell script that creates user accounts for a linux system.

-The Script enforces that it is executed with superuser privilegs. If not, it will not attempt to create a user and will return an exit status of 1

-The script prompts for the username, fullname and password of the user to be created

-A new user is created. The user will be forced to create a new password on first login.

-If the account could not be created, the user is informed and the script exits with a status code of 1

-The set password expires after 30 days and the user will be given a warning 7 days to expiry

-The script displays the user information( username, fullname, password and host where the account was created)
