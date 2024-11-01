if test (tty) = "/dev/tty1"
  export XDG_RUNTIME_DIR=/tmp/xdg_runtime_dir
  mkdir -p $XDG_RUNTIME_DIR	
  exec sway
end
