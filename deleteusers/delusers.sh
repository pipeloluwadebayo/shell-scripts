#!/bin/bash

# This script disables, deletes and /or archives users on the local system
# Run as root

# Create a constant variable which is the file to archive the home directories
readonly ARCHIVE_DIR='/archive'

# The usage function gives information about the script if invalid options are passed to the command line

usage() {
# Display the usage and exit
	echo "Usage: ${0} [-dra] USER...[USERN]" >&2
	echo 'Disable local user account' >&2
	echo '	-d Deletes the account' >&2
	echo '	-r Removes the home directory for the account(S)' >&2
	echo '	-a Archives the home directory for the account(s)' >&2
	exit 1
}

# The check function checks if the previous operation was successful
check() {
	if [[ "${?}" -ne 0 ]]
	then
		echo 'The operation was not successful'
		exit 1
	else
		echo 'The operation was successfuly completed'
	fi
}

# Ensure the script is run as root
if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run as root' >&2
	exit 1
fi

# Parse the command line options
while getopts dra OPTION
do
	case ${OPTION} in
		d) DELETE_USER='true' ;;
		r) REMOVE_DIR='-r' ;;
		a) ARCHIVE='true' ;;
		?) usage ;;
	esac
done

# Remove the options while leaving the rest of the arguments
shift "$(( OPTIND -1 ))"

# If at least one argument is not supplied, provide help

if [[ "${#}" -lt 1 ]]
then
	usage
fi

# Loop through the usernames supplied as arguments
for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"

# Make sure the user supplied is not a system user and the account UID is at least 1000
	USERID=$(id -u ${USERNAME})
	if [[ "${USERID}" -le 1000 ]]
	then
		echo "Refusing to remove user ${USERNAME} with UID ${USERID}" >&2
		echo 'Check with your system administrator'
		exit 1
	fi
 
# Create an archive if the option'a' is supplied	
	if [[ "${ARCHIVE}" = 'true' ]]
	then

# Create the archive directory if it does not exist,
		if [[ ! -d "${ARCHIVE_DIR}" ]]
		then
			echo "Creating ${ARCHIVE_DIR} directory"
			mkdir -p ${ARCHIVE_DIR}
			check
		fi
# Archive and move the users home directory
		HOME_DIR="/home/${USERNAME}"
		ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
		if [[ -d "${HOME_DIR}" ]]
		then
			echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
			tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
			check
		else
			echo "${HOME_DIR} does not exist or is not a directory." >&2
			exit 1
		fi
	fi
	if [[ "${DELETE_USER}" = 'true' ]]
	then
# Delete the user
		userdel ${REMOVE_DIR} ${USERNAME}
# Check if the operation succeeded
		check
	else
		chage -E 0 ${USERNAME}
		check
	fi
done
exit 0
