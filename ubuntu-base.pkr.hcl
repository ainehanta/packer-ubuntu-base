packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "ubuntu-base" {
  http_directory   = "http"
  output_directory = "output"
  vm_name          = "packer-ubuntu-base.qcow2"

  iso_url      = "https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
  iso_checksum = "sha256:b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"

  cpus             = 8
  memory           = 4096
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "1h"

  // for efi
  // boot_command      = [
  //       "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
  //       "e<wait>",
  //       "<down><down><down><end>",
  //       " autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
  //       "<f10>"
  //     ]
  // for bios
  boot_command = [
    "<esc><esc><esc>",
    "<enter><wait>",
    "/casper/vmlinuz ",
    "root=/dev/sr0 ",
    "initrd=/casper/initrd ",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "ipv6.disable=1 ",
    "<enter>"
  ]
  boot_wait = "3s"

  headless = false
  display  = "cocoa"
}

build {
  sources = ["source.qemu.ubuntu-base"]
}
