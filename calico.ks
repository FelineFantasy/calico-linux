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

# brand os-release without touching ID, VERSION_ID or VERSION_CODENAME
for f in /etc/os-release /usr/lib/os-release; do
    sed -i 's/^NAME=.*/NAME="Calico Linux"/' "$f"
    sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Calico Linux"/' "$f"
done

echo -e "Welcome to Calico Linux! 🐾\nMeow!" > /etc/motd

%end
