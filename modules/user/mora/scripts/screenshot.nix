{ pkgs, ... }:

pkgs.writeShellScriptBin "screenshot" ''
  #!/usr/bin/env bash

  GRIM=${pkgs.grim}/bin/grim
  HYPRCTL=hyprctl
  HYPRPICKER=hyprpicker
  JQ=jq
  NOTIFY_SEND=notify-send
  SLURP=${pkgs.slurp}/bin/slurp
  WL_COPY=wl-copy

  CLIPBOARD_ONLY=
  CURSOR=
  SILENT=

  OUTPUT_DIR=/data/Screenshots
  OUTPUT_FILE=`date +'%Y-%m-%d-%H%M%S.png'`

  # Parsing arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      --clipboard)
        shift # past argument
        CLIPBOARD_ONLY=1
        ;;
      -c | --cursor)
        shift # past argument
        CURSOR=1
        ;;
      -s | --silent)
        shift # past argument
        SILENT=1
        ;;
      -od | --output-dir)
        shift # past argument
        if [ $# -gt 0 ]; then
          OUTPUT_DIR="$1" # assign the next argument to OUTPUT_DIR
          shift           # past argument
        else
          echo "Error: Missing argument for --output-dir option."
          exit 1
        fi
        ;;
      -of | --output-file)
        shift # past argument
        if [ $# -gt 0 ]; then
          OUTPUT_FILE="$1" # assign the next argument to OUTPUT_FILE
          shift            # past argument
        else
          echo "Error: Missing argument for --output-file option."
          exit 1
        fi
        ;;
      *)      # unknown option
        break # done with parsing --flags
        ;;
    esac
  done

  OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_FILE"
  MODE=''${1:-current-monitor}

  # Get current monitor geometry
  function get_current_monitor_geometry() {
    local active_monitor=`$HYPRCTL -j activeworkspace | $JQ -r '.monitor'`
    $HYPRCTL -j monitors | $JQ -r ".[] | select(.name == \"$active_monitor\") | \"\(.x),\(.y) \(.width)x\(.height)\""
  }

  # Get current window geometry
  function get_current_window_geometry() {
    $HYPRCTL -j activewindow | $JQ -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
  }

  # Get all visible window geometries
  function get_all_visible_window_geometries() {
    local monitors=`hyprctl -j monitors`
    local workspaces=`echo $monitors | $JQ -r 'map(.activeWorkspace.id) | join(",")'`
    local clients=`hyprctl -j clients | $JQ -r "[.[] | select(.workspace.id | contains($workspaces))]"`
    echo $clients | $JQ -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
  }

  # Choose one of monitor geometries
  function get_monitor_geometry() {
    $SLURP -b '#000000aa' -or
  }

  # Choose one of visible window geometries
  function choose_visible_window_geometry() {
    $SLURP -b '#000000aa' -r <<< "`get_all_visible_window_geometries`"
  }

  # Get region geometry
  function get_region_geometry() {
    $SLURP -b '#000000aa' -d
  }

  # Send notification that screenshot was taken
  function send_notification() {
    if [ "$SILENT" = "1" ]; then
      return 0
    fi

    if [ "$CLIPBOARD_ONLY" = "1" ]; then
      local message="Image copied to the clipboard"
      $NOTIFY_SEND "Screenshot saved" "$message" -a Screenshot
    else
      local message="Image saved in <i>$1</i> and copied to the clipboard"
      $NOTIFY_SEND "Screenshot saved" "$message" -i "$1" -a Screenshot
    fi
  }

  # Trim geometry
  function trim_geometry() {
    local geometry="$1"
    if [ -z "$geometry" ]; then
      exit
    fi

    local xy_str=$(echo "''${geometry}" | cut -d' ' -f1)
    local wh_str=$(echo "''${geometry}" | cut -d' ' -f2)
    local x=`echo "''${xy_str}" | cut -d',' -f1`
    local y=`echo "''${xy_str}" | cut -d',' -f2`
    local width=`echo "''${wh_str}" | cut -dx -f1`
    local height=`echo "''${wh_str}" | cut -dx -f2`

    local max_width=`$HYPRCTL monitors -j | $JQ -r '[.[] | (.x + .width)] | max'`
    local max_height=`$HYPRCTL monitors -j | $JQ -r '[.[] | (.y + .height)] | max'`

    local cropped_x=$x
    local cropped_y=$y
    local cropped_width=$width
    local cropped_height=$height

    if ((x + width > max_width)); then
        cropped_width=$((max_width - x))
    fi
    if ((y + height > max_height)); then
        cropped_height=$((max_height - y))
    fi

    if ((x < 0)); then
        cropped_x=0
        cropped_width=$((cropped_width + x))
    fi
    if ((y < 0)); then
        cropped_y=0
        cropped_height=$((cropped_height + y))
    fi

    printf "%s,%s %sx%s\n" "''${cropped_x}" "''${cropped_y}" "''${cropped_width}" "''${cropped_height}"
  }

  # Capture geometry
  function capture_geometry() {
    local geometry=`trim_geometry "$1"`
    if [ -z "$geometry" ]; then
      unfreeze
      exit 1
    fi

    if [ "$CLIPBOARD_ONLY" = "1" ]; then
      # Screenshot to clipboard only
      $WL_COPY < <(grim ''${CURSOR:+-c} -g "$geometry" -)
    else
      # Create output directory
      mkdir -p "$OUTPUT_DIR"
      # Take screenshot to file
      $GRIM ''${CURSOR:+-c} -g "$geometry" "$OUTPUT_PATH"
      # Also copy screenshot to file
      $WL_COPY < "$OUTPUT_PATH"
    fi

    send_notification "$OUTPUT_PATH"
  }

  # "Freeze" monitors if needed
  function freeze() {
    $HYPRPICKER -r -z &
    sleep 0.2 # Wait for it to open
    freeze_pid=$!
  }

  # "Unfreeze" monitors if needed
  function unfreeze() {
    if [ ! -z "$freeze_pid" ]; then
      kill $freeze_pid
    fi
  }

  # Capture current monitor
  function capture_current_monitor() {
    capture_geometry "`get_current_monitor_geometry`"
  }

  # Capture current window
  function capture_current_window() {
    capture_geometry "`get_current_window_geometry`"
  }

  # Capture some monitor
  function capture_monitor() {
    freeze
    capture_geometry "`get_monitor_geometry`"
    unfreeze
  }

  # Capture some visible window
  function capture_visible_window() {
    freeze
    capture_geometry "`choose_visible_window_geometry`"
    unfreeze
  }

  # Capture region
  function capture_region() {
    freeze
    capture_geometry "`get_region_geometry`"
    unfreeze
  }

  case "$MODE" in
    current-monitor) capture_current_monitor ;;
    current-window) capture_current_window ;;
    monitor) capture_monitor ;;
    window) capture_visible_window ;;
    region) capture_region ;;
    *)
      echo "Unknown mode specified: $MODE."
      exit 1
      ;;
  esac
''
