# calico.ks
#
# Description:
# - Fedora Live Spin with the light-weight XFCE Desktop Environment,
#   rebranded as Calico Linux.
#
# Maintainer(s):
# - Calico Linux maintainers
#
# Note: do NOT redefine `part /` here — fedora-live-base.ks already
# declares it. Overriding causes livecd-creator/livemedia-creator to fail.

%include /tmp/ks/fedora-live-xfce.ks

%packages
fastfetch
-aajohan-comfortaa-fonts
-adwaita-mono-fonts
-adwaita-sans-fonts
-alsa-sof-firmware
-bash-color-prompt
-gawk-all-langpacks
-gdouros-symbola-fonts
-geolite2-city
-geolite2-country
-google-noto-emoji-fonts
-mailcap
-microcode_ctl
-mint-y-theme
-nvidia-gpu-firmware
-nxpwireless-firmware
-open-sans-fonts
-qcom-wwan-firmware
-realtek-firmware
-rootfiles
-tiwilink-firmware
-words
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
