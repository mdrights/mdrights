#!/bin/bash
# My script for spotting those hosts brutally attacking my VPS, intervally.
# I am tring to improve this script with more functions.
# On Feb 16, 2016.


DIR="/var/www"
TXT="who-attacks-me.html"
HOST=$(hostname)

if [ -f $DIR/$TXT ]; then
	mv $DIR/$TXT $HOME/attack-ip-archive-$(date).txt
fi

echo "<html>
<head>
<meta charset="UTF-8" />
</head>
<body>
<hr>
<h4>Fetched on $(date). 
<h2>看看都有谁尝试了暴力登录我的服务器：
$HOST
</h2>
<br />
<h5>
" > $DIR/$TXT

# egrep -a -o '(ssh)(.*)(Invalid)(.*)([0-9]{1,3}[\.]){3}[0-9]{1,3}' /var/log/auth.log >> $DIR/$TXT 

IP=/tmp/temp1.txt

egrep -a '(ssh)(.*)(Invalid)(.*)([0-9]{1,3}[\.]){3}[0-9]{1,3}' /var/log/auth.log > $IP 

while read line
do
    echo ${line} >> $DIR/$TXT
    echo "<br />" >> $DIR/$TXT 
done < $IP

echo "
</h5>
<h4>Fetched on $(date). 
</h4>
</body>
</html>
" >> $DIR/$TXT

echo "done!"
rm $IP
echo

exit
