(use-modules (gnu) (guix) (guix packages) (srfi srfi-1)
(use-service-modules mcron)
(use-package-modules certs)

(operating-system
  (host-name "wsl")
  (timezone "America/New_York")
  (locale "en_US.utf8")
  (kernel hello)
    (initrd (lambda* (. rest) (plain-file "dummyinitrd" "dummyinitrd")))
    (initrd-modules '())
    (firmware '())
  (bootloader
    (bootloader-configuration
      (bootloader
        (bootloader
          (name 'dummybootloader)
          (package hello)
          (configuration-file "/dev/null")
          (configuration-file-generator (lambda* (. rest) (computed-file "dummybootloader" #~(mkdir #$output))))
          (installer #~(const #t))))))
  (file-systems (list (file-system
                        (device "/dev/vda")
                        (mount-point "/")
                        (type "ext4")
                        (mount? #t))))
  (users (cons (user-account
                (name "kracken")
                (comment "Kracking hashes")
                (group "users")
                (supplementary-groups '("wheel")))
               %base-user-accounts))
  (packages
    (append
      (list
      xf86-video-amdgpu
      sshfs
      xorg-server-xwayland
      )
  %my-base-packagess))
  (services
    (append
      (list (service login-service-type my-motd)
            (service network-manager-service-type)
            (service openssh-service-type)
            (service unattended-upgrade-service-type)
      %base-services))))

;;; wsl-config.scm ends here
