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

%include fedora-live-base.ks
%include fedora-live-minimization.ks
%include fedora-xfce-common.ks

%packages
kitty
fastfetch
%end

%post
%end
