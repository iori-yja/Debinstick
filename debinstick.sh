#!/bin/bash

umount $1
if ! syslinux $1;then
	echo "Please install syslinux and come again;)"
	exit
fi

echo "Do you want me to stay files in currentdir/dbinstk I get from internet(if you've narrow internet,Y)?[y/N]"
read stayn

if [ "$stayn" = "N" ]||[ "$stayn" = "$NULL" ]||[ "$stayn" = "n" ];then
	templac=`mktemp -d`
	mount $1 $templac
	cd $templac
elif [ "$stayn" = "y" ]||[ "$stayn" = "Y" ];then
if cd dbinstk;then
	if ls vmlinuz && ls initrd.gz;then
		echo "Found exist dbinstk files. Use it?[Y/n]"
		read existuse
		if [ "$existuse" = "$NULL" ]||[ "$existuse" = "Y" ]||[ "$existuse" = "y" ];then
			echo "OK. I will save your internet resource."
			mkdir /media/dbinstk
			mount $1 /media/dbinstk
			cp * /media/dbinstk
			exit
		else rm vmlinuz initrd.gz
		fi
	fi
else mkdir dbinstk;cd dbinstk
fi
fi

echo "Work dir is `pwd`"
installerimage="ftp://ftp.jaist.ac.jp/pub/Linux/Debian/dists/squeeze/main/installer-"
installerdir="current/images/hd-media/"
echo "Which architecture do you prefer(in case not sure,'l')?"
read arc
while ! ([ "$arc" = "amd64" ]||[ "$arc" = "i386" ]||[ "$arc" = "powerpc" ]||[ "$arc" = "s390" ]||[ "$arc" = "sparc" ]);do
	echo "possible is amd64 i386 powerpc"
read arc
done
if [ "$arc" = "powerpc" ];then
instlrdir="wget ${installerimage}${arc}/current/images/powerpc/hd-media/"
wget ${instlrdir}vmlinux
wget ${instlrdir}initrd.gz
else
instlrdir="${installerimage}${arc}/${installerdir}"
wget ${instlrdir}vmlinuz
wget ${instlrdir}initrd.gz
fi
if [ "$stayn" = "Y" ]||[ "$stayn" = "y" ];then
	mkdir /media/dbinstk
	mount $1 /media/dbinstk
	cp * /media/dbinstk
fi

