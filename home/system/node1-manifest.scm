;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
  (list "calibre"
        "emacs-next-gcc-no-x"
        "podman"
        "qemu"
        "rclone"
        "my-rtorrent"
        "sshfs"
))

;;; node1-manifest.scm ends here
