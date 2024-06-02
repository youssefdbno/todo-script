#!/bin/bash

TASK_FILE="tasks.csv"

# Function to initialize the task file with headers if it does not exist
initialize_file() {
  if [[ ! -f "$TASK_FILE" ]]; then
    echo "ID,Title,Description,Location,DueDate,Completed" > "$TASK_FILE"
  fi
}
# Function to display the main menu
display_menu() {
  while true; do
    echo "====================================="
    figlet "TODO Menu" | lolcat
    echo "====================================="
    echo "1. Create a new task" | lolcat
    echo "2. Update an existing task" | lolcat
    echo "3. Delete a task" | lolcat
    echo "4. Show information about a task" | lolcat
    echo "5. List tasks of a given day" | lolcat
    echo "6. Search for a task by title" | lolcat
    echo "7. Display today's tasks" | lolcat
    echo "8. Exit" | lolcat
    echo "====================================="
    read -p "Choose an option [1-8]: " choice
    case "$choice" in
      1) create_task ;;
      2) update_task ;;
      3) delete_task ;;
      4) show_task ;;
      5) list_tasks ;;
      6) search_task ;;
      7) display_today_tasks ;;
      8) exit 0 ;;
      *) echo -e "\033[1;31mInvalid option. Please choose a number between 1 and 8.\033[0m" ;;
    esac
  done
}

# Function to generate a unique identifier
generate_id() {
  if [[ ! -f "$TASK_FILE" || $(wc -l < "$TASK_FILE") -eq 1 ]]; then
    echo 1
  else
    awk -F, 'NR>1 {print $1}' "$TASK_FILE" | sort -n | tail -n 1 | awk '{print $1 + 1}'
  fi
}

# Function to prompt user for task details
prompt_task_details() {
  local id=$(generate_id)
  read -p "Enter title (required): " title
  validate_non_empty "$title"

  read -p "Enter description (optional): " description
  read -p "Enter location (optional): " location
  read -p "Enter due date (YYYY-MM-DD, required): " due_date
  validate_date "$due_date"

  read -p "Enter due time (HH:MM, optional): " due_time
  local due_date_time="${due_date}T${due_time:-00:00}"

  read -p "Enter completion status (0 for uncompleted, 1 for completed): " completed
  validate_completion "$completed"

  echo "$id,$title,$description,$location,$due_date_time,$completed"
}

# Function to create a new task
create_task() {
  local task_details
  task_details=$(prompt_task_details)
  echo "$task_details" >> "$TASK_FILE"
  echo -e "\033[1;32mTask created successfully.\033[0m"
}

# Function to update an existing task
update_task() {
  read -p "Enter the ID of the task to update: " id
  validate_non_empty "$id"

  local existing_task
  existing_task=$(awk -F, -v id="$id" '$1 == id {print}' "$TASK_FILE")
  if [[ -z "$existing_task" ]]; then
    echo -e "\033[1;31mTask ID $id not found.\033[0m" >&2
    exit 1
  fi

  local task_details
  task_details=$(prompt_task_details)
  awk -F, -v id="$id" -v details="$task_details" 'BEGIN{OFS=","} $1 == id {$0 = details} {print}' "$TASK_FILE" > tmpfile && mv tmpfile "$TASK_FILE"
  echo -e "\033[1;32mTask updated successfully.\033[0m"
}

# Function to delete a task
delete_task() {
  read -p "Enter the ID of the task to delete: " id
  validate_non_empty "$id"
  awk -F, -v id="$id" '$1 != id {print}' "$TASK_FILE" > tmpfile && mv tmpfile "$TASK_FILE"
  echo -e "\033[1;32mTask deleted successfully.\033[0m"
}

# Function to show information about a task
show_task() {
  read -p "Enter the ID of the task to show: " id
  validate_non_empty "$id"
  local task=$(awk -F, -v id="$id" 'BEGIN{OFS=","} $1 == id {print}' "$TASK_FILE")
  if [[ -z "$task" ]]; then
    echo -e "\033[1;31mTask ID $id not found.\033[0m" >&2
    exit 1
  fi
  echo "====================================="
  echo "$task" | awk -F, '{
    printf "\033[1;34mID:\033[0m %s\n\033[1;34mTitle:\033[0m %s\n\033[1;34mDescription:\033[0m %s\n\033[1;34mLocation:\033[0m %s\n\033[1;34mDue Date:\033[0m %s\n\033[1;34mCompleted:\033[0m %s\n", $1, $2, $3, $4, $5, $6
  }'
  echo "====================================="
}

# Function to list tasks of a given day
list_tasks() {
  read -p "Enter the date (YYYY-MM-DD) to list tasks: " date
  validate_date "$date"
  echo "----- Completed tasks -----" | lolcat
  awk -F, -v date="$date" 'BEGIN{OFS=","} $5 ~ date && $6 == 1 {print}' "$TASK_FILE" | awk -F, '{
    printf "\033[1;32mID:\033[0m %s | \033[1;32mTitle:\033[0m %s | \033[1;32mDescription:\033[0m %s | \033[1;32mLocation:\033[0m %s | \033[1;32mDue Date:\033[0m %s\n", $1, $2, $3, $4, $5
  }'
  echo "----- Uncompleted tasks -----" | lolcat
  awk -F, -v date="$date" 'BEGIN{OFS=","} $5 ~ date && $6 == 0 {print}' "$TASK_FILE" | awk -F, '{
    printf "\033[1;31mID:\033[0m %s | \033[1;31mTitle:\033[0m %s | \033[1;31mDescription:\033[0m %s | \033[1;31mLocation:\033[0m %s | \033[1;31mDue Date:\033[0m %s\n", $1, $2, $3, $4, $5
  }'
}

# Function to search for a task by title
search_task() {
  read -p "Enter the title to search for: " title
  validate_non_empty "$title"
  awk -F, -v title="$title" 'BEGIN{OFS=","} $2 ~ title {print}' "$TASK_FILE" | awk -F, '{
    printf "\033[1;36mID:\033[0m %s | \033[1;36mTitle:\033[0m %s | \033[1;36mDescription:\033[0m %s | \033[1;36mLocation:\033[0m %s | \033[1;36mDue Date:\033[0m %s | \033[1;36mCompleted:\033[0m %s\n", $1, $2, $3, $4, $5, $6
  }'
}

# Function to display today's tasks
display_today_tasks() {
  local today=$(date +%Y-%m-%d)
  list_tasks "$today"
}

# Function to validate non-empty input
validate_non_empty() {
  local input=$1
  if [[ -z "$input" ]]; then
    echo -e "\033[1;31mInput cannot be empty\033[0m" >&2
    exit 1
  fi
}

# Function to validate date format (YYYY-MM-DD)
validate_date() {
  local date=$1
  if ! [[ "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo -e "\033[1;31mInvalid date format. Use YYYY-MM-DD.\033[0m" >&2
    exit 1
  fi
}

# Function to validate completion status
validate_completion() {
  local completed=$1
  if ! [[ "$completed" =~ ^[01]$ ]]; then
    echo -e "\033[1;31mCompletion status must be 0 (uncompleted) or 1 (completed).\033[0m" >&2
    exit 1
  fi
}

# Function to display help message
display_help() {
  figlet "TODO Script" | lolcat
  echo "Usage: $0 [option]" | lolcat
  echo "Options:" | lolcat
  echo "  create  - Create a new task" | lolcat
  echo "  update  - Update an existing task" | lolcat
  echo "  delete  - Delete a task" | lolcat
  echo "  show    - Show information about a task" | lolcat
  echo "  list    - List tasks of a given day" | lolcat
  echo "  search  - Search for a task by title" | lolcat
  echo "  today   - Display today's tasks" | lolcat
  echo "  help    - Display this help message" | lolcat
}

# Check if the tasks file exists and initialize if not
initialize_file

# Main script logic
if [[ $# -eq 0 ]]; then
  display_today_tasks
else
  case "$1" in
    create)
      create_task
      ;;
     update)
      update_task
      ;;
     delete)
      delete_task
      ;;
     show)
      show_task
      ;;
     list)
      list_tasks
      ;;
     search)
      search_task
      ;;
     today)
      display_today_tasks
      ;;
     help)
      display_help
      ;;
     *)
      echo -e "\033[1;31mInvalid option. Use 'help' to see available options.\033[0m" >&2
      display_help
      ;;
  esac
fi

# Check if the tasks file exists and initialize if not
#initialize_file

# Display the main menu
#display_menu
