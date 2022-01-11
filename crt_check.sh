#!/usr/bin/bash

# Check if certificates are valid
# jq tool should be installed !

MESSAGE="\"Certificate is up to date and has not expired\""
NAMESPACES=( "namespace1"   "ns2"    "ns3"    "ns4" ) # put here you namespaces

for project in "${NAMESPACES[@]}"; do
    namespace=${project}
    for certificate_name in $(kubectl -n ${namespace} get certificates --no-headers=True | awk {'print $1'}); do
        result=$(kubectl -n ${namespace} get certificate ${certificate_name} -o json | jq '.status.conditions[].message')
        if [[ ${result} != ${MESSAGE} ]]; then
            NOTIFICATION_ARRAY+=("Certificate for ${certificate_name^^} in namespace ${project^^} is expired, please check it !!! ")
        else
            NOTIFICATION_ARRAY+=("Certificate ${certificate_name^^} in namespace ${project^^} is valid!")
        fi
    done
done

for value in "${NOTIFICATION_ARRAY[@]}"; do echo $value; done
