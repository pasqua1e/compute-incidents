#!/bin/bash


user="" #-- this is the access key generated in Prisma Cloud
pass="" #-- Secret key in Prisma Cloud
compute_url=""
#remember that compute_url is the value found in Compute->System->Tools "path to console"
#so it's in the form https://xx.cloud.twistlock.com/xxxx




accept="Accept: application/json"

usage() { 
	echo "This script is used to delete all the incidents"
    echo "in the Compute->Monitor->Incidents screen" 
	echo -e "\nMake sure you define the following variables:"
    echo "- user"
    echo "- pass"
    echo "- compute_url" 
	} 
# if less than two arguments supplied, display usage 
 
if [ -z "${user}" ] || [ -z "${pass}" ] || [ -z "${compute_url}" ]
then
    usage
    exit 1
fi

archive_incidents () {
    incidents=`curl -k -H "$accept" -u "$user:$pass" "$compute_url/api/v1/audits/incidents?acknowledged=false&limit=50&offset=0"`
    if [ "$incidents" == "null" ]
    then
      echo "all done, exiting...">/dev/tty
      return 1
    fi
    ids=`echo $incidents|jq '.[] | ."_id"'|sed s/\"//g`
    for i in $ids
    do
      curl -k -X PATCH -H "$accept" -u "$user:$pass" "$compute_url/api/v1/audits/incidents/acknowledge/$i?project=Central+Console" --data-raw '{"acknowledged":true}'
      :
    done
    return 0
}

status=0
while [ "$status" -eq "0" ]
do
  archive_incidents
  status=$?
done
