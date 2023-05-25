- This script disables users on a local system

- It must be executed with root privileges

- It provides a usage statemnent to guide the user if no argument is supplied on the command line

- Error messages are sent to standard error

- The user is allowed to specify the following options
	- -d Deletes accounts instead of disabling them
	- -r Removes the home directory of the account(s)
	- -a Archives the home directory of the account(s). the archive directory will be created if it does not exist
	- any other invalid option will prompt the script to display the usage guide

- A list of usernames can be supplied as arguments

- The script will not disable accounts that have a UID of less than 1000. This is to protect system accounts from being accidentally disabled.


