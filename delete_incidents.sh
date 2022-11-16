#!/bin/bash


#user="" -- this is the access key generated in Prisma Cloud
#pass="" -- Secret key in Prisma Cloud
compute_url="https://europe-west3.cloud.twistlock.com/eu-2-143543850"
#remember that compute_url is the value found in Compute->System->Tools "path to console"
#so it's in the form https://europe-west3.cloud.twistlock.com/eu-2-12345678




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

delete_incidents () {
    curl -k -X PATCH -H "$accept" -u "$user:$pass" "$compute_url/api/v1/audits/incidents/acknowledge/$1?project=Central+Console" --data-raw '{"acknowledged":true}'
}
incidents=`curl -k -H "$accept" -u "$user:$pass" "$compute_url/api/v1/audits/incidents?acknowledged=false" |jq '.[] | ."_id"'`
#remove the double quotes from the output
incidents=`echo $incidents |sed s/\"//g`


for i in $incidents; do delete_incidents $i;done
