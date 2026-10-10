# calico.ks
#
# Description:
# - Fedora Live Spin with the light-weight XFCE Desktop Environment,
#   rebranded as Calico Linux.
#
# Maintainer(s):
# - Calico Linux maintainers

%include fedora-live-base.ks
%include fedora-live-minimization.ks
%include fedora-xfce/fedora-xfce-common.ks

# need a bigger /
part / --size 8192

%packages
kitty
fastfetch
%end

%post
# xfce configuration

# create /etc/sysconfig/desktop (needed for installation)

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

# set livesys session type
sed -i 's/^livesys_session=.*/livesys_session="xfce"/' /etc/sysconfig/livesys

sed -i 's/Fedora/Calico Linux/g' /etc/os-release
sed -i 's/Fedora/Calico Linux/g' /usr/lib/os-release

echo -e "Welcome to Calico Linux! 🐾\nMeow!" > /etc/motd

%end
