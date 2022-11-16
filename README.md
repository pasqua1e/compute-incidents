# Batch archive Runtime Incidents


Simple bash script to archive all the incidents in the Compute->Monitor->Runtime->Incident Explorer screen

Note that the archived incidents won't be actually deleted, but simply flagged and moved to the "Archived" incident tab

![Incidents](./images/incidents_screenshot.png)

The script requires setting 3 variables: user, pass, compute_url

user and pass are the access/secret keys that can be created on Prisma Cloud under

Settings->Access Control->Access Keys->Add


