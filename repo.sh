#!/bin/bash

if [ -e daily_commits ]
then
rm daily_commits
fi

for i in `cat list_repos | rev | awk -F '.' {'print $2'} | awk -F '/' {'print $1'} | rev`
do
  if [ -d $i ]
  then
    echo "$i - directory exist no need to clone.. just updating the repo"
    #cd $i ; git pull ; git log --format=='%H %an' --since=1.days ; cd -
    cd $i ; git pull ; git log --format='%an' --since=40.days >> ../daily_commits; cd -
  else
    echo "cloning the $i repo"
    repo_url=`grep "\/$i.git" list_repos`
    test_repo_url=`echo $repo_url | sed -r 's/\.git//g'`
    test_url=`curl -Is $test_repo_url | head -n 1 | awk {'print $2'} | cut -c1-2`
    if [ $test_url ==  '20' -o  $test_url == '30' ]
    then
      git clone $repo_url
      echo "$repo_url - repo successful cloned"
      #cd $i ; git log --format=='%H %an' --since=1.days >> ../daily_commits ; cd -
      cd $i ; git log --format=='%ae' --since=40.days >> ../daily_commits ; cd -
    else
      echo "$repo_url - something is going wrong - please check the repo URL $repo_url from list_repos file"
    fi
  fi
done

echo "Todays user commit report:" > report
echo "************************"  >> report
for j in `cat daily_commits | uniq`
do
echo "$j - `grep $j daily_commits | wc -l`" >> report
done


