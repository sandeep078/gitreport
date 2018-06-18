echo ""  >> report
echo ""  >> report
echo "Users detailed commits with respective files:"  >> report

for repodir in `cat list_repos | rev | awk -F '.' {'print $2'} | awk -F '/' {'print $1'} | rev`
do

  if [ -d $repodir ]
  then
  echo "$repodir exist.. getting the users commits"
  else
  echo "Some thing is going wrong.. please check $repodir not found"
  fi
  while read -r line
  do
  userdir="temp/`echo $line | sed 's/ //g'`"
  if [ ! -d $userdir ]
  then
  mkdir -p $userdir
  fi
  cd $repodir ; for repobranch in `git branch -r | grep -v HEAD ` ; do echo ""  > ../$userdir/$repodir-`echo $repobranch | awk -F/ {'print $2'}` ; echo "Branch: $repobranch" >> ../$userdir/$repodir-`echo $repobranch | awk -F/ {'print $2'}` ; git log --format="%s %h %d" $repobranch --name-status --since=2.days --author="$line" | sed '/^$/d' >> ../$userdir/$repodir-`echo $repobranch | awk -F/ {'print $2'}`  ; done ; cd -
  count=1
  for userbranchdir in `ls -ltrh $userdir | awk {'print $9'} | sed '/^$/d'`
  do
  filtercommits=`cat $userdir/$userbranchdir| wc -l`
  if [ $filtercommits -ne 2 ]
  then
  if [ $count -eq 1 ]
  then
  echo "###################################################################################" >> report
  echo "$line - Commits "  >> report
  count=$[$count +1]
  echo ""  >> report
  fi
  cat  $userdir/$userbranchdir >> report
  fi
  done
  done < daily_commit_uniq

done


