#! @bash@/bin/sh -e

export PATH=/empty
for i in @path@; do PATH="$PATH:$i/bin:$i/sbin"; done

DEFAULT=$1
if test -z "$DEFAULT"; then
    echo "usage: efistub-builder.sh <default-config>"
    exit 1
fi

getEfiFile() {
    echo "$EFI_DIR/$(echo "$1" | sed 's,^/nix/store/,,' | sed 's,/,-,g')"
}

getEfiPath() {
    echo "$1" | sed 's,@efiSysMountPoint,,' | sed 's,/,\\,g'
}

EFI_DIR="@efiSysMountPoint@/EFI/NixOS"
mkdir -p "$EFI_DIR"

# Manipulating boot entries, if we can use efibootmgr
if test -n "@useEfibootmgr"; then
    # Saving bootorder to restore it later
    bootorder=$(efibootmgr | grep "BootOrder: " | cut -c 12-)

    # Removing all old NixOS boot entries
    for entry in $(efibootmgr | grep "NixOS" | cut -c "5-8"); do
        # Removing entry
        efibootmgr -qBb "$entry"
    done
fi

# Adding all available generations
for generation in $(ls -d /nix/var/nix/profiles/system-*-link | sort -Vr); do
    # Generation number
    num=$(echo "$generation" | cut -d- -f2)
    # Kernel and initramfs
    kernel=$(readlink -f "$generation/kernel")
    initrd=$(readlink -f "$generation/initrd")
    # Copying files to EFI
    kernel_file=$(getEfiFile "$kernel").efi
    initrd_file=$(getEfiFile "$initrd")
    cp "$kernel" "$kernel_file"
    cp "$initrd" "$initrd_file"

    # Adding entry, if we can use efibootmgr
    if test -n "@useEfibootmgr"; then
        # Adding system config path flag
        OPTIONS="systemConfig=$(readlink -f "$generation")"
        # Adding init system path flag
        OPTIONS="${OPTIONS} init=$(readlink -f "$generation/init")"
        # Adding user kernel params
        OPTIONS="${OPTIONS} $(cat "$generation/kernel-params")"
        # Adding initramfs flag
        OPTIONS="${OPTIONS} initrd=$(getEfiPath "$initrd_file")"
        efibootmgr -qc \
            -d "@efiDisk@" \
            -p "@efiPart@" \
            -L "NixOS - Generation $num" \
            -l "$(getEfiPath "$kernel_file")" \
            -u "${OPTIONS}"
    fi
done

# Restoring boot order, if we can use efibootmgr
if test -n "@useEfibootmgr"; then
    efibootmgr -qo "$bootorder"
fi
