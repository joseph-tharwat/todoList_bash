#!/bin/bash

doneNotation="[✓]"
notDoneNotation="[-]" #not used

while true #loop untill press exit
do 
    tasks=$(cat todoTasks.txt)
    selectedValue=$(echo "${tasks}" | rofi -dmenu -p "select/add/remove task: ")
    
    #close the program when selecting exit or press Esc
    if [[ "${selectedValue}" == "exit" || "${selectedValue}" == "" ]]; then
        break
    fi

    newText=""
    removedTask=""
    #loop through all the lines in the task file
    while read line; do
        
        if [[ "${line}" != "" && ${line} == "${selectedValue}" ]]; then 
            #add new task
            if [[ "${selectedValue}" == "add" ]]; then 
                newTask=$(echo "" | rofi -dmenu -p "Enter new task: ")
                newText=$(echo -e "${newText}\n${newTask}")
                newText=$(echo -e "${newText}\nadd\nremove\nexit")
                break 
            elif [[ "${selectedValue}" == "remove" ]]; then
                removedTask=$(echo "${tasks}" | rofi -dmenu -p "Enter task to remove: ")
                
                #add remove to the text
                newText=$(echo -e "${newText}\n${line}\nexit")

                #handle \n before and after the task
                removedTask=$(echo -e "\n${removedTask}\n")
                #delete the task from the text
                newText="${newText//"${removedTask}"/}" 
                break

            #task: done -> not done
            elif [[ "${selectedValue}" == *"${doneNotation}" ]]; then 
                line="${line//"${doneNotation}"/}" 
                echo "${line}"

            #task: not done -> done
            else 
                line="${line} ${doneNotation}"
            fi
        fi

        if [[ "${line}" != "" ]]; then
            newText=$(echo -e "${newText}\n${line}")
        
        fi
        
    done < todoTasks.txt #end of reading the tasks file

    #write the tasks after updating it
    echo "${newText}" > todoTasks.txt
    echo "${newText}"

done #end of the program
