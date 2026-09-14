#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task5_crud_app.sh
# @author       Azindo Abdul Razak
# @index        4186224
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  A simple terminal phonebook application that allows
#               users to add, view, search, update, and delete records.
# @date         9/14/2026
# -----------------------------------------------------------------

DATA_FILE="phonebook.txt"

# Display instructions for using the application.
usage() {
  echo "Usage: $0"
  echo "  Run the script without arguments to open the phonebook menu."
  echo "  Use -h or --help to display this help."
}

# Create the data file if it does not exist.
if [[ ! -f "$DATA_FILE" ]]; then
  if touch "$DATA_FILE"; then
    echo "Phonebook data file created."
  else
    echo "Error: Could not create the data file." >&2
    exit 1
  fi
fi

# Add a new phonebook record.
add_record() {
  echo
  echo "--- Add Contact ---"

  read -r -p "Enter name: " name
  if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty."
    return 1
  fi

  read -r -p "Enter phone number: " phone
  if [[ -z "$phone" ]]; then
    echo "Error: Phone number cannot be empty."
    return 1
  fi

  read -r -p "Enter email: " email
  if [[ -z "$email" ]]; then
    echo "Error: Email cannot be empty."
    return 1
  fi

  # Generate the next ID.
  if [[ -s "$DATA_FILE" ]]; then
    last_id=$(tail -n 1 "$DATA_FILE" | cut -d',' -f1)
    id=$((last_id + 1))
  else
    id=1
  fi

  if echo "$id,$name,$phone,$email" >> "$DATA_FILE"; then
    echo "Contact added successfully with ID $id."
  else
    echo "Error: Could not save the contact." >&2
    return 1
  fi

  return 0
}

# Display all phonebook records.
view_records() {
  echo
  echo "--- Phonebook ---"

  if [[ ! -s "$DATA_FILE" ]]; then
    echo "Phonebook is empty."
    return 0
  fi

  printf "%-5s %-20s %-18s %-30s\n" "ID" "Name" "Phone" "Email"
  echo "--------------------------------------------------------------------------"

  while IFS=',' read -r id name phone email; do
    printf "%-5s %-20s %-18s %-30s\n" "$id" "$name" "$phone" "$email"
  done < "$DATA_FILE"

  return 0
}

# Search for a contact.
search_record() {
  echo
  echo "--- Search Contact ---"

  read -r -p "Enter name or phone number to search: " search

  if [[ -z "$search" ]]; then
    echo "Error: Search value cannot be empty."
    return 1
  fi

  results=$(grep -i "$search" "$DATA_FILE")

  if [[ -z "$results" ]]; then
    echo "No contact found."
    return 0
  fi

  echo "$results"
  return 0
}

# Update an existing contact.
update_record() {
  echo
  echo "--- Update Contact ---"

  read -r -p "Enter ID of the contact to update: " id

  if [[ -z "$id" ]]; then
    echo "Error: ID cannot be empty."
    return 1
  fi

  if ! grep -q "^$id," "$DATA_FILE"; then
    echo "Contact with ID $id was not found."
    return 0
  fi

  # Back up the data before making the change.
  if cp "$DATA_FILE" "$DATA_FILE.bak"; then
    echo "Backup created."
  else
    echo "Error: Could not create backup. Update cancelled." >&2
    return 1
  fi

  read -r -p "Enter new name: " name
  if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty."
    return 1
  fi

  read -r -p "Enter new phone number: " phone
  if [[ -z "$phone" ]]; then
    echo "Error: Phone number cannot be empty."
    return 1
  fi

  read -r -p "Enter new email: " email
  if [[ -z "$email" ]]; then
    echo "Error: Email cannot be empty."
    return 1
  fi

  new_record="$id,$name,$phone,$email"

  if sed -i "s/^$id,.*/$new_record/" "$DATA_FILE"; then
    echo "Contact updated successfully."
  else
    echo "Error: Could not update the contact." >&2
    return 1
  fi

  return 0
}

# Delete a contact.
delete_record() {
  echo
  echo "--- Delete Contact ---"

  read -r -p "Enter ID of the contact to delete: " id

  if [[ -z "$id" ]]; then
    echo "Error: ID cannot be empty."
    return 1
  fi

  if ! grep -q "^$id," "$DATA_FILE"; then
    echo "Contact with ID $id was not found."
    return 0
  fi

  read -r -p "Are you sure you want to delete contact $id? (y/n): " answer

  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Delete cancelled."
    return 0
  fi

  # Back up the data before deleting the record.
  if cp "$DATA_FILE" "$DATA_FILE.bak"; then
    echo "Backup created."
  else
    echo "Error: Could not create backup. Delete cancelled." >&2
    return 1
  fi

  if sed -i "/^$id,/d" "$DATA_FILE"; then
    echo "Contact deleted successfully."
  else
    echo "Error: Could not delete the contact." >&2
    return 1
  fi

  return 0
}

# Show help if requested before starting the menu.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Reject unnecessary arguments.
if [[ $# -ne 0 ]]; then
  echo "Error: This application does not accept arguments." >&2
  usage
  exit 1
fi

# Main menu.
while true; do
  echo
  echo "=============================="
  echo "       PHONEBOOK APP"
  echo "=============================="
  echo "1. Add Contact"
  echo "2. View Contacts"
  echo "3. Search Contact"
  echo "4. Update Contact"
  echo "5. Delete Contact"
  echo "6. Exit"
  echo "=============================="

  read -r -p "Choose an option: " choice

  case "$choice" in
    1)
      add_record
      ;;
    2)
      view_records
      ;;
    3)
      search_record
      ;;
    4)
      update_record
      ;;
    5)
      delete_record
      ;;
    6)
      echo "Exiting phonebook. Goodbye!"
      exit 0
      ;;
    *)
      echo "Error: Invalid option. Please choose 1-6."
      ;;
  esac
done