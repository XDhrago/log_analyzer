#!/bin/bash

#Color definition
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m' #Bold
NC='\033[0m' # No Color
bold=$(tput bold)
normal=$(tput sgr0)

# Function to validate IP address
validate_ip() {
    local ip="$1"
    
    # Split the IP address into octets
    #IFS='.' read -r i1 i2 i3 i4 <<< "$ip"
    
    i1=$(echo -e "$ip" | cut -d '.' -f 1)
    i2=$(echo -e "$ip" | cut -d '.' -f 2)
    i3=$(echo -e "$ip" | cut -d '.' -f 3)
    i4=$(echo -e "$ip" | cut -d '.' -f 4)
    
    # Check if there are exactly 4 octets
    if [ "$i1" ] && [ "$i2" ] && [ "$i3" ] && [ "$i4" ]; then
        # Check if each octet is a number and between 0 and 255
        if [ "$i1" -ge 0 ] && [ "$i1" -le 255 ] && \
           [ "$i2" -ge 0 ] && [ "$i2" -le 255 ] && \
           [ "$i3" -ge 0 ] && [ "$i3" -le 255 ] && \
           [ "$i4" -ge 0 ] && [ "$i4" -le 255 ]; then
            return 0  # Valid IP
        fi
    fi
    return 1  # Invalid IP
    }

while true; do
    echo -e "==============================="
    echo -e "    Apache Log file Analyzer"
    echo -e "==============================="
    echo -e "1. Define log file path"
    echo -e "2. Show first and last lines of the file"
    echo -e "3. Show first and last lines of the file of SPECIFIC IP"
    echo -e "4. List involved IPs"
    echo -e "5. Top 5 Involved IPs"
    echo -e "6. Check for known hacker tools"
    echo -e "7. Generate Full Report"
    echo -e "8. Clear the screen"
    echo -e "9. Exit"
    echo -e "==============================="
    read -p "Please select an option [1-9]: " option

    case $option in
        1)
            read -p "Enter new log path value: " new_path
            LOGPATH="$new_path"
            echo ""
            echo -e "${YELLOW}Path set to: $LOGPATH ${NC}"
            echo ""
            ;;
        2)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            
            
            #Operation
            echo -e # Blank line for better readability
            echo -e "==============================="
            echo -e "${YELLOW}First 5 lines${NC}"
            echo -e "==============================="
            head $LOGPATH -n5
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Last 5 lines${NC}"
            echo -e "==============================="
            tail $LOGPATH -n5
            
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;

	3)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            #Check IP address entered
            while true; do
		    read -p "Please enter a valid IP address: " ip_address
		    if validate_ip "$ip_address"; then
		       echo -e "The IP address $ip_address is valid."
		       break
		    else
		       echo -e "Invalid IP address. Please try again."
		    fi
            done
            
            #Operation
            echo -e # Blank line for better readability
            echo -e "==============================="
            echo -e "${YELLOW}First 5 lines${NC} of $ip_address"
            echo -e "==============================="
            cat $LOGPATH | grep $ip_address |head -n5
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Last 5 lines${NC} of $ip_address"
            echo -e "==============================="
            cat $LOGPATH | grep $ip_address |tail -n5
            
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;
        4)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            #Operation
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}IP addresses found${NC}"
            echo -e "==============================="
            echo -e
            cat $LOGPATH | cut -d " " -f1 | sort | uniq -c | sort -unr
            
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;
            
        5)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            #Operation
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Top 5 IP addresses${NC}"
            echo -e "==============================="
            echo -e
            
            cat $LOGPATH | cut -d " " -f1 | sort | uniq -c | sort -unr | head -n5
            
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;
        6)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            #Operation

            
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Tools Identified in the Log file${NC}"
            echo -e "==============================="
            echo -e
            
            #Check Nmap
            if grep -iq "nmap"  $LOGPATH
            then 
            	echo -e "${GREEN}NMAP USED${NC}";
            else
                echo -e "${RED}NMAP probably NOT USED${NC}";
            fi
            
            #Check Nikto
            if grep -iq "nikto"  $LOGPATH
            then 
            	echo -e "${GREEN}Nikto USED${NC}";
            else
                echo -e "${RED}Nikto probably NOT USED${NC}";
            fi
            
            #Check Nessus
            if grep -iq "nessus"  $LOGPATH
            then 
            	echo -e "${GREEN}Nessus USED${NC}";
            else
                echo -e "${RED}Nessus probably NOT USED${NC}";
            fi
            
            #Check curl
            if grep -iq "curl/"  $LOGPATH
            then 
            	echo -e "${GREEN}Requests via curl Identified${NC}";
            else
                echo -e "${RED}No requests via curl Identified${NC}";
            fi
            
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;
        7)
            #Check path
            if [ -z "$LOGPATH" ]; then
                echo -e "Error: PATH variable is empty. Returning to the menu..."
                read -p "Press Enter to continue..." empty_arg
                continue
            fi
            
            #Operation
                        
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Top 5 IP addresses${NC}"
            echo -e "==============================="
            echo -e
            
            cat $LOGPATH | cut -d " " -f1 | sort | uniq -c | sort -unr | head -n5
            
            
            ip_address=$(cat $LOGPATH  | cut -d " " -f1 | sort | uniq -c | sort -unr | head -n1 | sed -e 's/^ *//;s/ /,/' | cut -d "," -f2)
            
            echo -e # Blank line for better readability
            echo -e "==============================="
            echo -e "${YELLOW}First 5 lines${NC} of $ip_address"
            echo -e "==============================="
            cat $LOGPATH | grep $ip_address |head -n5
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Last 5 lines${NC} of $ip_address"
            echo -e "==============================="
            cat $LOGPATH | grep $ip_address |tail -n5
            
            echo -e
            echo -e "==============================="
            echo -e "${YELLOW}Tools Identified in the Log file${NC}"
            echo -e "==============================="
            echo -e
            
            #Check Nmap
            if grep -iq "nmap"  $LOGPATH
            then 
            	echo -e "${GREEN}NMAP USED${NC}";
            else
                echo -e "${RED}NMAP probably NOT USED${NC}";
            fi
            
            #Check Nikto
            if grep -iq "nikto"  $LOGPATH
            then 
            	echo -e "${GREEN}Nikto USED${NC}";
            else
                echo -e "${RED}Nikto probably NOT USED${NC}";
            fi
            
            #Check Nessus
            if grep -iq "nessus"  $LOGPATH
            then 
            	echo -e "${GREEN}Nessus USED${NC}";
            else
                echo -e "${RED}Nessus probably NOT USED${NC}";
            fi
            
            #Check curl
            if grep -iq "curl/"  $LOGPATH
            then 
            	echo -e "${GREEN}Requests via curl Identified${NC}";
            else
                echo -e "${RED}No requests via curl Identified${NC}";
            fi
            echo -e
            
            ;;
        8)
            clear
            ;;    
        9)
            echo -e "Exiting the menu. Goodbye!"
            exit 0
            ;;
        *)
            echo -e "Invalid option. Please select a valid number [1-5]."
            echo -e # Blank line for better readability
            read -p "Press Enter to return to the menu..." empty_arg
            ;;
    esac

done
