(use-modules (gnu) (guix) (guix packages) (srfi srfi-1))
(use-service-modules desktop mcron networking shepherd spice ssh virtualization xorg)
(use-package-modules bootloaders certs fonts package-management wget)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us" "ru"))
  (host-name "dev")
  (users (cons* (user-account
                  (name "khaoz")
                  (comment "KHAOZ")
                  (group "users")
                  (home-directory "/home/khaoz")
                  (supplementary-groups
                    '("audio" "kvm" "netdev" "video" "wheel")))
                %base-user-accounts))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid ""))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "bcachefs")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "" 'fat32))
             (type "vfat"))
           %base-file-systems))
  (packages
    (append
      (list
        bluez
        dbus
        emacs-with-native-comp
        emacs-exwm
        fontconfig
        piperwire
        spice-vdagent
        xf86-video-amdgpu
        xorg-server-xwayland)
 %my-base-packagess))
  (services
    (append
      (list (service autofs-service-type
         (autofs-configuration
          (mounts (list
                   (autofs-mount-configuration
                    (target "/mnt/storage/khaoz")
                    (source ":sshfs\\#node1.home.arpa\\:/mnt/storage/khaoz"))))))

;; mount -t fuse and autofs
(extra-special-file "/bin/sshfs"
                    (file-append sshfs "/bin/sshfs"))
(extra-special-file "/bin/ssh"
                    (file-append openssh "/bin/ssh"))
            (service elogind-service-type)
            (service libvirt-service-type)
            (service login-service-type my-motd)
            (service network-manager-service-type)
            (service openssh-service-type)
            (service spice-vdagent-service-type) ;; Add support for the SPICE protocol, which enables dynamic resizing of the guest screen resolution, clipboard integration with the host, etc.
            (service wpa-supplicant-service-type)
      %base-services))))

;;; dev-config.scm ends here
