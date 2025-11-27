#!/bin/bash
# eCryptFS Menu Script (c) J~Net 2025
#
# https://jnet.forumotion.com/t2161-ecryptfs-linux-folder-encryption#3331
#
# ./crypt.sh
#
#
#
defaultmount="$HOME/vault"
defaultenc="$HOME/vault.encrypted"
cipher="aes"
keybytes="32"
filenamecrypto="yes"
passthrough="no"

# Check for eCryptFS 
if [ ! -x /sbin/mount.ecryptfs ]; then
    echo "eCryptFS not found. Installing..."
    sudo apt install -y ecryptfs-utils
    if [ ! -x /sbin/mount.ecryptfs ]; then
        echo "ERROR: eCryptFS failed to install."
        exit 1
    fi
fi

    
pause() {
    echo
    echo "Press Enter to return to menu..."
    read xyz
}

ask_paths() {
    echo "Enter mount folder (default=$defaultmount):"
    read mountdir
    [ -z "$mountdir" ] && mountdir="$defaultmount"

    if [[ "$mountdir" == "$defaultmount" ]]; then
        encdir="$defaultenc"
    else
        encdir="${mountdir}.encrypted"
    fi
}

mount_E_folder() {
    ask_paths

    if [[ "$encdir" == "$mountdir" ]]; then
        echo "ERROR: Encrypted folder and mountpoint cannot be the same!"
        echo "Encrypted must be: $mountdir.encrypted"
        pause
        return
    fi

    mkdir -p "$encdir" "$mountdir"

    echo "Passphrase:"
    read -s pw

    echo "Mounting..."
    sudo mount -t ecryptfs "$encdir" "$mountdir" \
    -o ecryptfs_cipher=$cipher \
    -o ecryptfs_key_bytes=$keybytes \
    -o ecryptfs_enable_filename_crypto=$filenamecrypto \
    -o ecryptfs_passthrough=$passthrough \
    -o key=passphrase:passphrase_passwrd="$pw" \
    -o ecryptfs_unlink_sigs \
    -o ecryptfs_sig_cache_filename=/root/.ecryptfs/sig-cache.txt

    echo
    echo "Mounted successfully!"
    echo "Decrypted (visible) files: $mountdir"
    echo "Encrypted (scrambled) files stored at: $encdir"
    echo
    echo "When you unmount, ONLY the encrypted folder will remain."
    pause
}

unmount_folder() {
    ask_paths

    echo "Unmounting $mountdir ..."
    sudo umount "$mountdir"

    echo
    echo "=== UNMOUNTED SUCCESSFULLY ==="
    echo
    echo "Encrypted files are here:"
    echo "   $encdir"
    echo
    echo "This folder now contains ONLY unreadable encrypted content."
    echo
    echo "The mount folder (decrypted view) is:"
    echo "   $mountdir"
    echo "It should now appear EMPTY or back to normal."
    echo
    echo "If you STILL see decrypted files in $mountdir:"
    echo "- You mounted incorrectly"
    echo "- OR the folder was never really mounted"
    echo
    echo "Correct structure:"
    echo "   $encdir        <-- encrypted storage"
    echo "   $mountdir      <-- empty unless mounted"
    pause
}

delete_folders() {
    ask_paths

    echo "Checking mount status..."
    if mount | grep -q "on $mountdir type ecryptfs"; then
        echo "Folder is mounted. Unmount before deleting."
        pause
        return
    fi

    echo
    echo "DELETE folders:"
    echo "Encrypted: $encdir"
    echo "Mountpoint: $mountdir"
    echo "Are you sure? (yes/no)"
    read ok
    if [ "$ok" == "yes" ]; then
        rm -rf "$encdir" "$mountdir"
        echo "Deleted."
    else
        echo "Cancelled."
    fi
    pause
}

while true; do
    clear
    #echo "=== eCryptFS Menu ==="
    echo "=== EcrytptFS Menu By J~Net 2025 ==="
    echo "1) Mount/Create Encrypted Folder"
    echo "2) Unmount Encrypted Folder"
    echo "3) Delete Encrypted Folder"
    echo "4) Quit"
    echo
    echo -n "Choose: "
    read c
    case $c in
        1) mount_E_folder ;;
        2) unmount_folder ;;
        3) delete_folders ;;
        4) exit 0 ;;
        *) sleep 1 ;;
    esac
done

