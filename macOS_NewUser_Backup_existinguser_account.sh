
################################################
##LOCAL USER CREATION AND EXISTING USER BACKUP##
################################################

##CREATING LOCAL USER##

sudo sysadminctl -addUser User -fullName "User" -password qwerty@123 -admin

##ASSIGNING CURRENT USER TO VARIABLE##

currentuser=$(ls -l /dev/console | cut -d " " -f 4)

echo "$currentuser is logged in"

##PERFORM BACKUP##

sudo ditto /Users/$currentuser/Desktop /Users/User/Desktop

sudo ditto /Users/$currentuser/Downloads /Users/User/Downloads

sudo ditto /Users/$currentuser/Documents /Users/User/Documents 


##FILEVAULT PERMISSION TO USER##

sysadminctl -adminUser User -adminPassword qwerty@123 -secureTokenOn User -password qwerty@123


##DISPLAY NOTIFICATION##

osascript -e 'display notification "User creation and Backup completed, please login to the new user"'

dialog="User creation and Backup has been completed, please login with the new user"
jamf displayMessage -message "$dialog"