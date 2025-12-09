#!/bin/bash

echo "===== Git AutoSync Tool Started ====="

# Create folders
mkdir -p backup logs

LOG="logs/activity.log"

#Check git repo
if [ ! -d .git ]; 
then
	echo "Not a git repository"
    exit 1
fi

#Backup untracked files
UNTRACKED=$(git ls-files --others --exclude-standard)

if [ "$UNTRACKED" != "" ]; 
then
    echo "Untracked files found. Creating backup..."
   for f in $UNTRACKED; do
        cp "$f" "backup/$f"
        echo "→ Backed up: $f" 
done
fi

#Add all files
git add .
echo "All files added" 

#Commit if changes exist
if git diff --cached --quiet; 
then
    echo "No changes to commit" 
else
    read -p "Enter commit message: " MSG
    git commit -m "$MSG"
    echo "Commit done" 
fi

#Pull latest changes
echo "Pulling..."
git pull 


#Push changes
echo "Pushing..."
git push 

echo "===== Git AutoSync Completed =====" 
