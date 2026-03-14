function iosEmulator
    set --local so ""
    set --local device ""
    
    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case '--so'
                set so $argv[(math $i + 1)]
                set i (math $i + 1)
            case '--device'
                set device $argv[(math $i + 1)]
                set i (math $i + 1)
        end
        set i (math $i + 1)
    end
    
    if test -z "$so"
        echo "Erro: Parâmetro so é obrigatorio"
        return 1
    end
    
    if test -z "$device"
        xcrun simctl list devices |grep -A 10 "iOS $so"| grep -i "$device"
        echo "teste"
        return 0
    end
    set id (xcrun simctl list devices |grep -A 10 "iOS 16"| grep -i "$device ("|head -n 1|awk -F '[()]' '{print $2}')
    
    if not echo "$id" | grep -Eq '^[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}$'
        set id (xcrun simctl list devices |grep -A 10 "iOS 16"| grep -i "$device ("|head -n 1|awk -F '[()]' '{print $4}' )
    end
    open -a Simulator --args -CurrentDeviceUDID "$id"
end
