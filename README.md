# eCryptFS Bash Menu – Folder Encryption  
(c) J~Net 2025

A simple, clean Bash menu for creating, mounting, unmounting and deleting encrypted folders using **eCryptFS**.  
Ideal for Linux users who want Encrypted=Scrambled files and a MountDir=Readable view.

Supports:
- Auto-install of `ecryptfs-utils` if missing  
- Auto paths (`~/vault` + `~/vault.encrypted`)  
- Custom user paths  
- AES encryption (fully non-interactive, no prompts)  
- "Press Enter to continue" feedback  
- Clear explanation of encrypted vs decrypted folders  

---

## **Installation (Ubuntu Noble and later)**

Ubuntu Noble does **not** have a package named `ecryptfs`.  
The correct package is:

sudo apt install -y ecryptfs-utils



---

## **Manual Usage (No Script)**

Create folders:

mkdir -p ~/vault



Mount encrypted folder:

sudo mount -t ecryptfs ~/vault ~/vault


Unmount:

sudo umount ~/vault



This is the same method the script uses internally.

---

## **Run the Script**

Make executable and run:

chmod +x crypt.sh
./crypt.sh


### **Menu Options**
Mount/Create Encrypted Folder

Unmount Encrypted Folder

Delete Encrypted Folder


Default folder:
- Decrypted visible view: `~/vault`
- Encrypted scrambled files: `~/vault.encrypted`

If you choose any other path, encrypted data becomes:
/your/path (decrypted when mounted)
/your/path.encrypted (actual encrypted storage)


---

## **How eCryptFS Works (Important!)**

You ALWAYS end up with **two folders**:

### **Decrypted View (Readable)**
Example:
~/vault


Shows real readable files **ONLY while mounted**.

### **Encrypted Storage (Scrambled Gibberish)**
Example:
~/vault.encrypted


This contains only encrypted files (random-looking junk).

When you unmount, **only the encrypted folder remains**.

---

## **Recommended Interactive Options (Manual Mount)**

When using interactive mode:

Select cipher: aes
Select key bytes: 24 (AES-192 recommended)
Enable plaintext passthrough: n
Enable filename encryption: y


Filename encryption protects file **names** as well as contents.

---

## **Fully Non-Interactive Auto-Mount Options**

If you want ZERO prompts, this is what the script uses:

-ecryptfs_cipher=aes
-ecryptfs_key_bytes=32
-ecryptfs_passthrough=no
-ecryptfs_enable_filename_crypto=yes


Add to any `mount -t ecryptfs` command to skip questions.

---

## **Example Auto-Mount Syntax**

sudo mount -t ecryptfs ENC_DIR MOUNT_DIR
-o ecryptfs_cipher=aes
-o ecryptfs_key_bytes=32
-o ecryptfs_enable_filename_crypto=yes
-o ecryptfs_passthrough=no
-o key=passphrase:passphrase_passwrd=YOURPASS
-o ecryptfs_unlink_sigs
-o ecryptfs_sig_cache_filename=/root/.ecryptfs/sig-cache.txt


---

## **Script Repository**

GitHub:  
https://github.com/jamieduk/EcryptFS-Bash-Linux-Menu-Folder-Encryption/

Forum Thread:  
https://jnet.forumotion.com/t2161-ecryptfs-linux-folder-encryption#3331

---

## **Notes**

- You **must unmount** before deleting.  
- The encrypted folder (`.encrypted`) is the **only place** that stores your secure data.  
- The mount folder should appear **empty** after unmounting.  
- If readable files remain, the folder was not mounted correctly.

---

(c) J~Net 2025
