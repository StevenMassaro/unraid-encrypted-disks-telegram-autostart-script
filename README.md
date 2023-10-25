# unRAID Encrypted Disks Telegram Autostart Script
When added to the 'go' file on your unRAID server, starting the server will send a Telegram message requesting the disk encryption key. After receiving the message, the server will decrypt the disks and continue startup.

## Usage
This script assumes that you've configured Telegram as a notification provider on your unRAID server, and that you have some encrypted disks on your server.

1. Copy the contents of `startup.sh` to `/boot/config/go` on your unRAID server.

Restart unRAID server. This should send a Telegram message to your preconfigured chat asking for the disk encryption key.

## Motivation
I wanted a sort of two-factor authentication when starting up my server. I certainly didn't want to keep the disk encryption key on the server, and I'd previously used the [Google Drive method for autostarting](https://benrhine.com/blog/howto-autostart-encrypted-unraid-array/), but I also wasn't a huge fan of that because it didn't provide any kind of verification. Someone could steal the server, and if you didn't think to delete the key from your Google Drive, they'd be able to start your server. I believe this solution will mitigate that risk.