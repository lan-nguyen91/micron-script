#!bin/bash

mkdir $1
cd $1
git init

#clone hof repos
git clone https://github.com/johnhof/micron.git tmp
rm -rf tmp/.git

# update README
rm tmp/README.md
echo "# $1" >> tmp/README.md
REPOSSTRING="  \"name\":\""$1"\","

#update package.json
sed -i "2s/.*/${REPOSSTRING}/" tmp/package.json

# clean up
mv tmp/* ./
mv tmp/.[a-zA-Z0-9]* ./

#update port if user want to 
if [ "$#" -gt 1 ]
then
  PORTSTRING="    \"start\":\"PORT=${2} NODE_ENV=dev nodemon server\""
  sed -i "8s/.*/${PORTSTRING}/" ./package.json
fi

# add files
git add .
git status

#make initial commit
echo -e "\e[1;31mYou can now commit and push this initial structure!\e[0m"