#!/bin/bash

pause(){
  read -p "Press [Enter] key to continue..."
}

# read file
read_file(){
        echo "Enter the name of a file to read: "
        read filename
        # check if file exists
        if [ -f "$filename" ]; then
                input=$(cat "$filename")
                doEncryption
                pause
        else
                echo "Error: File not found."
        fi
}
 
input(){
  echo "Enter your message:"
  read input
  doEncryption
}


CC(){
        echo "Ceasar Cipher Encrypter/Decrypter"
        read -p"How many you want to shifted?" shift
        read -p"Enter e for encrypt or d for decrypt:" option

       if [ "$option" == "e" ]; 
          then
          echo "Encrypting..."
          encrypted=$(CC_encrypt $shift)
          echo "Encrypted message: $encrypted"
          read -p "Enter the name of the output file: " outputFile
          echo "$encrypted" >> "$outputFile"

        elif [ "$option" == 'd' ]; 
          then
          echo "Decrypting..."
          decrypted=$(CC_decrypt $shift)
          echo "Decrypted message: $decrypted"
          read -p "Enter the name of the output file: " outputFile
          echo "$decrypted" >> "$outputFile"
        else
            echo "Incorrect choice"
        fi

}

CC_encrypt(){
        local shift=$shift 
        local result=""
        for ((i=0; i<${#input}; i++)); do
                    char="${input:$i:1}"
                    ascii=$(printf "%d" "'$char")

                    if [[ "$char" =~ [a-z] ]]; then
                       new_ascii=$(( (ascii - 97 + shift) % 26 + 97 ))
                    else
                      new_ascii=$ascii
                    fi

                    new_char=$(printf "\\$(printf "%03o" "$new_ascii")")
                    result+="$new_char"
                  done

          echo $result
}

#Ceasar cipher decryption
CC_decrypt(){
        local shift=$((shift -26))
        local result=""
        for ((i=0; i<${#input}; i++)); do
                    char="${input:$i:1}" #get the character at position i
                    ascii=$(printf "%d" "'$char") #get the ascii value of the character

                    if [[ "$char" =~ [a-z] ]]; then
                       new_ascii=$(( (ascii - 97 + shift) % 26 + 97 ))
                    else
                      new_ascii=$ascii
                    fi

                    new_char=$(printf "\\$(printf "%03o" "$new_ascii")")
                    result+="$new_char"
                  done

          echo $result
}
        


doEncryption(){
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"    
        echo " Do Encryption and Decryption Menu "
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. ROT13"
        echo "2. Ceasar Cipher (CC)"
        echo "3. Exit"
        echo "Enter '1' for ROT13, '2' for Caesar Cipher (CC), or '3' to quit:"
        local pick
        read -p "Enter choice [1-3]: " pick


        case $pick in
                1) ROT13 ;;
                2) CC ;;
                3) exit 0 ;;
                *) echo "Error: Invalid choice" && sleep 2 ;;
        esac

}

ROT13(){
        echo "ROT13 Encrypter/Decrypter"
        read -p "Enter 'e' to encrypt or 'd' to decrypt: " option

          if [ "$option" == "e" ]; 
          then
            echo "You chose to encrypt"
            encryption=$(echo "$input" | tr "[A-Za-z]" "[D-ZA-Cd-za-c]")
            echo "encode:""$encryption"
            read -p "Enter the name of the output file: " outputFile
            echo "$encryption" >> "$outputFile"
            echo "The encrypted message has been saved to $outputFile"
          elif [ "$option" == 'd' ]; 
          then
            echo "You chose to decrypt"
            decryption=$(echo "$input" | tr "[D-ZA-Cd-za-c]" "[A-Za-z]")
            echo "decode:" $decryption
            read -p "Enter the name of the output file: " outputFile
            echo "$decryption" >> "$outputFile"
            echo "The decrypted message has been saved to $outputFile"
          else
            echo "Incorrect choice"
          fi
}
 
# function to display menus
show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"    
        echo " ENCRYPTION SYSTEM "
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. Read File"
        echo "2. Type Message"
        echo "3. Exit"
}



# read choice from user
read_options(){
        local choice
        read -p "Enter choice [ 1 - 3] " choice
        case $choice in
                1) read_file ;;
                2) input ;;
                3) exit 0;;
                *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
}
 
 
# main loop
while true
do
        show_menus
        read_options
done
