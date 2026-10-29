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

# Rebuild the live initramfs.
#
# In containerised builds dracut can fail while handling kernel-core in
# %posttrans.  livecd-tools only logs "No initramfs or initrd found" in that
# case and happily builds the ISO without /isolinux/initrd0.img, which
# produces media that cannot boot.  Rebuild it here so the image always ships
# a matching initramfs; the dmsquash-live modules come from
# /etc/dracut.conf.d/99-liveos.conf, which livecd-tools has already written by
# the time %post runs.
kernelver=$(ls -1 /lib/modules | sort -V | tail -n1)
if [ -z "$kernelver" ]; then
    echo "calico: no kernel found in /lib/modules, cannot build initramfs" >&2
    exit 1
fi

# livecd-tools asks dracut for a fixed driver list written for much older
# kernels.  dracut treats a missing module as fatal, and names such as ide_cd
# no longer exist, so drop anything this kernel does not ship.
liveos_conf=/etc/dracut.conf.d/99-liveos.conf
if [ -f "$liveos_conf" ]; then
    drivers=$(sed -n 's/^add_drivers+[[:space:]]*=[[:space:]]*"\(.*\)"[[:space:]]*$/\1/p' "$liveos_conf")
    if [ -n "$drivers" ]; then
        kept=""
        for drv in $drivers; do
            case "$drv" in
                # dracut-install rejects bare group names.  livecd-tools uses
                # "=ata" for the legacy IDE/PATA controllers but forgets to
                # expand it, so do it here.
                =ata) candidates="ata_piix ata_generic" ;;
                =*)   candidates="" ;;
                *)    candidates="$drv" ;;
            esac
            for mod in $candidates; do
                if modinfo -k "$kernelver" "$mod" >/dev/null 2>&1; then
                    kept="$kept $mod"
                else
                    echo "calico: dropping driver '$mod', not present in kernel $kernelver"
                fi
            done
        done
        kept=$(echo $kept)
        sed -i "/^add_drivers+/d" "$liveos_conf"
        printf 'add_drivers+=" %s "\n' "$kept" >> "$liveos_conf"
    fi
fi

initramfs="/boot/initramfs-${kernelver}.img"
if ! dracut --force --no-hostonly "$initramfs" "$kernelver"; then
    echo "calico: dracut failed to build $initramfs" >&2
    exit 1
fi

if [ ! -s "$initramfs" ]; then
    echo "calico: $initramfs is missing or empty" >&2
    exit 1
fi

if ! lsinitrd "$initramfs" | grep -q 'dmsquash-live'; then
    echo "calico: $initramfs has no dmsquash-live support, the ISO would not boot" >&2
    exit 1
fi
%end

%post --nochroot --erroronfail
# livecd-tools calls _create_bootconfig() in configure() *before* running the
# %post scripts, so the initramfs built above is never copied into the ISO on
# its own.  It also sets base_on = True unconditionally, which suppresses its
# "No initramfs or initrd found" message, so the result was a silently broken
# ISO.  Stage the freshly built initramfs into the ISO tree here.
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

kernelver=$(ls -1 "$INSTALL_ROOT/lib/modules" 2>/dev/null | sort -V | tail -n1)
initramfs="$INSTALL_ROOT/boot/initramfs-${kernelver}.img"

if [ -z "$kernelver" ] || [ ! -s "$initramfs" ]; then
    echo "calico: cannot stage isolinux/initrd0.img, $initramfs is missing or empty" >&2
    exit 1
fi

if [ ! -d "$LIVE_ROOT/isolinux" ]; then
    echo "calico: ISO tree not found at $LIVE_ROOT/isolinux" >&2
    exit 1
fi

install -m 0644 "$initramfs" "$LIVE_ROOT/isolinux/initrd0.img"
size=$(stat -c%s "$LIVE_ROOT/isolinux/initrd0.img")
echo "calico: staged isolinux/initrd0.img ($size bytes) from $initramfs"
if [ "$size" -lt 10000000 ]; then
    echo "calico: staged initrd0.img is only $size bytes, refusing to publish" >&2
    exit 1
fi
%end
