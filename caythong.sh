#!/usr/bin/env bash

cleanup() {
    tput sgr0
    tput cnorm
    tput cup $((rows - 1)) 0
}

trap cleanup INT TERM EXIT

clear
tput civis

rows=$(tput lines)
cols=$(tput cols)
center=$((cols / 2))

tree_height=18
max_by_rows=$((rows - 11))
max_by_cols=$((center - 4))

if [ "$max_by_rows" -lt "$tree_height" ]; then
    tree_height=$max_by_rows
fi
if [ "$max_by_cols" -lt "$tree_height" ]; then
    tree_height=$max_by_cols
fi

if [ "$tree_height" -lt 8 ]; then
    tput cnorm
    tput sgr0
    echo "Terminal too small. Please resize to at least 50x20."
    exit 1
fi

top=2
trunk_h=3
trunk_w=7
trunk_x=$((center - trunk_w / 2))
trunk_y=$((top + tree_height))
msg_y=$((trunk_y + trunk_h + 2))
if [ "$msg_y" -gt $((rows - 2)) ]; then
    msg_y=$((rows - 2))
fi

next_year=$(date +%Y)
next_year=$((next_year + 1))
messages=(
    "MERRY CHRISTMAS"
    "HAPPY NEW YEAR $next_year"
    "VIBE CODING MODE: ON"
)

declare -a ox
declare -a oy
orn_total=0

for ((r = 0; r < tree_height; r++)); do
    width=$((r * 2 + 1))
    x0=$((center - r))
    y=$((top + r))
    for ((k = 0; k < width; k++)); do
        if [ "$r" -gt 1 ] && [ "$r" -lt $((tree_height - 2)) ] && [ "$k" -gt 0 ] && [ "$k" -lt $((width - 1)) ]; then
            if [ $((RANDOM % 5)) -eq 0 ]; then
                ox[$orn_total]=$((x0 + k))
                oy[$orn_total]=$y
                orn_total=$((orn_total + 1))
            fi
        fi
    done
done

snow_count=$((cols / 4))
if [ "$snow_count" -lt 12 ]; then
    snow_count=12
fi
if [ "$snow_count" -gt 70 ]; then
    snow_count=70
fi

declare -a sx
declare -a sy
for ((i = 0; i < snow_count; i++)); do
    sx[$i]=$((RANDOM % cols))
    sy[$i]=$((RANDOM % (rows - 2) + 1))
done

draw_base() {
    tput setaf 2
    tput bold
    for ((r = 0; r < tree_height; r++)); do
        width=$((r * 2 + 1))
        x0=$((center - r))
        y=$((top + r))
        tput cup "$y" "$x0"
        for ((k = 0; k < width; k++)); do
            printf "^"
        done
    done

    tput setaf 3
    tput cup $((top - 1)) "$center"
    printf "*"

    tput setaf 1
    for ((i = 0; i < trunk_h; i++)); do
        tput cup $((trunk_y + i)) "$trunk_x"
        printf "|||_|||"
    done

    tput setaf 6
    tput cup $((trunk_y + trunk_h)) $((center - 11))
    printf "___/\\_____/\\_____/\\___"
}

frame=0
while true; do
    clear
    draw_base

    if [ $((frame % 2)) -eq 0 ]; then
        tput setaf 3
        tput cup $((top - 1)) "$center"
        printf "+"
    else
        tput setaf 7
        tput cup $((top - 1)) "$center"
        printf "*"
    fi

    if [ "$orn_total" -gt 0 ]; then
        burst=$((orn_total / 3))
        if [ "$burst" -lt 10 ]; then
            burst=10
        fi
        for ((n = 0; n < burst; n++)); do
            idx=$((RANDOM % orn_total))
            color=$((RANDOM % 7 + 1))
            tput setaf "$color"
            tput bold
            tput cup "${oy[$idx]}" "${ox[$idx]}"
            case $((RANDOM % 3)) in
                0) printf "o" ;;
                1) printf "@" ;;
                *) printf "O" ;;
            esac
        done
    fi

    tput setaf 7
    for ((i = 0; i < snow_count; i++)); do
        sy[$i]=$((sy[$i] + 1))
        if [ "${sy[$i]}" -ge $((rows - 1)) ]; then
            sy[$i]=1
            sx[$i]=$((RANDOM % cols))
        fi
        tput cup "${sy[$i]}" "${sx[$i]}"
        if [ $((RANDOM % 4)) -eq 0 ]; then
            printf "."
        else
            printf "*"
        fi
    done

    msg="${messages[$((frame / 20 % ${#messages[@]}))]}"
    msg_x=$(((cols - ${#msg}) / 2))
    if [ "$msg_x" -lt 0 ]; then
        msg_x=0
    fi
    tput setaf $(((frame % 6) + 1))
    tput bold
    tput cup "$msg_y" "$msg_x"
    printf "%s" "$msg"

    pulse=">>> keep calm and code bash <<<"
    pulse_x=$(((cols - ${#pulse}) / 2))
    if [ "$pulse_x" -lt 0 ]; then
        pulse_x=0
    fi
    tput sgr0
    tput setaf $((((frame + 3) % 6) + 1))
    tput cup $((msg_y + 1)) "$pulse_x"
    printf "%s" "$pulse"

    frame=$((frame + 1))
    sleep 0.12
done
