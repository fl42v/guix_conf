(use-modules 
  (gnu)
)
(use-service-modules desktop networking ssh)

(define (auto-login-to-tty config tty user)
  (if (string=? tty (mingetty-configuration-tty config))
        (mingetty-configuration
         (inherit config)
         (auto-login user))
        config))

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Moscow")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "Behemoth")

  (kernel-arguments (append
    '("modprobe.blacklist=mei_me") ;; who the fuck needs management engine anyways?
  %default-kernel-arguments))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "fl42v")
                  (comment "Fl42V")
                  (group "users")
                  (home-directory "/home/fl42v")
		  (shell "/run/current-system/profile/bin/fish")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "seat")))
                %base-user-accounts))

  (packages (append (map specification->package '(
      "bluez"
      "fish"
      "foot"
      "librewolf"
      "neovim"
      "ripgrep"
      "swayfx"
      "wofi"
  )) %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services (append
    (modify-services %base-services
      (mingetty-service-type config => (auto-login-to-tty config "tty1" "fl42v")))
    (list
      (service bluetooth-service-type)
      (service network-manager-service-type)
      (service ntp-service-type)
      (service openssh-service-type)
      (service seatd-service-type)
      (service wpa-supplicant-service-type)
    )
  ))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)
		(timeout 0)))
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "f9eb6e5a-81c2-43f5-b2bc-2e0e94d63f50"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "9AC1-E7A5"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
