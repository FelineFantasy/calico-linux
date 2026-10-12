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

# motd, issue and shell banner
BANNER='Welcome to Calico Linux! 🐾
Meow!
'

printf '%s' "$BANNER" > /etc/motd
printf '%s' "$BANNER" > /etc/issue
printf '%s' "$BANNER" > /etc/issue.net

mkdir -p /etc/profile.d
cat > /etc/profile.d/calico-motd.sh <<'EOF'
if [ -n "$PS1" ] && [ -z "$CALICO_MOTD_SHOWN" ]; then
    export CALICO_MOTD_SHOWN=1
    printf 'Welcome to Calico Linux! 🐾\nMeow!\n'
fi
EOF
chmod 0644 /etc/profile.d/calico-motd.sh

%end
