(use-modules
 (gnu home)
 (gnu services)
 (gnu packages)
 (gnu home services shells)
 (guix gexp)
 )

(home-environment
 (services
  (append (list
    (service home-fish-service-type 
      (home-fish-configuration (config
	(list (local-file
	  "files/config.fish"
	))
      ))
    )
  ))
 )
) 
