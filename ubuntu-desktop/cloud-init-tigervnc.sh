#!/bin/bash
apt update

myuser="emcconne"
mypasswd="ChangePassIShould!"
vncpasswd="letmein"

id -u $myuser > /dev/null 2>&1; rc=$?
if [[ $rc -ne 0 ]]; then
    useradd -m -p $(openssl passwd $mypasswd) $myuser
fi

if [ ! -d /home/$myuser/.vnc ]; then
    mkdir /home/$myuser/.vnc
    echo $vncpasswd | vncpasswd -f > /home/$myuser/.vnc/passwd
    chmod 0600 /home/$myuser/.vnc/passwd
fi

cat << EOF > /home/$myuser/.vnc/xstartup
#!/bin/sh
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-window-manager &
startxfce4 
EOF

USER_CONFIG=/home/$myuser/.config
USER_SYSTEMCTL=$USER_CONFIG/systemd/user
mkdir -p $USER_SYSTEMCTL/default.target.wants

cat << EOF > "$USER_SYSTEMCTL/tigervnc.service"
[Unit]
Description=Remote desktop service (VNC)

[Service]
Type=simple
PIDFile=/home/%u/.vnc/%H%i.pid
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :1 > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :1 -geometry 1920x1080 -alwaysshared -fg
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=default.target
EOF

ln -s $USER_SYSTEMCTL/tigervnc.service $USER_SYSTEMCTL/default.target.wants/tigervnc.service
chown -R $myuser:$myuser $USER_CONFIG
chmod 0755 /etc/systemd/user/tigervnc.service
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0700 /home/$myuser/.vnc/xstartup
echo "Done"
