#!/bin/bash

# This script creates a user on the local system
# Requirements:
# -username
# -full name
# -password
# The username, password and host for the account will be displayes
# The user will be prompted to change their password on first login

# Ensure script is executed with superuser privileges

if [[ ${UID} -ne 0 ]]
then 
	echo "Please run as user or as root"
	exit 1
fi

# Prompt for username
read -p 'Enter your username: '  USER_NAME

# Prompt for real name
read -p 'Enter your fullname: ' FULL_NAME

# Prompt for password
read -sp 'Enter your password: ' PASSWORD
echo

echo 'You will be prompted to set a new password on your first login'

# Create account
useradd -c "${FULL_NAME}" -m ${USER_NAME}

# Check if useradd command succedded
if [[ "${?}" -ne 0 ]]
then
	echo 'The account could not be created.'
	exit 1
fi

# Set the password
echo ${PASSWORD} | passwd --stdin ${USERNAME}

# Check if passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo 'The password could not be set'
	exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Set password to expire after 30 days(both the chage and passwd commands can be used to achieve this)
#chage -M 30 ${USER_NAME}

passwd -x 30 ${USER_NAME}

# Set 7 days warning for password expiry 
#chage -W 7 ${USER_NAME}

passwd -w 7 ${USER_NAME}

# Display user information

echo 
echo 'Username:'
echo "${USER_NAME}"
echo
echo 'Fullname:'
echo "${FULL_NAME}"
echo
echo 'Password:'
echo "${PASSWORD}"
echo
echo 'Host:'
echo "${HOSTNAME}"
echo
echo 'Your password will expire in 30 days and you will need to set a new password'
echo
echo 'You will receive a warning 7 days before your password expires'
echo
chage -l ${USER_NAME}
exit 0
