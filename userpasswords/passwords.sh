#!/bin/bash

# This script creates a new user on the local system and generates a password for each user
# The username must be supplied as an argument to the script
# A comment (optional) for the account can be suppled
# The script must be executed with root privileges

if [[ "${UID}" -ne 0 ]]
then
	echo "Please run as root or with superuser privileges"
	exit 1
fi

# Prompt the user if no argument is supplied"

if [[ "${#}" -eq 0 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	echo "Please supply a user name and comment(optional)"
	exit 1
fi

# Store the username in a variable
USER_NAME="${1}"

# Any other parameters are account comments
shift
COMMENT="${@}"

# Generate a strong password for the user

CHARACTERS='!@#$%^&*()_-+='

SPECIAL_CHARACTERS=$(echo "${CHARACTERS}" | fold -w3 | shuf | head -c3)
#echo "${SPECIAL_CHARACTERS}"

PASSWORD=$(date +%s%N | sha256sum | head -c9)

USER_PASSWORD="${SPECIAL_CHARACTERS}${PASSWORD}"

#echo "${USER_PASSWORD}"

STRONG_PASSWORD=$(echo "${USER_PASSWORD}" | fold -w1 | shuf | tr -d '\n')
#echo "${STRONG_PASSWORD}"

# Create the user with the password
useradd -c "{COMMENT}"  -m ${USER_NAME}

# Check if user was created successfully using the exit status of the useradd command
if [[ "${?}" -ne 0 ]]
then
	echo 'The account could not be created'
	exit 1
fi

# Set the password
echo ${STRONG_PASSWORD} | passwd --stdin ${USER_NAME}

# Check if passwd command executed successfully
if [[ "${?}" -ne 0 ]]
then
	echo 'The password could not be set'
	exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the information
echo
echo 'Username:'
echo "${USER_NAME}"
echo
echo 'Comment:'
echo "${COMMENT}"
echo
echo 'Password:'
echo "${STRONG_PASSWORD}"
echo
echo 'Host:'
echo "${HOSTNAME}"
exit 0
