#!bin/bash

filename=$(basename $1)
extension=${filename##*.}
filename=${filename%.*}


mkdir ~/$filename
cd ~/$filename
git init

#clone hof repos
git clone https://github.com/johnhof/micron.git tmp
rm -rf tmp/.git

# update README
rm tmp/README.md
echo "# $filename" >> tmp/README.md
REPOSSTRING="  \"name\":\""$filename"\","

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

#rm tmp folder
rm -rf tmp

# add files
git remote add origin $1
git add .
git commit -m "Initial Commit"
git checkout -b development
git push origin development

#install dependencies
npm install

#DONE
echo -e "\e[1;31mYou are ready to develop now! Please go to /${filename} folder\e[0m"