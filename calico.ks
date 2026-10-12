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
%include fedora-live-xfce.ks

%packages
%end

%post
# xfce configuration
cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

sed -i 's/^livesys_session=.*/livesys_session="xfce"/' /etc/sysconfig/livesys

for f in /etc/os-release /usr/lib/os-release; do
    [ -f "$f" ] || continue
    sed -i --follow-symlinks \
        -e 's/^NAME=.*/NAME="Calico Linux"/' \
        -e 's/^PRETTY_NAME=.*/PRETTY_NAME="Calico Linux"/' "$f"
done
%end
