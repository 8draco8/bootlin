#!/bin/sh

convertImage () {
	hdiutil convert -format UDRW -o $1 $1
}

createBootableUSB () {
	echo "To create bootable USB drive I need ROOT privileges. Please provide your password."
	echo "After providing the password dd command will run. Unfortunatelly dd DOES NOT have any progress bar so despite the fact that nothing is showed, the script actually works, please be patient."
	sudo dd if=$1.dmg of=/dev/r$2 bs=1m
}

regex='^.*\.iso$'

if [[ $1 =~ $regex ]]; 
	then
		echo "$1 will be use to create bootable USB"
		echo "Please select target USB drive by typing in IDENTIFIER of your USB drive (eg. disk1):"
		diskutil list
		read driveName
		driveRegex='^drive0?.*$'
		if [[ $driveName =~ $driveRegex ]]; 
			then
			echo "Can't use $driveName"
			exit
		fi
		echo "Are you sure that you want to use $driveName as bootable USB? All data on the device will be erased! [Y/n]"
			read driveQuestion
			if [[ $driveQuestion == "Y" ]] || [[ $driveQuestion == "y" ]] || [[ $driveQuestion == "yes" ]]; 
				then
				echo "Unmounting $driveName"
				umount $driveName | cut -c1-5
				echo "Converting $1 to DMG format:"
				convertImage $1
				echo "Creating bootable USB on $driveName"
				createBootableUSB $1 $driveName | cut -c1-5
			elif [[ $driveQuestion == "N" ]] || [[ $driveQuestion == "n" ]] || [[ $driveQuestion == "no" ]]; 
				then
				echo no
			else
				exit
			fi
	else
		echo "Provided file is not in ISO format!"
		exit
fi